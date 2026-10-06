import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../../../core/theme/index.dart";

// Marge basse des pages de la coque : la barre du bas passe par-dessus.
const kShellBottomPadding = 120.0;

class ShellDestination {
  const ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.page,
  });
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  // Page affichée par la coque quand aucun [AppShell.body] n'est fourni.
  final Widget? page;
}

// Coque commune aux deux espaces : 4 onglets (2 de chaque côté) et un
// bouton rond central (scan).
class AppShell extends StatelessWidget {
  const AppShell({
    required this.destinations,
    required this.index,
    required this.onIndexChanged,
    required this.centerIcon,
    required this.centerTooltip,
    required this.onCenterPressed,
    super.key,
    this.body,
  }) : assert(destinations.length == 4);
  final List<ShellDestination> destinations;
  final int index;
  final ValueChanged<int> onIndexChanged;
  final IconData centerIcon;
  final String centerTooltip;
  final VoidCallback onCenterPressed;
  // Contenu fourni par l'appelant (ex. StatefulNavigationShell de go_router).
  // Sinon, les pages des destinations dans un IndexedStack.
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Barre d'état transparente, icônes adaptées au thème.
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: _scaffold(context, scheme),
    );
  }

  Widget _scaffold(BuildContext context, ColorScheme scheme) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child:
            body ??
            IndexedStack(
              index: index,
              children: [for (final d in destinations) d.page!],
            ),
      ),
      extendBody: true,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border(top: BorderSide(color: scheme.outlineVariant)),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 68,
                child: Row(
                  children: [
                    _item(context, 0),
                    _item(context, 1),
                    const SizedBox(width: 84),
                    _item(context, 2),
                    _item(context, 3),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            child: _CenterButton(
              icon: centerIcon,
              tooltip: centerTooltip,
              onPressed: onCenterPressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, int i) {
    final destination = destinations[i];
    final selected = i == index;
    final color = selected
        ? context.primaryText
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: () => onIndexChanged(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? destination.selectedIcon : destination.icon,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              destination.label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: scheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: scheme.primary,
          shape: const CircleBorder(),
          elevation: 4,
          shadowColor: scheme.primary.withValues(alpha: 0.5),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Icon(icon, color: scheme.onPrimary, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
