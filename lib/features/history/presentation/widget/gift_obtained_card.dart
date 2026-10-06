import "dart:math";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

bool _getRandomBool() => Random().nextBool();

class GiftObtainedCard extends StatelessWidget {
  const GiftObtainedCard({super.key});

  static const _demoCategory = "Santé";
  static const _demoVoucherName = "Bon pharmacie 2000 FCFA";
  static const _demoPartnerName = "Pharmacie Crésus";
  static const _demoVoucherCode = "GIFT-3X7K";
  static const _demoDateObtained = "10 sept. 2026";
  static const _demoDateExpiry = "10 oct. 2026";

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDarkMode = context.isDarkMode;
    final isGiftUsed = _getRandomBool();
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: AppSpacing.insetVXs,
        padding: AppSpacing.insetSm,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedMd,
          color: colorScheme.primaryContainer.withValues(
            alpha: isDarkMode ? .4 : 1,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: .zero,
              leading: Container(
                height: AppSpacing.giga,
                width: AppSpacing.giga,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: AppSpacing.roundedMd,
                ),
                child: Icon(LucideIcons.gift, color: colorScheme.onSecondary),
              ),
              title: Text(
                _demoCategory,
                style: TextStyle(color: colorScheme.primary),
                overflow: .ellipsis,
              ),
              subtitle: Text(
                _demoVoucherName,
                style: textTheme.titleSmall!.copyWith(fontWeight: .bold),
                overflow: .ellipsis,
              ),
              trailing: isGiftUsed
                  ? Chip(label: Text(l10n.historyVoucherStatusUsed))
                  : Chip(
                      backgroundColor: colorScheme.onSurface,
                      label: Text(
                        l10n.historyVoucherStatusActive,
                        style: TextStyle(color: colorScheme.surface),
                      ),
                    ),
            ),
            AppDivider(color: colorScheme.outline, indent: 0),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  spacing: AppSpacing.xs,
                  children: [
                    Icon(
                      LucideIcons.store,
                      size: AppSpacing.iconSm,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      _demoPartnerName,
                      style: textTheme.labelMedium!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: AppSpacing.roundedXs,
                  ),
                  child: Text(
                    _demoVoucherCode,
                    style: textTheme.labelSmall!.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapVXs,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  l10n.historyVoucherFrom(_demoDateObtained),
                  style: textTheme.labelMedium,
                ),
                Text(
                  l10n.historyVoucherUntil(_demoDateExpiry),
                  style: textTheme.labelMedium,
                ),
              ],
            )
            // if (isSuccess)
            //   Row(
            //     spacing: AppSpacing.sm,
            //     children: [
            //       Icon(
            //         LucideIcons.scale,
            //         color: colorScheme.primary,
            //         size: AppSpacing.iconMd,
            //       ),
            //       RichText(
            //         text: TextSpan(
            //           text: "Poids réel: ",
            //           style: textTheme.bodyMedium,
            //           children: const [
            //             TextSpan(
            //               text: "2 kg",
            //               style: TextStyle(fontWeight: .bold),
            //             ),
            //           ],
            //         ),
            //       ),
            //       const Spacer(),
            //       Chip(
            //         label: Text(
            //           "+20 pts certifiés",
            //           style: TextStyle(color: colorScheme.primary),
            //         ),
            //         backgroundColor: colorScheme.primary.withValues(.4),
            //       ),
            //     ],
            //   )
            // else
            //   Text(
            //     "Non conforme : matières résiduelles humides et souillés",
            //     style: TextStyle(color: colorScheme.error),
            //   ),
          ],
        ),
      ),
    );
  }
}
