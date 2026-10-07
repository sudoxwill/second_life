import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../core/extensions/build_context_extension.dart";
import "../../../core/extensions/navigation_extension.dart";
import "shell_scaffold.dart";

// Coque de l'usager : Accueil, Carte, scan, Historique, Profil.
class UserShell extends StatelessWidget {
  const UserShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ShellScaffold(
      navigationShell: navigationShell,
      centerIcon: LucideIcons.scanBox,
      centerTooltip: l10n.navAnalyzeCta,
      onCenterPressed: context.pushScan,
      items: [
        (icon: LucideIcons.house, label: l10n.navHome),
        (icon: LucideIcons.map, label: l10n.navPlaces),
        (icon: LucideIcons.rotateCcwClock, label: l10n.navHistory),
        (icon: LucideIcons.userRound, label: l10n.navProfile),
      ],
    );
  }
}
