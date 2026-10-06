import "package:firebase_core/firebase_core.dart";
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
import "core/configs/secrets.dart";
import "core/errors/failure.dart";
import "core/routing/app_navigator_key.dart";
import "firebase_options.dart";
import "shared/data/services/notification_service.dart";
import "shared/presentation/providers/index.dart"
    show sharedPreferencesProvider, flutterLocalNotificationsPluginProvider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(environment: Env.current, apiKey: Secrets.rodiumApiKey);

  AppLogger.configure(
    enabled: Env.enableLogging,
    showTimestamp: true,
    showEmoji: true,
    minLevel: Env.isDevelopment ? LogLevel.debug : LogLevel.warning,
    appName: Env.appName,
  );

  Log.i("Starting application in ${AppConfig.instance.appName} mode...");

  // Firebase doit être prêt avant le premier accès à Auth ou Firestore
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.i("Firebase initialisé");

  // SharedPreferences doit être initialisé avant runApp
  final prefs = await SharedPreferences.getInstance();
  Log.i("SharedPreferences initialisé");

  // Nécessaire pour planifier les notifications (zonedSchedule)
  tz.initializeTimeZones();
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  Log.d("Timezone local: ${timezoneInfo.identifier}");

  final notificationPlugin = await NotificationService.createAndInit(
    onTap: _onNotificationTap,
  );
  Log.i("NotificationService initialisé");

  runApp(
    ProviderScope(
      // Pas de relance automatique pour nos Failure : ce sont des réponses
      // métier (ex. NotRelayAgentFailure pour un usager) que l'UI doit
      // recevoir tout de suite. Riverpod les relancerait ~40 s sinon.
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

// Tap sur une notification pendant que l'app tourne
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
