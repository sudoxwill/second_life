import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

import "../routing/app_routes.dart";

/// Extensions de navigation SecondLife — enveloppent GoRouter avec les vraies
/// destinations métier de l'app.
extension NavigationExtensions on BuildContext {

  // ─── Onboarding ─────────────────────────────

  void goOnboarding() => go(AppRoutes.onboarding);

  // ─── Auth ─────────────────────────────────

  void goAuthLogin() => go(AppRoutes.authLogin);
  void pushAuthLogin() => push(AppRoutes.authLogin);
  void goAuthSignup() => go(AppRoutes.authSignup);
  void pushAuthSignup() => push(AppRoutes.authSignup);
  void goAuthForgot() => go(AppRoutes.authForgot);
  void pushAuthForgot() => push(AppRoutes.authForgot);
  void goAuthResetPassword() => go(AppRoutes.authResetPassword);
  void pushAuthResetPassword() => push(AppRoutes.authResetPassword);

  // ─── AppShell ──────────────────────────────

  void goHome() => go(AppRoutes.home);
  void goPlaces() => go(AppRoutes.places);
  void goHistory() => go(AppRoutes.history);
  void goProfile() => go(AppRoutes.profile);

  // ─── Places Details ──────────────────────────────

  void goPlaceDetail(String id) => go(AppRoutes.placeDetailPath(id));
  void pushPlaceDetail(String id) => push(AppRoutes.placeDetailPath(id));

  // ─── History Details ──────────────────────────────

  void goHistoryDetail(String id) => go(AppRoutes.historyDetailPath(id));
  void pushHistoryDetail(String id) => push(AppRoutes.historyDetailPath(id));

  // ─── Scan ────────────────────────────────

  void goScan() => go(AppRoutes.scan);
  void pushScan() => push(AppRoutes.scan);

  // ─── Settings ─────────────────────────────

  void goTrash() => go(AppRoutes.settings);
  void pushTrash() => push(AppRoutes.settings);

  // ─── Back ───────────────────────────────

  void popScreen<T extends Object?>([T? result]) {
    if (canPop()) pop<T>(result);
  }
}
