import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";
import "../../domain/entities/voucher_entity.dart";
import "voucher_detail_sheet.dart";

class VoucherHistoryCard extends StatelessWidget {
  const VoucherHistoryCard({required this.voucher, super.key});

  final VoucherEntity voucher;

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        builder: (ctx, sc) =>
            VoucherDetailSheet(voucher: voucher, scrollController: sc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDark = context.isDarkMode;

    final (badgeBg, badgeFg, badgeLabel) = switch (voucher.status) {
      VoucherStatus.active => (
        AppColors.semanticSuccessBg,
        AppColors.semanticSuccess,
        l10n.historyVoucherStatusActive,
      ),
      VoucherStatus.used => (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
        l10n.historyVoucherStatusUsed,
      ),
      VoucherStatus.expired => (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
        l10n.historyVoucherStatusExpired,
      ),
    };

    final dateObtained = context.formatDate(voucher.obtainedAt);
    final dateExpiry = context.formatDate(voucher.expiresAt);

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        margin: AppSpacing.insetVXs,
        padding: AppSpacing.insetSm,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedMd,
          color:
              colorScheme.primaryContainer.withValues(alpha: isDark ? .4 : 1),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: AppSpacing.giga,
                height: AppSpacing.giga,
                decoration: const BoxDecoration(
                  color: AppColors.accentSubtle,
                  borderRadius: AppSpacing.roundedMd,
                ),
                child: const Icon(
                  LucideIcons.ticket,
                  color: AppColors.accent,
                  size: AppSpacing.iconMd,
                ),
              ),
              title: Text(
                voucher.partnerName,
                style: TextStyle(color: colorScheme.primary),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                voucher.name,
                style: textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Chip(
                label: Text(
                  badgeLabel,
                  style: TextStyle(
                    color: badgeFg,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: badgeBg,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
            AppDivider(color: colorScheme.outline, indent: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: AppSpacing.xs,
                  children: [
                    Icon(
                      LucideIcons.coins,
                      size: AppSpacing.iconSm,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    Text(
                      l10n.historyPointsSpent(voucher.pointsSpent),
                      style: textTheme.labelMedium!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Text(
                  l10n.historyVoucherCode(voucher.voucherCode),
                  style: textTheme.labelSmall!.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            AppSpacing.gapVXs,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.historyVoucherFrom(dateObtained),
                  style: textTheme.labelMedium,
                ),
                Text(
                  l10n.historyVoucherUntil(dateExpiry),
                  style: textTheme.labelMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
