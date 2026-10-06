import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

/// Common transitions used by [AnimatedSwitcher] across the app.
class AppSwitcherTransitions {
  const AppSwitcherTransitions._();

  /// Fade combined with a subtle upward slide.
  static Widget fadeSlide(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Fade combined with a scale from 0.85 → 1.0.
  static Widget fadeScale(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: AppSpacing.curveEnter),
        ),
        child: child,
      ),
    );
  }
}
