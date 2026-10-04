import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/auth/presentation/pages/index.dart";
import "../../features/home/presentation/pages/home_page.dart";
import "../../features/onboarding/presentation/pages/index.dart";
import "../../shared/presentation/app_shell.dart";
import "../configs/env.dart";
import "../theme/app_spacing.dart";
import "app_navigator_key.dart";
import "app_routes.dart";
import "app_transitions.dart";

part "app_router.g.dart";

/// GoRouter global de SecondLife.
///
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    navigatorKey: AppNavigatorKey.instance,
    debugLogDiagnostics: Env.enableLogging,
    redirect: (_, _) => null,
    errorBuilder: (context, state) => const _RouterErrorPage(),
    routes: [
      // ─── Splash ───────────────────────────
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const SplashPage(),
        ),
      ),

      // ─── Onboarding ───────────────────────────
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const OnboardingPage(),
        ),
      ),

      // ─── Authentification ────────────────────
      GoRoute(
        path: AppRoutes.authLogin,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignup,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authForgot,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const _Placeholder(title: "ForgotPassword"),
        ),
      ),
      GoRoute(
        path: AppRoutes.authResetPassword,
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          context: context,
          state: state,
          child: const _Placeholder(title: "AuthResetPassword"),
        ),
      ),

      // ─── Scan ───────────────────────────
      GoRoute(
        path: AppRoutes.scan,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const _Placeholder(title: "Scanning..."),
        ),
      ),

      // ─── Shell — 4 onglets ────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // ── Home ───────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const HomePage(),
                ),
              ),
            ],
          ),

          // ── Places ───────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.places,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const _Placeholder(title: "Points de recyclage"),
                ),
              ),
            ],
          ),

          // ── History ───────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const _Placeholder(title: "Historique complet"),
                ),
              ),
            ],
          ),

          // ── Profile ───────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const _Placeholder(title: "Profil"),
                ),
              ),
            ],
          ),
        ],
      ),

      // ─── Detailed screens ────────────────────
      GoRoute(
        path: AppRoutes.placeDetail,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: _Placeholder(title: "Place ${state.pathParameters["id"]!}"),
        ),
      ),

      GoRoute(
        path: AppRoutes.history,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: _Placeholder(
            title: "Historique ${state.pathParameters["id"]!}",
          ),
        ),
      ),

      // ─── Settings ──────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const _Placeholder(title: "Settings"),
        ),
      ),
    ],
  );
}

/// Écran placeholder — texte centré, en attendant l'implémentation réelle.
class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Text(
            "$title — bientôt.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

/// AppShell
// class AppShell extends StatelessWidget {
//   const AppShell({required this.navigationShell, super.key});
//
//   final StatefulNavigationShell navigationShell;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: navigationShell,
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.home),
//             label: "Accueil",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.map),
//             label: "Points de recyclage",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.rotateCcwClock),
//             label: "Historique",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(LucideIcons.userRound),
//             label: "Profil",
//           ),
//         ],
//       ),
//     );
//   }
// }

/// Écran d'erreur du router.
class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cet écran n'existe pas encore.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVSm,
              Text(
                "Reviens plus tard, ou reprends depuis l'accueil.",
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
