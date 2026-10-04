import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../domain/entities/points_conversion.dart";
import "../../domain/entities/reward_card.dart";
import "../../domain/entities/reward_tier.dart";
import "../providers/rewards_provider.dart";
import "../widgets/redeem_bottom_sheet.dart";

/// Écran affichant le détail complet d'une carte cadeau et permettant d'initier un échange.
class RewardDetailPage extends ConsumerStatefulWidget {
  const RewardDetailPage({required this.card, super.key});

  final RewardCard card;

  @override
  ConsumerState<RewardDetailPage> createState() => _RewardDetailPageState();
}

class _RewardDetailPageState extends ConsumerState<RewardDetailPage> {
  late RewardTier _selectedTier;

  @override
  void initState() {
    super.initState();
    _selectedTier = widget.card.lowestTier;
  }

  void _openRedeemSheet() {
    RedeemBottomSheet.show(
      context,
      card: widget.card,
      initialTier: _selectedTier,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final rewardsState = ref.watch(rewardsNotifierProvider);
    final userPoints = rewardsState.userPoints;
    final hasEnough = userPoints >= _selectedTier.pointsCost;

    return AppScaffold(
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bouton retour personnalisé
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(LucideIcons.arrowLeft),
                tooltip: "Retour",
              ),
              AppSpacing.gapHSm,
              Text(
                "Détail de la récompense",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppSpacing.gapVMd,

          // En-tête de la carte
          Container(
            width: double.infinity,
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: AppSpacing.roundedXl,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: AppSpacing.roundedSm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.card.category.icon,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          AppSpacing.gapHSm,
                          Text(
                            widget.card.category.label,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.card.badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.2),
                          borderRadius: AppSpacing.roundedFull,
                        ),
                        child: Text(
                          widget.card.badgeText!,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                AppSpacing.gapVMd,
                Text(
                  widget.card.title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapVXs,
                Text(
                  "Proposé par ${widget.card.brand}",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapVLg,
                Text(
                  widget.card.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapVXl,

          // Sélection du palier de montant
          Text(
            "Paliers disponibles",
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.gapVSm,
          ...widget.card.tiers.map((tier) {
            final isSelected = tier.id == _selectedTier.id;
            final canAfford = userPoints >= tier.pointsCost;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTier = tier;
                  });
                },
                borderRadius: AppSpacing.roundedMd,
                child: Container(
                  padding: AppSpacing.cardPaddingCompact,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.08)
                        : colorScheme.surfaceContainer,
                    borderRadius: AppSpacing.roundedMd,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? LucideIcons.checkCircle2
                            : LucideIcons.circle,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outline,
                        size: 20,
                      ),
                      AppSpacing.gapHMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tier.name,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Valeur : ${PointsConversion.formatFcfa(tier.monetaryValue)}",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.coins,
                                size: 14,
                                color: colorScheme.secondary,
                              ),
                              AppSpacing.gapHSm,
                              Text(
                                "${tier.pointsCost} pts",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: canAfford
                                      ? colorScheme.onSurface
                                      : colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                          if (!canAfford)
                            Text(
                              "Insuffisant",
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          AppSpacing.gapVLg,

          // Conditions d'utilisation
          if (widget.card.termsAndConditions.isNotEmpty) ...[
            Text(
              "Conditions d'utilisation",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapVSm,
            Container(
              padding: AppSpacing.cardPaddingCompact,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: AppSpacing.roundedMd,
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: widget.card.termsAndConditions.map((term) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          LucideIcons.check,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        AppSpacing.gapHSm,
                        Expanded(
                          child: Text(
                            term,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            AppSpacing.gapVXl,
          ],

          // Bouton d'action principal
          AppElevatedButton(
            text: hasEnough
                ? "Échanger pour ${_selectedTier.pointsCost} pts"
                : "Solde insuffisant ($userPoints/${_selectedTier.pointsCost} pts)",
            onPressed: hasEnough ? _openRedeemSheet : null,
          ),
          AppSpacing.gapVLg,
        ],
      ),
    );
  }
}
