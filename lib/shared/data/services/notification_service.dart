import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:timezone/timezone.dart" as tz;

import "../../../core/configs/logger.dart";
import "../../../core/constants/notification_channels.dart";

// Doit être top-level + @pragma pour survivre au tree-shaking en release build.
// Appelé quand l'app est TERMINÉE et que l'utilisateur tappe une notification.
// La navigation est prise en charge par App.initState()
// via getNotificationAppLaunchDetails().
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
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  /// Crée et initialise le plugin. À appeler dans main() avant runApp().
  /// Retourne le plugin initialisé pour l'injecter dans le ProviderScope.
  static Future<FlutterLocalNotificationsPlugin> createAndInit({
    required void Function(NotificationResponse) onTap,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();

    const androidSettings =
        AndroidInitializationSettings("notification_icon");

    // Les permissions iOS sont demandées explicitement via requestPermission()
    // au bon moment UX — PAS au démarrage de l'app.
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await plugin.initialize(settings:
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
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
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannel.processingId,
        NotificationChannel.processingName,
        description: NotificationChannel.processingDescription,
        importance: Importance.low,
      ),
    );
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannel.generalId,
        NotificationChannel.generalName,
        description: NotificationChannel.generalDescription,
      ),
    );
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannel.remindersId,
        NotificationChannel.remindersName,
        description: NotificationChannel.remindersDescription,
        importance: Importance.high,
      ),
    );
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        NotificationChannel.alertsId,
        NotificationChannel.alertsName,
        description: NotificationChannel.alertsDescription,
        importance: Importance.max,
      ),
    );
  }

  // ─── Permissions ───────────────────────────────────────────────────────────

  /// Demande la permission de notifications.
  /// Android < 13 : retourne true (permission implicite).
  /// iOS : affiche le dialog système si pas encore décidé.
  Future<bool> requestPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return false;
      final granted = await androidPlugin.requestNotificationsPermission();
      Log.i("Permission Android: $granted", tag: "NotificationService");
      return granted ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
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

  /// Android 12+ uniquement : vérifie si les alarmes exactes sont autorisées.
  /// Sur iOS et Android < 12 : retourne toujours true.
  Future<bool> canScheduleExact() async {
    if (defaultTargetPlatform != TargetPlatform.android) return true;
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;
    return await androidPlugin.canScheduleExactNotifications() ?? false;
  }

  // ─── Show ──────────────────────────────────────────────────────────────────

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String channelId = NotificationChannel.generalId,
    NotificationPayload? payload,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelNameFor(channelId),
        importance: _importanceFor(channelId),
        // icon: "notification_icon",
        // color: AppColors.primary,
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

  // ─── Schedule ──────────────────────────────────────────────────────────────

  /// Planifie une notification à [scheduledDate] dans le fuseau horaire local.
  /// Utilise zonedSchedule() pour respecter les changements d'heure (DST).
  /// Si les alarmes exactes ne sont pas autorisées, bascule en mode inexact.
  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String channelId = NotificationChannel.remindersId,
    NotificationPayload? payload,
  }) async {
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
        // icon: "notification_icon",
        // color: AppColors.primary,
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

  // ─── Cancel ────────────────────────────────────────────────────────────────

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pendingNotifications() =>
      _plugin.pendingNotificationRequests();

  // ─── Helpers privés ────────────────────────────────────────────────────────

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
