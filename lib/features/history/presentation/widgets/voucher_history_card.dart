import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/localized_field.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../rewards/domain/entities/voucher.dart";
import "voucher_detail_sheet.dart";

class VoucherHistoryCard extends StatelessWidget {
  const VoucherHistoryCard({required this.voucher, super.key});

  final Voucher voucher;

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
    final active = voucher.status == VoucherStatus.active;

    final (badgeBg, badgeFg, badgeLabel) = switch (voucher.status) {
      VoucherStatus.active => (
        isDark ? AppColors.semanticSuccessBgDark : AppColors.semanticSuccessBg,
        isDark ? AppColors.semanticSuccessDark : AppColors.semanticSuccess,
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
    final mutedLabel = textTheme.labelMedium!.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: AppSpacing.insetVXs,
      // Bons utilisés ou expirés atténués : l'œil va d'abord aux bons actifs.
      child: Opacity(
        opacity: active ? 1 : 0.7,
        child: AppCard(
          padding: AppSpacing.cardPaddingCompact,
          onTap: () => _openDetail(context),
          child: Column(
            children: [
              Row(
                children: [
                  IconTile(
                    icon: LucideIcons.ticket,
                    color: isDark
                        ? AppColors.onAccentSubtleDark
                        : AppColors.onAccentSubtle,
                    background: isDark
                        ? AppColors.accentSubtleDark
                        : AppColors.accentSubtle,
                    size: AppSpacing.mega,
                  ),
                  AppSpacing.gapHMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizedField(voucher.name, l10n.localeName),
                          style: textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          localizedField(voucher.partnerName, l10n.localeName),
                          style: textTheme.bodySmall!.copyWith(
                            color: colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapHSm,
                  Pill(
                    label: badgeLabel,
                    color: badgeFg,
                    background: badgeBg,
                    outlined: true,
                  ),
                ],
              ),
              const Divider(height: AppSpacing.xxl),
              Row(
                children: [
                  Icon(
                    LucideIcons.coins,
                    size: AppSpacing.iconSm,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.gapHXs,
                  Text(
                    l10n.historyPointsSpent(voucher.pointsSpent),
                    style: mutedLabel,
                  ),
                  const Spacer(),
                  Text(
                    l10n.historyVoucherCode(voucher.code),
                    style: mutedLabel.copyWith(letterSpacing: 1.2),
                  ),
                ],
              ),
              AppSpacing.gapVXs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.historyVoucherFrom(dateObtained),
                    style: mutedLabel,
                  ),
                  Text(l10n.historyVoucherUntil(dateExpiry), style: mutedLabel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
