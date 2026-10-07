import "package:flutter/material.dart";

import "../../domain/entities/map_point.dart";
import "map_point_style.dart";

// Pastille ronde colorée + nom du point en dessous.
class MapPointMarker extends StatelessWidget {
  const MapPointMarker({required this.point, required this.onTap, super.key});
  final MapPoint point;
  final VoidCallback onTap;

  static const width = 110.0;
  static const height = 76.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = point.color(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.surface, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(point.icon, color: scheme.onPrimary, size: 20),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              point.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ),
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
          border: Border.all(color: Colors.white, width: 2.5),
        ),
      ),
    );
  }
}
