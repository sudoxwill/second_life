import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../domain/entities/points_conversion.dart";
import "../../domain/entities/reward_card.dart";

/// Vignette présentant une carte cadeau dans le catalogue.
class RewardCardTile extends StatelessWidget {
  const RewardCardTile({required this.card, required this.onTap, super.key});

  final RewardCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final minTier = card.lowestTier;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedXl,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.roundedXl,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ligne supérieure : Catégorie / Marque & Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs + 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Icon(
                          card.category.icon,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                      ),
                      AppSpacing.gapHSm,
                      Text(
                        card.brand,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (card.badgeText != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs - 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.2),
                        borderRadius: AppSpacing.roundedFull,
                      ),
                      child: Text(
                        card.badgeText!,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              AppSpacing.gapVMd,

              // Titre et courte description
              Text(
                card.title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapVXs,
              Text(
                card.shortDescription,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapVLg,

              // Ligne inférieure : Paliers et action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "À partir de",
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.coins,
                            size: 14,
                            color: colorScheme.secondary,
                          ),
                          AppSpacing.gapHSm,
                          Text(
                            PointsConversion.formatPoints(minTier.pointsCost),
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          AppSpacing.gapHSm,
                          Text(
                            "(${PointsConversion.formatFcfa(minTier.monetaryValue)})",
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
