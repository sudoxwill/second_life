import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";
import "app_switcher_transitions.dart";

/// A specialized [AnimatedSwitcher] for icons or small widgets.
/// 
/// It uses [AppSwitcherTransitions.fadeSlide] by default to provide 
/// a consistent feel when switching between icon states.
class AppIconSwitcher extends StatelessWidget {
  const AppIconSwitcher({
    required this.child,
    super.key,
    this.duration,
    this.transitionBuilder = AppSwitcherTransitions.fadeSlide,
  });

  /// The widget to display. 
  /// 
  /// **Note**: If the [child] type is the same (e.g., both are [Icon]), 
  /// you MUST provide a unique [Key] to the [child] to trigger the animation.
  final Widget child;

  /// Defaults to [AppSpacing.durationBase].
  final Duration? duration;

  /// The builder that defines the transition.
  /// Defaults to [AppSwitcherTransitions.fadeSlide].
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
