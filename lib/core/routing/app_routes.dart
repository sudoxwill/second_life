class AppRoutes {
  AppRoutes._();

  // ─── Racine & onboarding ───────────────────
  static const String root = "/";

  /// L'écran d'onboarding est actuellement monté sur
  /// [root]. Conservée pour lisibilité des call sites.
  static const String onboarding = root;

  // ─── Authentification ──────────────────────
  static const String authLogin = "/auth/login";
  static const String authSignup = "/auth/signup";
  static const String authForgot = "/auth/forgot";

  // ─── Onglets shell (4 branches) ───────────
  static const String home = "/home";
  static const String places = "/places";
  static const String history = "/history";
  static const String profile = "/profile";

  // ─── Actions ─────────────────────────
  static const String scan = "/scan";

  // ─── Liste des points de recyclage et de traitement ─────────
  static const String placesList = "/places/:detail";
  static String placeDetailPath(String id) => "/places/$id";

  // ─── Historique de traitement ─────────────────────
  static const String historyDetail = "/history/:detail";
  static String historyDetailPath(String id) => "/history/$id";

}
