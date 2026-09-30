import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";
import "app_switcher_transitions.dart";

enum SwitcherTransitionType {
  /// Fade + subtle upward slide — default behavior.
  fadeSlide,

  /// Pure opacity fade, no positional movement.
  /// Best when the loading widget has the same size as the content.
  fade,

  /// Fade combined with a scale from 0.85 → 1.0.
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

  /// Widget shown while loading.
  /// Defaults to a 24×24 [CircularProgressIndicator].
  /// Pass a skeleton widget to replace the spinner with a shimmer placeholder.
  final Widget? loadingWidget;

  /// Defaults to [AppSpacing.durationBase] (250 ms).
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
