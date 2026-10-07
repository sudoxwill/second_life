import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../history/presentation/providers/history_providers.dart";
import "../../../history/presentation/widget/material_type_icon.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";

class UserHome extends ConsumerWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final stats = ref.watch(citizenStatsProvider).value;
    final pendingDeposits = ref.watch(pendingDepositsProvider).value ?? [];

    final balancePoints = stats?.pointsBalance.round() ?? 0;
    final pendingPoints = stats?.pendingPoints.round() ?? 0;

    return Column(
      spacing: AppSpacing.lg,
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedLg,
          ),
          color: AppColors.grassCourt,
          margin: .zero,
          child: Container(
            padding: AppSpacing.insetMd,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      l10n.homePointsTitle,
                      style: textTheme.titleMedium!.copyWith(
                        color: AppColors.neutral50,
                      ),
                    ),
                    InkWell(
                      borderRadius: AppSpacing.roundedXxl,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.roundedXxl,
                          color: AppColors.neutral50.withValues(alpha: .2),
                        ),
                        child: Row(
                          spacing: AppSpacing.xs,
                          children: [
                            const Icon(
                              LucideIcons.gift,
                              size: AppSpacing.iconSm,
                            ),
                            Text(
                              l10n.homePointsRedeemCta,
                              style: textTheme.bodySmall!.copyWith(
                                color: AppColors.neutral50,
                              ),
                            ),
                            const Icon(
                              LucideIcons.arrowUpRight,
                              size: AppSpacing.iconMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVSm,
                Text(
                  l10n.homePointsBalance(balancePoints),
                  style: textTheme.headlineMedium!.copyWith(
                    fontWeight: .bold,
                    color: AppColors.neutral50,
                  ),
                ),
                AppSpacing.gapVSm,
                Chip(
                  side: BorderSide.none,
                  backgroundColor: colorScheme.secondary.withValues(alpha: .2),
                  avatar: Icon(
                    LucideIcons.rotateCcwClock,
                    color: colorScheme.secondary,
                    size: AppSpacing.iconSm,
                  ),
                  label: Text(
                    l10n.homePointsPendingValidation(pendingPoints),
                    style: TextStyle(color: colorScheme.secondary),
                    overflow: .ellipsis,
                  ),
                ),
                AppSpacing.gapVXs,
                Text(
                  l10n.homePointsNotCash,
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.neutral50.withValues(alpha: .7),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Text(l10n.homePendingDepositsTitle),
                    Badge(
                      label: Text(
                        "${pendingDeposits.length}",
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                      backgroundColor: colorScheme.secondary,
                    ),
                  ],
                ),
                TextButton(onPressed: () {}, child: Text(l10n.commonSeeMore)),
              ],
            ),
            if (pendingDeposits.isEmpty)
              SizedBox(
                height: AppSpacing.yotta * 2,
                child: Center(child: Text(l10n.homePendingDepositsEmpty)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingDeposits.length,
                itemBuilder: (context, index) {
                  final ticket = pendingDeposits[index];
                  final itemLabel =
                      ticket.wasteAnalysisResult.detectedItem.itemLabel;
                  final points = ticket
                      .wasteAnalysisResult
                      .itemRecyclability
                      .pointsEarned
                      .round();
                  return ListTile(
                    contentPadding: AppSpacing.insetVXs,
                    leading: MaterialTypeIcon(
                      material: MaterialTypeFromCategory.fromCategory(
                        ticket.wasteAnalysisResult.detectedItem
                            .itemMainCategory,
                      ),
                      size: AppSpacing.mega,
                    ),
                    title: Text(itemLabel, style: textTheme.bodyLarge),
                    trailing: Text(
                      l10n.homeDepositPointsGain(points),
                      style: textTheme.labelLarge!.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),

        // Info
        Container(
          padding: AppSpacing.insetXs,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: .5),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: AppSpacing.mega,
              height: AppSpacing.mega,
              padding: AppSpacing.insetSm,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.roundedLg,
                color: colorScheme.onSurface,
              ),
              child: Icon(LucideIcons.badgeInfo, color: colorScheme.surface),
            ),
            title: Text(l10n.homeEcoImpactTitle, style: textTheme.labelMedium),
            subtitle: Text(
              l10n.homeEcoImpactSubtitle,
              style: textTheme.labelSmall,
            ),
          ),
        ),
      ],
    );
  }
}
