import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

class AppSwitcherTransitions {
  const AppSwitcherTransitions._();

  /// Fondu avec une petite montée.
  static Widget fadeSlide(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.1),
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(opacity: animation, child: child),
    );
  }

  /// Fondu et zoom de 0.85 à 1.
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
