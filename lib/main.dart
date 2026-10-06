import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_timezone/flutter_timezone.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:timezone/data/latest_all.dart" as tz;
import "package:timezone/timezone.dart" as tz;

import "app.dart";
import "core/configs/index.dart";
import "core/routing/app_navigator_key.dart";
import "shared/data/services/notification_service.dart";
import "shared/presentation/providers/index.dart" show sharedPreferencesProvider, flutterLocalNotificationsPluginProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de la configuration globale
  AppConfig.initialize(environment: Env.current);

  // Configure Logger
  AppLogger.configure(
    enabled: Env.enableLogging,
    showTimestamp: true,
    showEmoji: true,
    minLevel: Env.isDevelopment ? LogLevel.debug : LogLevel.warning,
    appName: Env.appName,
  );

  Log.i("Starting application in ${AppConfig.instance.appName} mode...");

  // Firebase passe en premier : Auth et Firestore en ont besoin dès le départ.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.i("Firebase initialisé");

  // Sans le fuseau horaire local, les notifications programmées partiraient
  // à la mauvaise heure.
  // SharedPreferences doit être initialisé avant runApp
  final prefs = await SharedPreferences.getInstance();
  Log.i("SharedPreferences initialisé");

  // Timezone — requis pour zonedSchedule (notifications planifiées)
  tz.initializeTimeZones();
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  Log.d("Timezone local: ${timezoneInfo.identifier}");

  // Notifications
  final notificationPlugin = await NotificationService.createAndInit(
    onTap: _onNotificationTap,
  );
  Log.i("NotificationService initialisé");

  runApp(
    ProviderScope(
      // Nos Failure sont des réponses métier (par exemple un usager qui n'est
      // pas agent relais), pas des pannes passagères : inutile de réessayer,
      // l'UI doit les afficher tout de suite. Sinon Riverpod insiste ~40 s.
      retry: (retryCount, error) => error is Failure
          ? null
          : ProviderContainer.defaultRetry(retryCount, error),
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        flutterLocalNotificationsPluginProvider.overrideWithValue(
          notificationPlugin,
        ),
      ],
      child: const MainApp(),
    ),
  );
}

// Tap depuis premier plan ou arrière-plan (app vivante)
void _onNotificationTap(NotificationResponse response) {
  final rawPayload = response.payload;
  if (rawPayload == null || rawPayload.isEmpty) return;

  try {
    final payload = NotificationPayload.fromJsonString(rawPayload);
    Log.i("Notification tappée, route: ${payload.route}");
    AppNavigatorKey.instance.currentState?.context.go(payload.route);
  } catch (e, st) {
    Log.e("Échec parsing payload notification", error: e, stackTrace: st);
  }
}
