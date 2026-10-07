import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/auth/presentation/pages/index.dart";
import "../../features/auth/presentation/providers/auth_provider.dart";
import "../../features/history/presentation/pages/index.dart";
import "../../features/home/presentation/pages/index.dart";
import "../../features/onboarding/presentation/pages/index.dart";
import "../../features/places/presentation/pages/place_detail_page.dart";
import "../../features/places/presentation/pages/places_map_page.dart";
import "../../features/profile/presentation/pages/index.dart";
import "../../features/ticket_validation/presentation/pages/agent_scanner_page.dart";
import "../../features/waste_analysis/presentation/pages/waste_scan_page.dart";
import "../../shared/presentation/pages/index.dart";
import "../configs/env.dart";
import "../extensions/build_context_extension.dart";
import "../theme/app_spacing.dart";
import "app_navigator_key.dart";
import "app_routes.dart";
import "app_transitions.dart";

part "app_router.g.dart";

/// GoRouter global de SecondLife.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    navigatorKey: AppNavigatorKey.instance,
    debugLogDiagnostics: Env.enableLogging,
    redirect: (context, state) {
      final role = ref.read(authProvider);
      final loc = state.matchedLocation;

      // ─── Non authentifié ─────────────────────────────────────────────
      if (role == null) {
        // La splash gère elle-même sa navigation
        if (loc == AppRoutes.root) return null;
        // Pages publiques accessibles sans compte
        if (loc == AppRoutes.onboarding ||
            loc == AppRoutes.authLogin ||
            loc == AppRoutes.authSignup ||
            loc == AppRoutes.authForgot ||
            loc == AppRoutes.authResetPassword) {
          return null;
        }
        // Toute route protégée → login
        return AppRoutes.authLogin;
      }

      // ─── Username pas encore choisi (après OAuth) ────────────────────
      if (role == AppRole.pendingUsername) {
        if (loc == AppRoutes.authUsernameSetup) return null;
        return AppRoutes.authUsernameSetup;
      }

      // ─── Agent ───────────────────────────────────────────────────────
      if (role == AppRole.agent) {
        if (loc == AppRoutes.home ||
            loc == AppRoutes.places ||
            loc == AppRoutes.history ||
            loc == AppRoutes.profile ||
            loc == AppRoutes.authLogin ||
            loc == AppRoutes.authSignup ||
            loc == AppRoutes.authUsernameSetup ||
            loc == AppRoutes.onboarding ||
            loc == AppRoutes.root) {
          return AppRoutes.agentHome;
        }
      }

      // ─── User ────────────────────────────────────────────────────────
      if (role == AppRole.user) {
        if (loc.startsWith("/agent") ||
            loc == AppRoutes.authLogin ||
            loc == AppRoutes.authSignup ||
            loc == AppRoutes.authUsernameSetup ||
            loc == AppRoutes.onboarding ||
            loc == AppRoutes.root) {
          return AppRoutes.home;
        }
      }

      return null;
    },
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
          child: _Placeholder(title: context.l10n.routerScreenForgotPassword),
        ),
      ),
      GoRoute(
        path: AppRoutes.authUsernameSetup,
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          context: context,
          state: state,
          child: const UsernameSetupPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authResetPassword,
        pageBuilder: (context, state) => AppTransitions.fadeSlide(
          context: context,
          state: state,
          child: _Placeholder(title: context.l10n.routerScreenResetPassword),
        ),
      ),

      // ─── Scan ───────────────────────────
      GoRoute(
        path: AppRoutes.scan,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const WasteScanPage(),
        ),
      ),

      // Scan du QR de dépôt (agent)
      GoRoute(
        path: AppRoutes.agentScan,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const AgentScannerPage(),
        ),
      ),

      // ─── Shell User — 4 onglets ──────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            UserShell(navigationShell: navigationShell),
        branches: [
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.places,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const PlacesMapPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const UserHistoryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const UserProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // ─── Shell Agent — 4 onglets ─────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AgentShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.agentHome,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const AgentDashboardPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.agentDeposits,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: _Placeholder(
                    title: context.l10n.routerScreenAgentDeposits,
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.agentHistory,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const AgentHistoryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.agentProfile,
                pageBuilder: (context, state) => AppTransitions.fade(
                  context: context,
                  state: state,
                  child: const AgentProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // ─── Detailed screens ────────────────────
      GoRoute(
        path: AppRoutes.placeDetail,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: PlaceDetailPage(id: state.pathParameters["id"]!),
        ),
      ),

      // ─── Settings ──────────────────────────────
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: _Placeholder(title: context.l10n.routerScreenSettings),
        ),
      ),
    ],
  );
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(title), elevation: 0),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPaddingH,
          child: Text(
            l10n.routerSoon(title),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _RouterErrorPage extends StatelessWidget {
  const _RouterErrorPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                l10n.routerErrorTitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapVSm,
              Text(
                l10n.routerErrorSubtitle,
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
