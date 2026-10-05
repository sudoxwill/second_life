import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  static const int demoBalancePoints = 350;
  static const int demoPendingValidationPoints = 80;
  static const int demoPendingDepositsCount = 2;
  static const int demoBottleDepositPoints = 50;
  static const int demoIronDepositPoints = 80;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      spacing: AppSpacing.lg,
      children: [
        /// Main Card
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
                    Text(l10n.homePointsTitle, style: textTheme.titleMedium),
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
                  l10n.homePointsBalance(demoBalancePoints),
                  style: textTheme.headlineMedium!.copyWith(fontWeight: .bold),
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
                    l10n.homePointsPendingValidation(
                      demoPendingValidationPoints,
                    ),
                    style: TextStyle(color: colorScheme.secondary),
                    overflow: .ellipsis,
                  ),
                ),
                AppSpacing.gapVXs,
                Text(l10n.homePointsNotCash, style: textTheme.labelMedium),
              ],
            ),
          ),
        ),

        /// Waiting deposit
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
                        "2",
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                      backgroundColor: colorScheme.secondary,
                    ),
                  ],
                ),
                TextButton(onPressed: () {}, child: const Text("Voir plus")),
                // TextButton(onPressed: () {}, child: Text(l10n.seeMore)),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: AppSpacing.insetVXs,
                  leading: Container(
                    width: AppSpacing.mega,
                    height: AppSpacing.mega,
                    padding: AppSpacing.insetSm,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: .2),
                      borderRadius: AppSpacing.roundedLg,
                    ),
                    child: Icon(
                      LucideIcons.bottleWine,
                      color: colorScheme.secondary,
                    ),
                  ),
                  title: Text("Bouteille", style: textTheme.bodyLarge),
                  trailing: Text(
                    "+50 pts",
                    style: textTheme.labelLarge!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                  // subtitle: Text(
                  //   "+50 pts",
                  //   style: textTheme.labelLarge!.copyWith(
                  //     color: colorScheme.secondary,
                  //   ),
                  // ),
                );
              },
            ),
          ],
        ),
        /*
        Container(
          padding: AppSpacing.insetSm,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: .5),
            ),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              ListTile(
                leading: Container(
                  width: AppSpacing.mega,
                  height: AppSpacing.mega,
                  padding: AppSpacing.insetSm,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: .2),
                    borderRadius: AppSpacing.roundedLg,
                  ),
                  child: Icon(LucideIcons.clock, color: colorScheme.secondary),
                ),
                title: Row(
                  spacing: AppSpacing.md,
                  children: [
                    Text(l10n.homePendingDepositsTitle),
                    Badge(
                      label: Text(
                        "$demoPendingDepositsCount",
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                      backgroundColor: colorScheme.secondary,
                    ),
                  ],
                ),
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: AppSpacing.iconSm,
                ),
              ),
              const AppDivider(),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  Chip(
                    label: RichText(
                      text: TextSpan(
                        text: "${l10n.homeDepositItemBottle} ",
                        style: textTheme.labelLarge,
                        children: [
                          TextSpan(
                            text: l10n.homeDepositPointsGain(
                              demoBottleDepositPoints,
                            ),
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Chip(
                    label: RichText(
                      text: TextSpan(
                        text: "${l10n.homeDepositItemIron} ",
                        style: textTheme.labelLarge,
                        children: [
                          TextSpan(
                            text: l10n.homeDepositPointsGain(
                              demoIronDepositPoints,
                            ),
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),*/
        //
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
