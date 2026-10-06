import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";
import "app_switcher_transitions.dart";

enum SwitcherTransitionType {
  /// Fondu avec une petite montée (par défaut).
  fadeSlide,

  /// Fondu seul.
  /// Le mieux quand le loader a la même taille que le contenu.
  fade,

  /// Fondu et zoom de 0.85 à 1.
  fadeScale,
}

class AppAnimatedSwitcher extends StatelessWidget {
  const AppAnimatedSwitcher({
    required this.isLoading,
    required this.child,
    super.key,
    this.loadingWidget,
    this.duration,
    this.transitionType = SwitcherTransitionType.fade,
  });

  final bool isLoading;
  final Widget child;

  /// Un spinner par défaut, ou un skeleton.
  final Widget? loadingWidget;

  final Duration? duration;

  final SwitcherTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    final effectiveLoader = loadingWidget ??
        const SizedBox(
          width: AppSpacing.xxl,
          height: AppSpacing.xxl,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        );

    return AnimatedSwitcher(
      duration: duration ?? AppSpacing.durationBase,
      transitionBuilder: _buildTransition,
      child: isLoading
          ? KeyedSubtree(key: const ValueKey("loading"), child: effectiveLoader)
          : KeyedSubtree(key: const ValueKey("content"), child: child),
    );
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    return switch (transitionType) {
      SwitcherTransitionType.fadeSlide =>
        AppSwitcherTransitions.fadeSlide(child, animation),
      SwitcherTransitionType.fade =>
        FadeTransition(opacity: animation, child: child),
      SwitcherTransitionType.fadeScale =>
        AppSwitcherTransitions.fadeScale(child, animation),
    };
  }
}
