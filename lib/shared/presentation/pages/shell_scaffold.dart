import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";

import "../../../core/theme/index.dart";

typedef ShellNavItem = ({IconData icon, String label});

// Coque commune aux espaces usager et agent : 4 onglets (2 de chaque côté)
// autour d'un bouton rond central (scan) logé dans une encoche.
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({
    required this.navigationShell,
    required this.items,
    required this.centerIcon,
    required this.centerTooltip,
    required this.onCenterPressed,
    super.key,
  }) : assert(items.length == 4);

  final StatefulNavigationShell navigationShell;
  final List<ShellNavItem> items;
  final IconData centerIcon;
  final String centerTooltip;
  final VoidCallback onCenterPressed;

  static const _barHeight = 64.0;

  void _goBranch(int index) {
    if (index != navigationShell.currentIndex) {
      HapticFeedback.selectionClick();
    }
    // Un second appui sur l'onglet actif revient à sa page racine.
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = navigationShell.currentIndex;

    Widget item(int i) => _NavItem(
      icon: items[i].icon,
      label: items[i].label,
      selected: current == i,
      onTap: () => _goBranch(i),
    );

    return Scaffold(
      body: navigationShell,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        // Vert et jaune de la marque dans les deux thèmes.
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.supernova,
        elevation: AppSpacing.elevationMd,
        tooltip: centerTooltip,
        onPressed: () {
          HapticFeedback.mediumImpact();
          onCenterPressed();
        },
        child: Icon(centerIcon, size: AppSpacing.iconMxl),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: _barHeight,
        padding: EdgeInsets.zero,
        elevation: AppSpacing.elevationLg,
        shadowColor: scheme.shadow.withValues(alpha: 0.25),
        child: Row(
          children: [
            item(0),
            item(1),
            // Place laissée au bouton central.
            const SizedBox(width: 72),
            item(2),
            item(3),
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? context.primaryText : scheme.onSurfaceVariant;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        excludeSemantics: true,
        child: InkResponse(
          onTap: onTap,
          radius: 36,
          // Zone de tap ≥ 48×48 (accessibilité CDC).
          child: SizedBox(
            height: ShellScaffold._barHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: AppSpacing.durationFast,
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: selected ? AppSpacing.lg : AppSpacing.sm,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? context.primarySoft : Colors.transparent,
                    borderRadius: AppSpacing.roundedFull,
                  ),
                  child: AnimatedScale(
                    scale: selected ? 1.08 : 1,
                    duration: AppSpacing.durationFast,
                    child: Icon(icon, color: color, size: 22),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: AppSpacing.durationFast,
                  style: TextStyle(
                    fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
