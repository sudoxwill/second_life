import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../domain/entities/map_point.dart";
import "map_point_style.dart";

// Ligne de la liste "Points proches".
class MapPointCard extends StatelessWidget {
  const MapPointCard({
    required this.point,
    required this.onTap,
    required this.onDetails,
    super.key,
    this.distance,
  });
  final MapPoint point;
  // Distance en mètres, null si la position de l'usager est inconnue.
  final double? distance;
  final VoidCallback onTap;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final infos = [
      if (distance != null) formatDistance(distance!),
      if (point.hasHours) point.hoursLabel else point.typeLabel,
    ].join(" · ");

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconTile(
            icon: point.icon,
            color: scheme.onPrimary,
            background: point.color(context),
            size: 48,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        point.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (point.hasHours) ...[
                      const SizedBox(width: 8),
                      OpenStatusPill(open: point.isOpenAt(now)),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  infos,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (point.hasAgentOn(now)) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.circleCheck,
                        size: 13,
                        color: context.primaryText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Agent présent aujourd’hui",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.primaryText,
                        ),
                      ),
                    ],
                  ),
                ] else if (!point.isRelay && point.hasHours) ...[
                  const SizedBox(height: 4),
                  Text(
                    point.typeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: point.color(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onDetails,
            style: TextButton.styleFrom(
              foregroundColor: point.color(context),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text(
              "Détails →",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class OpenStatusPill extends StatelessWidget {
  const OpenStatusPill({required this.open, super.key});
  final bool open;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Pill(
      label: open ? "Ouvert" : "Fermé",
      color: open ? context.primaryText : scheme.onSurfaceVariant,
      background: open ? context.primarySoft : scheme.surfaceContainerHighest,
    );
  }
}
