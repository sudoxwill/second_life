import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";
import "app_switcher_transitions.dart";

class AppIconSwitcher extends StatelessWidget {
  const AppIconSwitcher({
    required this.child,
    super.key,
    this.duration,
    this.transitionBuilder = AppSwitcherTransitions.fadeSlide,
  });

  /// Deux enfants du même type (deux [Icon] par exemple) doivent avoir
  /// des clés différentes, sinon il n'y a pas d'animation.
  final Widget child;

  final Duration? duration;

  final Widget Function(Widget, Animation<double>) transitionBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: AppSpacing.curveExit,
      switchOutCurve: AppSpacing.curveEnter,
      duration: duration ?? AppSpacing.durationFast,
      transitionBuilder: transitionBuilder,
      child: child,
    );
  }
}
