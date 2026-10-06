import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";

class PillTab {
  const PillTab(this.label, {this.icon, this.badge});
  final String label;
  final IconData? icon;
  // Pastille à côté du libellé (ex. nombre en attente).
  final int? badge;
}

// Onglets en pilule : l'onglet actif est rempli en vert.
class PillTabs extends StatelessWidget {
  const PillTabs({
    required this.tabs,
    required this.selected,
    required this.onChanged,
    super.key,
  });
  final List<PillTab> tabs;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(child: _tab(context, tabs[i], i == selected, i)),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, PillTab tab, bool active, int index) {
    final scheme = Theme.of(context).colorScheme;
    final color = active ? scheme.onPrimary : scheme.onSurfaceVariant;
    return GestureDetector(
      onTap: () => onChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: active ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (tab.icon != null) ...[
              Icon(tab.icon, size: 16, color: color),
              const SizedBox(width: 6),
            ],
            // Réduit plutôt que tronqué quand la place manque.
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tab.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            if (tab.badge != null && tab.badge! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: context.warning,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  "${tab.badge}",
                  style: TextStyle(
                    color: context.onWarning,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
