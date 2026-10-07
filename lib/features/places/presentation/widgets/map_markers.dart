import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../domain/entities/map_point.dart";
import "map_point_style.dart";

// Pin en goutte d'eau façon Google Maps ; le nom n'apparaît qu'en zoomant.
class MapPointMarker extends StatelessWidget {
  const MapPointMarker({
    required this.point,
    required this.onTap,
    required this.showLabel,
    super.key,
  });
  final MapPoint point;
  final VoidCallback onTap;
  final bool showLabel;

  static const width = 110.0;
  static const _pinWidth = 40.0;
  static const _pinHeight = 48.0;
  static const _labelHeight = 20.0;
  static const height = _pinHeight + _labelHeight;
  // Place la pointe du pin (et non le centre du widget) sur la coordonnée.
  static const alignment = Alignment(0, 2 * _pinHeight / height - 1);

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: _pinWidth,
            height: _pinHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PinPainter(
                      color: point.color(context),
                      border: scheme.surface,
                      shadow: context.isDarkMode ? 0.6 : 0.3,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _pinWidth,
                  child: Icon(
                    point.icon,
                    color: scheme.onPrimary,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: _labelHeight,
            child: AnimatedOpacity(
              opacity: showLabel ? 1 : 0,
              duration: AppSpacing.durationFast,
              child: _HaloText(
                point.name,
                color: scheme.onSurface,
                halo: scheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  const _PinPainter({
    required this.color,
    required this.border,
    required this.shadow,
  });
  final Color color;
  final Color border;
  final double shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final head = Offset(radius, radius);
    final path = Path.combine(
      PathOperation.union,
      Path()..addOval(Rect.fromCircle(center: head, radius: radius - 1)),
      Path()
        ..moveTo(radius - radius * 0.55, radius * 1.55)
        ..lineTo(radius + radius * 0.55, radius * 1.55)
        ..lineTo(radius, size.height - 1)
        ..close(),
    );

    canvas
      ..drawShadow(path, Colors.black.withValues(alpha: shadow), 3, false)
      ..drawPath(path, Paint()..color = color)
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppSpacing.borderWidthThick
          ..strokeJoin = StrokeJoin.round
          ..color = border,
      );
  }

  @override
  bool shouldRepaint(_PinPainter old) =>
      old.color != color || old.border != border || old.shadow != shadow;
}

// Texte cerclé d'un halo pour rester lisible sur la carte.
class _HaloText extends StatelessWidget {
  const _HaloText(this.text, {required this.color, required this.halo});
  final String text;
  final Color color;
  final Color halo;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: context.textTheme.labelSmall!.copyWith(
        fontWeight: FontWeight.w700,
        color: color,
        shadows: [
          for (final (dx, dy) in const [
            (-1.0, 0.0),
            (1.0, 0.0),
            (0.0, -1.0),
            (0.0, 1.0),
          ])
            Shadow(color: halo, offset: Offset(dx, dy), blurRadius: 1.5),
        ],
      ),
    );
  }
}

// Point bleu de la position de l'usager.
class UserLocationMarker extends StatelessWidget {
  const UserLocationMarker({super.key});

  static const size = 44.0;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2F6FE4);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: blue.withValues(alpha: 0.18),
      ),
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: blue,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: AppSpacing.borderWidthThick + 0.5,
          ),
          boxShadow: AppSpacing.elevationShadowSm,
        ),
      ),
    );
  }
}
