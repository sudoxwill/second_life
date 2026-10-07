import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/auth/presentation/pages/index.dart";
import "../../features/auth/presentation/providers/auth_provider.dart";
import "../../features/deposit/presentation/pages/index.dart";
import "../../features/history/presentation/pages/index.dart";
import "../../features/home/presentation/pages/index.dart";
import "../../features/onboarding/presentation/pages/index.dart";
import "../../features/places/presentation/pages/place_detail_page.dart";
import "../../features/places/presentation/pages/places_map_page.dart";
import "../../features/profile/presentation/pages/index.dart";
import "../../features/rewards/presentation/pages/rewards_page.dart";
import "../../features/ticket_validation/presentation/pages/agent_history_page.dart";
import "../../features/rewards/presentation/pages/reward_detail_page.dart";
import "../../features/rewards/presentation/pages/rewards_catalog_page.dart";
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
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.root,
    navigatorKey: AppNavigatorKey.instance,
    debugLogDiagnostics: Env.enableLogging,
    redirect: (context, state) {
      final role = ref.read(authProvider);
      final loc = state.matchedLocation;

      // Non authentifié ou restauration de session en cours
      if (role == null) {
        if (loc == AppRoutes.root) return null;
        if (loc == AppRoutes.onboarding ||
            loc == AppRoutes.authLogin ||
            loc == AppRoutes.authSignup ||
            loc == AppRoutes.authForgot ||
            loc == AppRoutes.authResetPassword) {
          return null;
        }
        return AppRoutes.authLogin;
      }

      // Nom d'utilisateur pas encore choisi (connexion Google)
      if (role == AppRole.pendingUsername) {
        if (loc == AppRoutes.authUsernameSetup) return null;
        return AppRoutes.authUsernameSetup;
      }

      // Agent : autorisé uniquement sur /agent/*
      if (role == AppRole.agent) {
        if (!loc.startsWith("/agent")) return AppRoutes.agentHome;
        return null;
      }

      // Usager : ni /agent/*, ni pages d'auth, ni onboarding
      if (role == AppRole.user) {
        if (loc.startsWith("/agent") ||
            loc.startsWith("/auth/") ||
            loc == AppRoutes.onboarding ||
            loc == AppRoutes.root) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    errorBuilder: (context, state) => const _RouterErrorPage(),
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.root,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const SplashPage(),
        ),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: const OnboardingPage(),
        ),
      ),

      // Authentification
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
          child: ForgotPasswordPage(initialEmail: state.extra as String?),
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
          // Firebase choisit le nouveau mot de passe sur sa page web :
          // le lien de l'app mène au même écran que "mot de passe oublié".
          child: const ForgotPasswordPage(),
        ),
      ),

      // Scan
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

      // Coque usager, 4 onglets
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

      // Coque agent, 4 onglets
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
                  child: const AgentDepositPage(),
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

      // Catalogue des récompenses (usager)
      GoRoute(
        path: AppRoutes.rewards,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: const RewardsPage(),
        ),
      ),

      // Écrans de détail
      GoRoute(
        path: AppRoutes.placeDetail,
        pageBuilder: (context, state) => AppTransitions.pushedScreen(
          context: context,
          state: state,
          child: PlaceDetailPage(id: state.pathParameters["id"]!),
        ),
      ),

      // Les réglages sont dans l'onglet Profil (agent : renvoyé vers son
      // espace par la redirection globale).
      GoRoute(path: AppRoutes.settings, redirect: (_, _) => AppRoutes.profile),
    ],
  );
  ref.listen(authProvider, (_, _) => router.refresh());
  return router;
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
