import "package:flutter/material.dart" hide MaterialType;
import "package:intl/intl.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../history/presentation/widget/material_type_icon.dart";
import "../../domain/entities/map_point.dart";
import "map_point_style.dart";

// Ligne de la liste "Points proches" : ce qu'il faut pour choisir où aller
// (type, distance, ouvert ou non, ce qu'on y dépose) et deux actions.
class MapPointCard extends StatelessWidget {
  const MapPointCard({
    required this.point,
    required this.onTap,
    required this.onDetails,
    required this.onRoute,
    super.key,
    this.distance,
  });
  final MapPoint point;
  // Distance en mètres, null si la position de l'usager est inconnue.
  final double? distance;
  final VoidCallback onTap;
  final VoidCallback onDetails;
  final VoidCallback onRoute;

  static const _maxMaterials = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.colorScheme;
    final textTheme = context.textTheme;
    final now = DateTime.now();
    final color = point.color(context);
    final subtitle = [
      point.typeLabel,
      ?point.district,
    ].join(" · ");
    // L'agent tient la permanence pendant les heures d'ouverture du relais.
    final agentHere = point.isRelay && point.isOpenAt(now);
    final materials = point.acceptedMaterials;

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.insetLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: point.icon,
                color: color,
                background: point.softColor(context),
                size: AppSpacing.mega,
              ),
              AppSpacing.gapHMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      point.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapVXs,
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelMedium!.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (point.hasHours) ...[
                      AppSpacing.gapVXs,
                      _OpeningStatus(point: point, now: now),
                    ],
                  ],
                ),
              ),
              if (distance != null) ...[
                AppSpacing.gapHSm,
                Text(
                  formatDistance(distance!),
                  style: textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ],
          ),
          if (point.isRelay && (materials.isNotEmpty || agentHere)) ...[
            AppSpacing.gapVMd,
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final m in materials.take(_maxMaterials))
                  Semantics(
                    label: m.type.label(l10n),
                    child: MaterialTypeIcon(
                      material: m.type,
                      size: AppSpacing.avatarSm,
                    ),
                  ),
                if (materials.length > _maxMaterials)
                  Text(
                    "+${materials.length - _maxMaterials}",
                    style: textTheme.labelMedium!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                if (agentHere) ...[
                  AppSpacing.gapHXs,
                  Pill(
                    label: l10n.placesAgentPresent,
                    color: context.primaryText,
                    background: context.primarySoft,
                  ),
                ],
              ],
            ),
          ],
          AppSpacing.gapVMd,
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onRoute,
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: scheme.onPrimary,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(
                    LucideIcons.navigation2,
                    size: AppSpacing.iconSm,
                  ),
                  label: Text(l10n.placesRoute),
                ),
              ),
              AppSpacing.gapHSm,
              Expanded(
                child: OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(l10n.placesDetails),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// "Ouvert · Ferme à 18h" ou "Fermé · Ouvre lun. à 08h".
class _OpeningStatus extends StatelessWidget {
  const _OpeningStatus({required this.point, required this.now});
  final MapPoint point;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final open = point.isOpenAt(now);
    final next = point.nextChange(now);
    String? detail;
    if (next != null) {
      final time = formatClock(next);
      if (open) {
        detail = l10n.placesClosesAt(time);
      } else if (next.day == now.day && next.month == now.month) {
        detail = l10n.placesOpensAt(time);
      } else {
        final day = DateFormat.E(
          Localizations.localeOf(context).toString(),
        ).format(next);
        detail = l10n.placesOpensDayAt(day, time);
      }
    }

    final style = context.textTheme.labelMedium!;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: open ? l10n.placesOpen : l10n.placesClosed,
            style: style.copyWith(
              fontWeight: FontWeight.w700,
              color: open ? context.primaryText : context.danger,
            ),
          ),
          if (detail != null)
            TextSpan(
              text: " · $detail",
              style: style.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
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
