enum Environment { development, staging, production }

class Env {
  Env._();

  static Environment current = Environment.development;

  static bool get isDevelopment => current == Environment.development;
  static bool get isStaging => current == Environment.staging;
  static bool get isProduction => current == Environment.production;

  static bool get enableLogging => !isProduction;
  static bool get enableAnalytics => isProduction || isStaging;
  static bool get enableCrashReporting => isProduction || isStaging;

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

  static Duration get apiTimeout => const Duration(seconds: 15);
  static Duration get connectTimeout => const Duration(seconds: 15);
  static Duration get mistralReceiveTimeout => const Duration(seconds: 120);

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
