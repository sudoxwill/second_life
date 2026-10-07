import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/routing/app_routes.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../l10n/app_localizations.dart";

List<_NavItemData> _getNavItems(AppLocalizations l10n) {
  return <_NavItemData>[
    (
      index: 0,
      icon: LucideIcons.layoutDashboard,
      label: l10n.navHome,
      route: AppRoutes.agentHome,
    ),
    (
      index: 1,
      icon: LucideIcons.inbox,
      label: l10n.navAgentDeposits,
      route: AppRoutes.agentDeposits,
    ),
    (
      index: 2,
      icon: LucideIcons.rotateCcwClock,
      label: l10n.navHistory,
      route: AppRoutes.agentHistory,
    ),
    (
      index: 3,
      icon: LucideIcons.userRound,
      label: l10n.navProfile,
      route: AppRoutes.agentProfile,
    ),
  ];
}

class AgentShell extends StatelessWidget {
  const AgentShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navItems = _getNavItems(l10n);
    final currentIndex = navigationShell.currentIndex;
    final colorScheme = context.colorScheme;
    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.accent,
        elevation: AppSpacing.elevationMd,
        onPressed: () => context.pushAgentScan(),
        tooltip: l10n.navAnalyzeCta,
        child: const Icon(LucideIcons.scanBox, size: AppSpacing.iconMxl),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        // Hauteur M3 par défaut (80) trop grande pour nos onglets de 56 :
        // elle laissait une bande vide en bas de chaque écran.
        height: 56,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            ...List.generate(2, (i) {
              final item = navItems[i];
              final selected = currentIndex == i;
              return _NavItem(
                icon: item.icon,
                label: item.label,
                selected: selected,
                color: selected
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
                onTap: () => navigationShell.goBranch(
                  i,
                  initialLocation: i == navigationShell.currentIndex,
                ),
              );
            }),
            const Expanded(child: SizedBox()),
            ...List.generate(2, (i) {
              final idx = i + 2;
              final item = navItems[idx];
              final selected = currentIndex == idx;
              return _NavItem(
                icon: item.icon,
                label: item.label,
                selected: selected,
                color: selected
                    ? colorScheme.secondary
                    : colorScheme.onSurfaceVariant,
                onTap: () => navigationShell.goBranch(
                  idx,
                  initialLocation: idx == navigationShell.currentIndex,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: AppSpacing.roundedLg,
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _NavItemData = ({int index, IconData icon, String label, String route});
