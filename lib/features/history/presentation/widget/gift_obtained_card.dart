import "dart:math";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

bool _getRandomBool() => Random().nextBool();

class GiftObtainedCard extends StatelessWidget {
  const GiftObtainedCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                "Santé",
                style: TextStyle(color: colorScheme.primary),
                overflow: .ellipsis,
              ),
              subtitle: Text(
                "Bon pharmacie 2000 FCFA",
                style: textTheme.titleSmall!.copyWith(fontWeight: .bold),
                overflow: .ellipsis,
              ),
              trailing: isGiftUsed
                  ? const Chip(label: Text("Utilisé"))
                  : Chip(
                      backgroundColor: colorScheme.onSurface,
                      label: Text(
                        "Actif",
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
                      "Pharmacie Crésus",
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
                    "GIFT-3X7K",
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
                Text("Du 10 sept. 2026", style: textTheme.labelMedium),
                Text("Exp le 10 oct. 2026", style: textTheme.labelMedium),
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
            //         backgroundColor: colorScheme.primary.withValues(alpha: .4),
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
