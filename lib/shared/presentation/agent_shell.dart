import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../core/extensions/build_context_extension.dart";
import "../../core/extensions/navigation_extension.dart";
import "widgets/others/app_shell.dart";

/// Coque de l'agent relais : Tableau, Dépôts, scan, Historique, Profil.
class AgentShell extends StatelessWidget {
  const AgentShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppShell(
      body: navigationShell,
      index: navigationShell.currentIndex,
      onIndexChanged: (i) => navigationShell.goBranch(
        i,
        initialLocation: i == navigationShell.currentIndex,
      ),
      centerIcon: LucideIcons.scanBox,
      centerTooltip: l10n.navAnalyzeCta,
      onCenterPressed: context.pushScan,
      destinations: [
        ShellDestination(
          label: l10n.navHome,
          icon: LucideIcons.layoutDashboard,
          selectedIcon: LucideIcons.layoutDashboard,
        ),
        ShellDestination(
          label: l10n.navAgentDeposits,
          icon: LucideIcons.inbox,
          selectedIcon: LucideIcons.inbox,
        ),
        ShellDestination(
          label: l10n.navHistory,
          icon: LucideIcons.rotateCcwClock,
          selectedIcon: LucideIcons.rotateCcwClock,
        ),
        ShellDestination(
          label: l10n.navProfile,
          icon: LucideIcons.userRound,
          selectedIcon: LucideIcons.userRound,
        ),
      ],
    );
  }
}
