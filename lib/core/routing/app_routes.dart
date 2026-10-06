class AppRoutes {
  AppRoutes._();

  // Racine & onboarding
  static const String root = "/";

  static const String onboarding = "/onboarding";

  // Authentification
  static const String authLogin = "/auth/login";
  static const String authSignup = "/auth/signup";
  static const String authForgot = "/auth/forgot";
  static const String authResetPassword = "/auth/reset-password";

  // Onglets shell (4 branches)
  static const String home = "/home";
  static const String places = "/places";
  static const String history = "/history";
  static const String profile = "/profile";

  // Shell Agent (4 branches)
  static const String agentHome     = "/agent/home";
  static const String agentDeposits = "/agent/deposits";
  static const String agentHistory  = "/agent/history";
  static const String agentProfile  = "/agent/profile";

  // Scan
  static const String scan = "/scan";

  // Liste des points de recyclage et de traitement
  static const String placeDetail = "/places/:id";
  static String placeDetailPath(String id) => "/places/$id";

  // Historique de traitement
  static const String historyDetail = "/history/:id";
  static String historyDetailPath(String id) => "/history/$id";

  // Settings
  static const settings = "/settings";
}
