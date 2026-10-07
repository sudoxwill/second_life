import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

// Nombre qui défile de l'ancienne à la nouvelle valeur (soldes, compteurs).
class AnimatedCount extends StatelessWidget {
  const AnimatedCount({
    required this.value,
    required this.builder,
    super.key,
    this.duration = AppSpacing.durationXXSlow,
  });
  final num value;
  final Widget Function(BuildContext context, int value) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value.toDouble()),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => builder(context, v.round()),
    );
  }
}

// Apparition en fondu et léger glissement vers le haut. [index] décale
// l'animation pour enchaîner les éléments d'une liste.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    required this.child,
    super.key,
    this.index = 0,
    this.offset = 16,
  });
  final Widget child;
  final int index;
  final double offset;

  // Au-delà, les éléments arrivent ensemble : pas d'attente en bas de liste.
  static const _maxStaggered = 6;

  @override
  Widget build(BuildContext context) {
    final delay = index.clamp(0, _maxStaggered) * 60;
    final total = AppSpacing.durationBase.inMilliseconds + delay;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: total),
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
      child: child,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * offset),
          child: child,
        ),
      ),
    );
  }
}

// Réduit légèrement son enfant pendant l'appui : retour tactile visuel sur
// les cartes et boutons maison.
class PressScale extends StatefulWidget {
  const PressScale({required this.child, super.key, this.enabled = true});
  final Widget child;
  final bool enabled;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  var _pressed = false;

  void _set(bool pressed) {
    if (widget.enabled && pressed != _pressed) {
      setState(() => _pressed = pressed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
