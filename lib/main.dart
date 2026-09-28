import "package:flutter/material.dart";
import "package:second_life/app.dart";

import "core/configs/index.dart";

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

  runApp(const MainApp());
}
