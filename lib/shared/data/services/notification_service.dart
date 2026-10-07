import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:timezone/timezone.dart" as tz;

import "../../../core/configs/logger.dart";
import "../../../core/constants/notification_channels.dart";

// Top-level avec @pragma, sinon la fonction disparaît du build release.
// Appelée quand l'app était fermée. La navigation se fait ensuite dans
// App.initState() avec getNotificationAppLaunchDetails().
@pragma("vm:entry-point")
void _backgroundTapHandler(NotificationResponse response) {}

class NotificationPayload {
  const NotificationPayload({required this.route, this.extra});

  factory NotificationPayload.fromJsonString(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return NotificationPayload(
      route: map["route"] as String,
      extra: map["extra"] as String?,
    );
  }

  final String route;
  final String? extra;

  String toJsonString() => jsonEncode({"route": route, "extra": extra});
}

class NotificationService {
  NotificationService(this._plugin, {bool Function()? isEnabled})
    : _isEnabled = isEnabled ?? (() => true);

  final FlutterLocalNotificationsPlugin _plugin;
  // Préférence "Notifications" du profil : coupée, rien n'est affiché.
  final bool Function() _isEnabled;

  /// À appeler dans main() avant runApp().
  static Future<FlutterLocalNotificationsPlugin> createAndInit({
    required void Function(NotificationResponse) onTap,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings("notification_icon");

    // Sur iOS on demande la permission plus tard avec requestPermission(),
    // pas au démarrage.
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: _backgroundTapHandler,
    );

    await _createAndroidChannels(plugin);

    Log.i("Canaux Android créés", tag: "NotificationService");
    return plugin;
  }

  static Future<void> _createAndroidChannels(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    final androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationChannel.processingId,
        NotificationChannel.processingName,
        description: NotificationChannel.processingDescription,
        importance: Importance.low,
      ),
    );
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationChannel.generalId,
        NotificationChannel.generalName,
        description: NotificationChannel.generalDescription,
      ),
    );
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationChannel.remindersId,
        NotificationChannel.remindersName,
        description: NotificationChannel.remindersDescription,
        importance: Importance.high,
      ),
    );
    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        NotificationChannel.alertsId,
        NotificationChannel.alertsName,
        description: NotificationChannel.alertsDescription,
        importance: Importance.max,
      ),
    );
  }

  // Permissions

  /// Toujours true sur Android < 13, la permission y est implicite.
  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin == null) return false;
      final granted = await androidPlugin.requestNotificationsPermission();
      Log.i("Permission Android: $granted", tag: "NotificationService");
      return granted ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosPlugin == null) return false;
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      Log.i("Permission iOS: $granted", tag: "NotificationService");
      return granted ?? false;
    }

    return false;
  }

  /// Ne concerne qu'Android 12+, renvoie true ailleurs.
  Future<bool> canScheduleExact() async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return false;
    return await androidPlugin.canScheduleExactNotifications() ?? false;
  }

  // Affichage immédiat

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String channelId = NotificationChannel.generalId,
    NotificationPayload? payload,
  }) async {
    if (!_isEnabled()) return;
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelNameFor(channelId),
        importance: _importanceFor(channelId),
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload?.toJsonString(),
    );

    Log.d(
      "Notification affichée: id=$id, titre=$title",
      tag: "NotificationService",
    );
  }

  // Notifications programmées

  /// zonedSchedule gère les changements d'heure. Sans droit aux alarmes
  /// exactes, la notification passe en mode inexact.
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String channelId = NotificationChannel.remindersId,
    NotificationPayload? payload,
  }) async {
    if (!_isEnabled()) return;
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);
    final canExact = await canScheduleExact();

    if (!canExact) {
      Log.w(
        "Alarmes exactes non autorisées, planification inexacte utilisée",
        tag: "NotificationService",
      );
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelNameFor(channelId),
        importance: _importanceFor(channelId),
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDate,
      notificationDetails: details,
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact,
      payload: payload?.toJsonString(),
      matchDateTimeComponents: DateTimeComponents.time,
    );

    Log.d(
      "Notification planifiée: id=$id à $scheduledDate",
      tag: "NotificationService",
    );
  }

  // Annulation

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pendingNotifications() =>
      _plugin.pendingNotificationRequests();

  // Helpers privés

  static String _channelNameFor(String channelId) {
    switch (channelId) {
      case NotificationChannel.remindersId:
        return NotificationChannel.remindersName;
      case NotificationChannel.alertsId:
        return NotificationChannel.alertsName;
      case NotificationChannel.processingId:
        return NotificationChannel.processingName;
      default:
        return NotificationChannel.generalName;
    }
  }

  static Importance _importanceFor(String channelId) {
    switch (channelId) {
      case NotificationChannel.alertsId:
        return Importance.max;
      case NotificationChannel.remindersId:
        return Importance.high;
      case NotificationChannel.processingId:
        return Importance.low;
      default:
        return Importance.defaultImportance;
    }
  }
}
