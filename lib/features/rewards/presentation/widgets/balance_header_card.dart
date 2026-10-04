import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../domain/entities/points_conversion.dart";
import "points_converter_sheet.dart";

/// Carte d'en-tête mettant en valeur le solde de points et l'équivalent monétaire.
class BalanceHeaderCard extends StatelessWidget {
  const BalanceHeaderCard({required this.points, super.key});

  final int points;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final equivalentFcfa = PointsConversion.toFcfa(points);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Motif visuel subtil en arrière-plan
          Positioned(
            right: -15,
            top: -15,
            child: Icon(
              LucideIcons.coins,
              size: 110,
              color: colorScheme.secondary.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xs + 2),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.sparkles,
                            size: 16,
                            color: colorScheme.secondary,
                          ),
                        ),
                        AppSpacing.gapHSm,
                        Text(
                          "Solde disponible",
                          style: textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => PointsConverterSheet.show(
                        context,
                        initialPoints: points,
                      ),
                      borderRadius: AppSpacing.roundedFull,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm + 2,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: AppSpacing.roundedFull,
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.arrowRightLeft,
                              size: 14,
                              color: colorScheme.primary,
                            ),
                            AppSpacing.gapHSm,
                            Text(
                              "Simuler",
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVSm,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      PointsConversion.formatPoints(points),
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVXs,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.15),
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.wallet,
                        size: 14,
                        color: colorScheme.onSurface,
                      ),
                      AppSpacing.gapHSm,
                      Text(
                        "Valeur estimée : ${PointsConversion.formatFcfa(equivalentFcfa)}",
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
