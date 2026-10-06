import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/auth/presentation/pages/index.dart";
import "../../features/auth/presentation/providers/auth_provider.dart";
import "../../features/onboarding/presentation/pages/index.dart";
import "../../features/profile/presentation/pages/profile_page.dart";
import "../../features/ticket_validation/presentation/pages/agent_dashboard_page.dart";
import "../../features/ticket_validation/presentation/pages/agent_history_page.dart";
import "../../features/ticket_validation/presentation/pages/agent_scanner_page.dart";
import "../../features/ticket_validation/presentation/pages/pending_deposits_page.dart";
import "../../features/ticket_validation/presentation/widgets/relay_agent_builder.dart";
import "../../features/waste_analysis/presentation/pages/citizen_history_page.dart";
import "../../features/waste_analysis/presentation/pages/citizen_home_page.dart";
import "../../features/waste_analysis/presentation/pages/relay_map_page.dart";
import "../../features/waste_analysis/presentation/pages/waste_scan_page.dart";
import "../../shared/presentation/agent_shell.dart";
import "../../shared/presentation/user_shell.dart";
import "../configs/env.dart";
import "../extensions/build_context_extension.dart";
import "../extensions/navigation_extension.dart";
import "../theme/app_spacing.dart";
import "app_navigator_key.dart";
import "app_routes.dart";
import "app_transitions.dart";

part "app_router.g.dart";

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.root,
    navigatorKey: AppNavigatorKey.instance,
    debugLogDiagnostics: Env.enableLogging,
    redirect: (context, state) {
      final role = ref.read(authProvider);
      final loc = state.matchedLocation;

      if (role == AppRole.agent) {
        // Un agent n'a rien à faire dans l'espace usager
        if (loc == AppRoutes.home ||
            loc == AppRoutes.places ||
            loc == AppRoutes.history ||
            loc == AppRoutes.profile) {
          return AppRoutes.agentHome;
        }
      } else if (role == AppRole.user) {
        // et inversement
        if (loc.startsWith("/agent")) {
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
          child: _Placeholder(title: context.l10n.routerScreenForgotPassword),
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

      // Scan d'un déchet (usager)
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

      // Espace usager, 4 onglets
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
                  child: CitizenHomePage(
                    onScan: context.pushScan,
                    onOpenMap: context.goPlaces,
                    onOpenHistory: context.goHistory,
                  ),
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
                  child: const RelayMapPage(),
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
                  child: const CitizenHistoryPage(),
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
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Espace agent, 4 onglets
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
                  child: RelayAgentBuilder(
                    builder: (context, agent) => AgentDashboardPage(
                      agent: agent,
                      onScan: context.pushAgentScan,
                      onOpenPending: context.goAgentDeposits,
                    ),
                  ),
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
                  child: RelayAgentBuilder(
                    builder: (context, agent) =>
                        PendingDepositsPage(agent: agent),
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
                  child: RelayAgentBuilder(
                    builder: (context, agent) => AgentHistoryPage(agent: agent),
                  ),
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
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),

      // Écrans de détail
      GoRoute(
        path: AppRoutes.placeDetail,
        pageBuilder: (context, state) => AppTransitions.fade(
          context: context,
          state: state,
          child: _Placeholder(
            title: context.l10n.routerScreenPlaceDetail(
              state.pathParameters["id"]!,
            ),
          ),
        ),
      ),

      // Paramètres
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
