import "package:flutter/foundation.dart";

import "env.dart";

/// Main application configuration
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
      customConfig: customConfig ?? {},
    );
  }
}

class AppConfigData {
  const AppConfigData({
    required this.environment,
    this.customConfig = const {},
  });

  final Environment environment;
  final Map<String, dynamic> customConfig;

  // Getters
  bool get isDebug => kDebugMode;
  bool get isRelease => kReleaseMode;
  bool get isProfile => kProfileMode;

  String get appName => Env.appName;

  // Custom config getters
  int get maxRetries => getConfig<int>("maxRetries") ?? 0;

  T? getConfig<T>(String key, [T? defaultValue]) {
    return customConfig[key] as T? ?? defaultValue;
  }

  @override
  String toString() {
    return "AppConfig(env: $environment)";
  }
}
