import "dart:math";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

bool _getRandomBool() => Random().nextBool();

class ProcessedDepositCard extends StatelessWidget {
  const ProcessedDepositCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDarkMode = context.isDarkMode;
    final isSuccess = _getRandomBool();
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
                child: Icon(LucideIcons.box, color: colorScheme.onSecondary),
              ),
              title: const Text(
                "Bouteille en verre ambré",
                overflow: .ellipsis,
                maxLines: 2,
              ),
              subtitle: const Text("22 sept. 2026 à 16:40"),
              trailing: isSuccess
                  ? const Chip(
                      avatar: Icon(LucideIcons.badgeCheck),
                      label: Text("Validé"),
                    )
                  : Chip(
                      side: BorderSide(
                        color: isSuccess
                            ? Colors.transparent
                            : colorScheme.error.withValues(alpha: .4),
                      ),
                      avatar: Icon(
                        LucideIcons.badgeX,
                        color: colorScheme.error,
                      ),
                      label: Text(
                        "Refusé",
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
            ),
            AppDivider(color: colorScheme.outline, indent: 0),
            if (isSuccess)
              Row(
                spacing: AppSpacing.sm,
                children: [
                  Icon(
                    LucideIcons.scale,
                    color: colorScheme.primary,
                    size: AppSpacing.iconMd,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Poids réel: ",
                      style: textTheme.bodyMedium,
                      children: const [
                        TextSpan(
                          text: "2 kg",
                          style: TextStyle(fontWeight: .bold),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "+20 pts certifiés",
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    backgroundColor: colorScheme.primary.withValues(alpha: .4),
                  ),
                ],
              )
            else
              Text(
                "Non conforme : matières résiduelles humides et souillés",
                style: TextStyle(color: colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }
}
