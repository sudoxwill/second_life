import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../domain/entities/points_conversion.dart";
import "../../domain/entities/redemption_voucher.dart";

/// Vignette affichant un bon d'achat débloqué dans la liste des récompenses obtenues.
class VoucherCardTile extends StatelessWidget {
  const VoucherCardTile({
    required this.voucher,
    required this.onMarkAsUsed,
    super.key,
  });

  final RedemptionVoucher voucher;
  final VoidCallback onMarkAsUsed;

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: voucher.voucherCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Code ${voucher.voucherCode} copié"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isUsed = voucher.status == VoucherStatus.used;
    final isExpired = !voucher.isValid && !isUsed;

    final Color badgeColor;
    final String badgeLabel;

    if (isUsed) {
      badgeColor = colorScheme.outline;
      badgeLabel = "Utilisé";
    } else if (isExpired) {
      badgeColor = colorScheme.error;
      badgeLabel = "Expiré";
    } else {
      badgeColor = colorScheme.primary;
      badgeLabel = "Valide";
    }

    return Card(
      elevation: 0,
      color: isUsed
          ? colorScheme.surfaceContainer.withValues(alpha: 0.5)
          : colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedXl,
        side: BorderSide(
          color: isUsed
              ? colorScheme.outlineVariant.withValues(alpha: 0.5)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Entête : marque, titre et badge de statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        voucher.brand,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        voucher.rewardTitle,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isUsed
                              ? colorScheme.onSurface.withValues(alpha: 0.6)
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs - 2,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.15),
                    borderRadius: AppSpacing.roundedFull,
                  ),
                  child: Text(
                    badgeLabel,
                    style: textTheme.labelSmall?.copyWith(
                      color: badgeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapVMd,

            // Code du bon d'achat
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppSpacing.roundedMd,
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SelectableText(
                      voucher.voucherCode,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: isUsed
                            ? colorScheme.onSurface.withValues(alpha: 0.5)
                            : colorScheme.primary,
                        decoration: isUsed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _copyCode(context),
                    borderRadius: AppSpacing.roundedSm,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      child: Icon(
                        LucideIcons.copy,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapVMd,

            // Valeur et informations de validité
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Valeur du bon",
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      "${voucher.tierName} (${PointsConversion.formatFcfa(voucher.monetaryValue)})",
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (!isUsed && voucher.isValid)
                  TextButton.icon(
                    onPressed: onMarkAsUsed,
                    icon: const Icon(LucideIcons.check, size: 14),
                    label: const Text("Marquer utilisé"),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                      ),
                      visualDensity: VisualDensity.compact,
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
