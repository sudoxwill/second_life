import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";

// Cadre de visée aux coins verts des écrans de scan, avec la ligne de
// scan animée. [dimOutside] assombrit l'écran autour du cadre (aperçu
// caméra derrière).
class ScanFrame extends StatelessWidget {
  const ScanFrame({
    super.key,
    this.size = 240,
    this.child,
    this.scanning = true,
    this.dimOutside = false,
  });
  static const _radius = 28.0;

  final double size;
  final Widget? child;
  final bool scanning;
  final bool dimOutside;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: dimOutside ? _DimOutsidePainter(_radius) : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(
            color: AppColors.scanFrame.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: CustomPaint(
          foregroundPainter: _CornersPainter(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (child != null) Center(child: child),
                if (scanning) const ScanLineOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Ligne lumineuse qui balaie la zone de haut en bas, suivie d'une traînée.
// Se pose par-dessus n'importe quel contenu (cadre, photo en analyse…).
class ScanLineOverlay extends StatefulWidget {
  const ScanLineOverlay({
    super.key,
    this.period = const Duration(milliseconds: 2200),
  });
  final Duration period;

  @override
  State<ScanLineOverlay> createState() => _ScanLineOverlayState();
}

class _ScanLineOverlayState extends State<ScanLineOverlay>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _ScanLinePainter(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
        ),
      ),
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  _ScanLinePainter(this.progress) : super(repaint: progress);
  static const _trail = 70.0;

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    const margin = 10.0;
    final y = margin + progress.value * (size.height - 2 * margin);
    final goingDown = progress.status != AnimationStatus.reverse;
    const color = AppColors.scanFrame;

    // Traînée du côté d'où vient la ligne.
    final trailRect = goingDown
        ? Rect.fromLTRB(0, y - _trail, size.width, y)
        : Rect.fromLTRB(0, y, size.width, y + _trail);
    canvas.drawRect(
      trailRect,
      Paint()
        ..shader = LinearGradient(
          begin: goingDown ? Alignment.topCenter : Alignment.bottomCenter,
          end: goingDown ? Alignment.bottomCenter : Alignment.topCenter,
          colors: [color.withValues(alpha: 0), color.withValues(alpha: 0.28)],
        ).createShader(trailRect),
    );

    // Halo puis ligne nette, plus brillante au centre.
    final lineRect = Rect.fromLTRB(
      margin,
      y - 1.5,
      size.width - margin,
      y + 1.5,
    );
    final lineShader = LinearGradient(
      colors: [
        color.withValues(alpha: 0),
        color,
        Colors.white,
        color,
        color.withValues(alpha: 0),
      ],
      stops: const [0, 0.2, 0.5, 0.8, 1],
    ).createShader(lineRect);
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(lineRect.inflate(3), const Radius.circular(4)),
        Paint()
          ..shader = lineShader
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(lineRect, const Radius.circular(2)),
        Paint()..shader = lineShader,
      );
  }

  @override
  bool shouldRepaint(_ScanLinePainter oldDelegate) => false;
}

// Voile sombre sur tout l'écran sauf le cadre. Peint hors de ses limites :
// pas de calcul de position du cadre dans la page.
class _DimOutsidePainter extends CustomPainter {
  _DimOutsidePainter(this.radius);
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final hole = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(const Rect.fromLTRB(-3000, -3000, 3000, 3000)),
      Path()..addRRect(hole),
    );
    canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.5));
  }

  @override
  bool shouldRepaint(_DimOutsidePainter oldDelegate) => false;
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const inset = 14.0;
    const length = 26.0;
    const radius = 10.0;
    final paint = Paint()
      ..color = AppColors.scanFrame
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Un coin arrondi, dessiné puis tourné pour les 4 angles.
    final corner = Path()
      ..moveTo(inset, inset + length)
      ..lineTo(inset, inset + radius)
      ..arcToPoint(
        const Offset(inset + radius, inset),
        radius: const Radius.circular(radius),
      )
      ..lineTo(inset + length, inset);

    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < 4; i++) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(i * 3.14159265 / 2)
        ..translate(-center.dx, -center.dy)
        ..drawPath(corner, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Bouton rond translucide des écrans sombres (retour, import…).
class ScanRoundButton extends StatelessWidget {
  const ScanRoundButton({
    required this.icon,
    required this.tooltip,
    super.key,
    this.onPressed,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        foregroundColor: Colors.white,
        fixedSize: const Size(44, 44),
      ),
      icon: Icon(icon),
    );
  }
}

// Pastille verte du titre des écrans de scan.
class ScanChip extends StatelessWidget {
  const ScanChip({required this.icon, required this.label, super.key});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.scanFrame.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Bulle d'aide sombre sous le cadre.
class ScanHint extends StatelessWidget {
  const ScanHint(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
