import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

class WaitingDepositCard extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDarkMode = context.isDarkMode;
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: AppSpacing.insetVXs,
        padding: AppSpacing.insetSm,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedMd,
          color: colorScheme.primaryContainer.withValues(alpha: isDarkMode ? .4 : 1),
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
                child: Icon(LucideIcons.box, color: colorScheme.onSecondary,),
              ),
              title: const Text(
                "Bouteille en plastique (PET)",
                overflow: .ellipsis,
                maxLines: 2,
              ),
              subtitle: const Text("25 sept. 2026 à 14:32"),
              trailing: const Icon(LucideIcons.chevronRight),
            ),
            AppDivider(color: colorScheme.outline, indent: 0,),
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
                    text: "Poids estimé: ",
                    style: textTheme.bodyMedium,
                    children: const [
                      TextSpan(
                        text: "~ 0.5 kg",
                        style: TextStyle(fontWeight: .bold),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    "+20 pts en attente",
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                  backgroundColor: colorScheme.secondary.withValues(
                    alpha: .4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
