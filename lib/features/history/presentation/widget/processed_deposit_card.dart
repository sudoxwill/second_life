import "dart:math";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

bool _getRandomBool() => Random().nextBool();

class ProcessedDepositCard extends StatelessWidget {
  const ProcessedDepositCard({super.key});

  static const _demoMaterial = "Bouteille en verre ambré";
  static const _demoDate = "22 sept. 2026 à 16:40";
  static const _demoRealWeight = 2.0;
  static const _demoPoints = 20;
  static const _demoRejectionReason =
      "Non conforme : matières résiduelles humides et souillés";

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                _demoMaterial,
                overflow: .ellipsis,
                maxLines: 2,
              ),
              subtitle: const Text(_demoDate),
              trailing: isSuccess
                  ? Chip(
                      avatar: const Icon(LucideIcons.badgeCheck),
                      label: Text(l10n.historyStatusValidated),
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
                        l10n.historyStatusRejected,
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
                  Text(
                    l10n.historyWeightReal(_demoRealWeight),
                    style: textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      l10n.historyPointsCertified(_demoPoints),
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    backgroundColor:
                        colorScheme.primary.withValues(alpha: .4),
                  ),
                ],
              )
            else
              Text(
                _demoRejectionReason,
                style: TextStyle(color: colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }
}
