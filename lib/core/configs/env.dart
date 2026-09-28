/// Environment configuration for different build flavors.
/// URLs are injected at build time via --dart-define=API_BASE_URL=...
/// Fallback: emulator Android dev URL (10.0.2.2:8000).
enum Environment { development, staging, production }

class Env {
  Env._();

  static Environment current = Environment.development;

  static bool get isDevelopment => current == Environment.development;
  static bool get isStaging => current == Environment.staging;
  static bool get isProduction => current == Environment.production;

  // Feature Flags
  static bool get enableLogging => !isProduction;
  static bool get enableAnalytics => isProduction || isStaging;
  static bool get enableCrashReporting => isProduction || isStaging;

  // App Configuration
  static String get appName {
    switch (current) {
      case Environment.development:
        return "SecondLife (Dev)";
      case Environment.staging:
        return "SecondLife (Beta)";
      case Environment.production:
        return "SecondLife";
    }
  }

  // Timeouts
  static Duration get apiTimeout => const Duration(seconds: 15);
  static Duration get connectTimeout => const Duration(seconds: 15);
  static Duration get mistralReceiveTimeout => const Duration(seconds: 120);

  // Storage Keys
  static String get storagePrefix {
    switch (current) {
      case Environment.development:
        return "dev_";
      case Environment.staging:
        return "staging_";
      case Environment.production:
        return "";
    }
  }
}
