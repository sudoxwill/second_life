import "package:flutter/foundation.dart";

import "env.dart";

class AppConfig {
  AppConfig._();

  static late final AppConfigData _instance;

  static AppConfigData get instance => _instance;

  static void initialize({
    required Environment environment,
    String? apiKey,
    Map<String, dynamic>? customConfig,
  }) {
    Env.current = environment;

    _instance = AppConfigData(
      environment: environment,
      apiKey: apiKey ?? "",
      customConfig: customConfig ?? {},
    );
  }
}

class AppConfigData {
  const AppConfigData({
    required this.environment,
    this.apiKey = "",
    this.customConfig = const {},
  });

  final Environment environment;

  // Clé de l'API Rodium, envoyée dans le header Authorization.
  final String apiKey;
  final Map<String, dynamic> customConfig;

  bool get isDebug => kDebugMode;
  bool get isRelease => kReleaseMode;
  bool get isProfile => kProfileMode;

  String get appName => Env.appName;

  int get maxRetries => getConfig<int>("maxRetries") ?? 0;

  T? getConfig<T>(String key, [T? defaultValue]) {
    return customConfig[key] as T? ?? defaultValue;
  }

  @override
  String toString() {
    return "AppConfig(env: $environment)";
  }
}
