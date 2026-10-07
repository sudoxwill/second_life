import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../core/extensions/build_context_extension.dart";
import "../../../core/extensions/navigation_extension.dart";
import "shell_scaffold.dart";

// Coque de l'agent : Accueil, Dépôts, scan du QR, Historique, Profil.
class AgentShell extends StatelessWidget {
  const AgentShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ShellScaffold(
      navigationShell: navigationShell,
      centerIcon: LucideIcons.scanQrCode,
      centerTooltip: l10n.agentQuickScanTitle,
      onCenterPressed: context.pushAgentScan,
      items: [
        (icon: LucideIcons.layoutDashboard, label: l10n.navHome),
        (icon: LucideIcons.inbox, label: l10n.navAgentDeposits),
        (icon: LucideIcons.rotateCcwClock, label: l10n.navHistory),
        (icon: LucideIcons.userRound, label: l10n.navProfile),
      ],
    );
  }
}
