import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:second_life/shared/presentation/providers/theme_provider.dart";

import "core/configs/env.dart";
import "core/configs/logger.dart";
import "core/routing/app_navigator_key.dart";
import "core/routing/app_router.dart";
import "l10n/app_localizations.dart";
import "shared/data/services/notification_service.dart";
import "shared/presentation/providers/index.dart";

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {

  @override
  void initState() {
    super.initState();
    _handleLaunchFromNotification();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(appLocaleProvider);
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp.router(
      locale: locale,
      title: Env.appName,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  // Gère le tap sur notification quand l'app était terminée.
  // Les cas foreground/background sont gérés par _onNotificationTap dans main.dart.
  Future<void> _handleLaunchFromNotification() async {
    final plugin = ref.read(flutterLocalNotificationsPluginProvider);
    final details = await plugin.getNotificationAppLaunchDetails();

    if (details == null || !details.didNotificationLaunchApp) return;

    final rawPayload = details.notificationResponse?.payload;
    if (rawPayload == null || rawPayload.isEmpty) return;

    try {
      final payload = NotificationPayload.fromJsonString(rawPayload);
      Log.i(
        "App lancée depuis notification, route: ${payload.route}",
        tag: "App",
      );
      // addPostFrameCallback : GoRouter doit être monté avant de naviguer
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppNavigatorKey.instance.currentState?.context.go(payload.route);
        }
      });
    } catch (e, st) {
      Log.e("Échec parsing payload (cold launch)", error: e, stackTrace: st);
    }
  }
}
