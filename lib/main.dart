import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

import "app.dart";
import "core/configs/index.dart";
import "shared/presentation/providers/local_storage_provider.dart";

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

  // SharedPreferences doit être initialisé avant runApp
  final prefs = await SharedPreferences.getInstance();
  Log.i("SharedPreferences initialisé");

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MainApp(),
    ),
  );
}
