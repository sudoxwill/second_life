import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
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
    final scheme = context.colorScheme;
    final now = DateTime.now();
    final infos = [
      if (distance != null) formatDistance(distance!),
      if (point.hasHours) point.hoursLabel else point.typeLabel,
    ].join(" · ");

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.insetLg,
      child: Row(
        children: [
          IconTile(
            icon: point.icon,
            color: scheme.onPrimary,
            background: point.color(context),
            size: AppSpacing.mega,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        point.name,
                        style: context.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (point.hasHours) ...[
                      AppSpacing.gapHSm,
                      OpenStatusPill(open: point.isOpenAt(now)),
                    ],
                  ],
                ),
                AppSpacing.gapVXs,
                Text(
                  infos,
                  style: context.textTheme.labelMedium!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (point.hasAgentOn(now)) ...[
                  AppSpacing.gapVXs,
                  Row(
                    children: [
                      Icon(
                        LucideIcons.circleCheck,
                        size: AppSpacing.iconXs,
                        color: context.primaryText,
                      ),
                      AppSpacing.gapHXs,
                      Text(
                        context.l10n.placesAgentPresent,
                        style: context.textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.primaryText,
                        ),
                      ),
                    ],
                  ),
                ] else if (!point.isRelay && point.hasHours) ...[
                  AppSpacing.gapVXs,
                  Text(
                    point.typeLabel,
                    style: context.textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: point.color(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
          AppSpacing.gapHSm,
          TextButton(
            onPressed: onDetails,
            style: TextButton.styleFrom(
              foregroundColor: point.color(context),
              padding: AppSpacing.insetHSm,
            ),
            child: Text(
              context.l10n.placesDetails,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
    final scheme = context.colorScheme;
    return Pill(
      label: open ? context.l10n.placesOpen : context.l10n.placesClosed,
      color: open ? context.primaryText : scheme.onSurfaceVariant,
      background: open ? context.primarySoft : scheme.surfaceContainerHighest,
    );
  }
}
