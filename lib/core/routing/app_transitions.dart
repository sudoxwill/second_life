import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../theme/app_spacing.dart";

/// Transitions d'écran Dogbale.
///
/// Les durées sont alignées sur les tokens
/// - `quick` 200ms — apparition d'élément, changement d'onglet
/// - `standard` 300ms — transition d'écran, bottom sheet
/// - `slow` 450ms — transformation d'élément
///
/// Aucune animation ne dépasse 450ms.
class AppTransitions {
  AppTransitions._();

  // ─────────────────────────────────────────────
  // TRANSITIONS PUBLIQUES
  // ─────────────────────────────────────────────

  /// Fade simple — changement d'onglet, splash.
  static CustomTransitionPage<T> fade<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = AppSpacing.durationFast,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) =>
          FadeTransition(opacity: _curved(animation, curve), child: child),
    );
  }

  /// Slide depuis une direction.
  static CustomTransitionPage<T> slide<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(1.0, 0.0),
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveDefault,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(_curved(animation, curve)),
        child: child,
      ),
    );
  }

  /// Fade + glissement vertical subtil — pages de contenu.
  static CustomTransitionPage<T> fadeSlide<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Offset begin = const Offset(0.0, 0.04),
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) {
        final curved = _curved(animation, curve);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Fade + scale — modals, pages de détail.
  static CustomTransitionPage<T> fadeScale<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    double beginScale = 0.92,
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) {
        final curved = _curved(animation, curve);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: beginScale, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Scale seul — popups, overlays.
  static CustomTransitionPage<T> scale<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    double beginScale = 0.85,
    Duration duration = AppSpacing.durationFast,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveEnter,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, _, child) => ScaleTransition(
        scale: Tween<double>(
          begin: beginScale,
          end: 1.0,
        ).animate(_curved(animation, curve)),
        child: child,
      ),
    );
  }

  /// Transition d'écran poussé (spec §11.3) — glissement depuis la droite en
  /// 300ms, l'écran sortant recule de 8% en échelle et perd 30% d'opacité.
  ///
  /// À utiliser pour les navigations `push` vers un écran détail, éditeur, etc.
  static CustomTransitionPage<T> pushedScreen<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = AppSpacing.durationBase,
    Duration? reverseDuration,
    Curve curve = AppSpacing.curveDefault,
  }) {
    return _page(
      state: state,
      child: child,
      duration: duration,
      reverseDuration: reverseDuration,
      builder: (context, animation, secondaryAnimation, child) {
        final curvedIn = _curved(animation, curve);
        final curvedOut = _curved(secondaryAnimation, curve);

        // Écran entrant : glissement depuis la droite
        final slideIn = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curvedIn);

        // Écran sortant : recule de 8% + perd 30% d'opacité
        final scaleOut = Tween<double>(
          begin: 1.0,
          end: 0.92,
        ).animate(curvedOut);
        final fadeOut = Tween<double>(begin: 1.0, end: 0.7).animate(curvedOut);

        return SlideTransition(
          position: slideIn,
          child: FadeTransition(
            opacity: fadeOut,
            child: ScaleTransition(scale: scaleOut, child: child),
          ),
        );
      },
    );
  }

  /// Aucune transition — affichage instantané.
  static CustomTransitionPage<T> none<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return _page(
      state: state,
      child: child,
      duration: Duration.zero,
      builder: (context, _, _, child) => child,
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────

  static CustomTransitionPage<T> _page<T>({
    required GoRouterState state,
    required Widget child,
    required Widget Function(
      BuildContext,
      Animation<double>,
      Animation<double>,
      Widget,
    )
    builder,
    required Duration duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration ?? duration,
      transitionsBuilder: builder,
    );
  }

  static Animation<double> _curved(Animation<double> animation, Curve curve) =>
      CurvedAnimation(parent: animation, curve: curve);
}
