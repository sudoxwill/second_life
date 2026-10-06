import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:qr_flutter/qr_flutter.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_outlined_button.dart";
import "../../domain/entities/voucher_entity.dart";

class VoucherDetailSheet extends StatelessWidget {
  const VoucherDetailSheet({
    required this.voucher,
    required this.scrollController,
    super.key,
  });

  final VoucherEntity voucher;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final isActive = voucher.status == VoucherStatus.active;

    return ListView(
      controller: scrollController,
      padding: AppSpacing.insetMd,
      children: [
        // ── Illustration ────────────────────────────────
        Center(
          child: Container(
            width: AppSpacing.tera,
            height: AppSpacing.tera,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.ticket,
              color: colorScheme.secondary,
              size: AppSpacing.iconXxl,
            ),
          ),
        ),
        AppSpacing.gapVMd,
        Text(
          voucher.name,
          style: textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVXs,
        Text(
          voucher.partnerName,
          style: textTheme.bodyMedium!
              .copyWith(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVSm,
        Center(
          child: Chip(
            label: Text(l10n.historyPointsSpent(voucher.pointsSpent)),
            backgroundColor: colorScheme.secondaryContainer,
            labelStyle: TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        AppSpacing.gapVLg,

        // ── QR section ──────────────────────────────────
        _QrSection(voucher: voucher),
        AppSpacing.gapVSm,
        Text(
          l10n.historyVoucherRef(voucher.voucherCode),
          style: textTheme.labelMedium!.copyWith(
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        if (isActive) ...[
          AppSpacing.gapVXs,
          Text(
            l10n.historyVoucherExpiry(context.formatDate(voucher.expiresAt)),
            style: textTheme.labelSmall!
                .copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
        AppSpacing.gapVLg,

        // ── Conditions ──────────────────────────────────
        Text(l10n.historyVoucherConditionsTitle, style: textTheme.titleSmall),
        AppSpacing.gapVSm,
        Text(
          l10n.historyVoucherConditionsBody,
          style: textTheme.bodySmall!
              .copyWith(color: colorScheme.onSurfaceVariant),
        ),
        AppSpacing.gapVMd,
        Container(
          padding: AppSpacing.insetMd,
          decoration: const BoxDecoration(
            color: AppColors.semanticWarningBg,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Row(
            spacing: AppSpacing.sm,
            children: [
              const Icon(
                LucideIcons.triangleAlert,
                size: AppSpacing.iconSm,
                color: AppColors.semanticWarning,
              ),
              Expanded(
                child: Text(
                  l10n.historyVoucherNoCash,
                  style: textTheme.bodySmall!.copyWith(
                    color: AppColors.semanticWarning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapVLg,
        AppOutlinedButton(
          onPressed: () => Navigator.pop(context),
          text: l10n.commonBack,
        ),
        AppSpacing.gapVSm,
      ],
    );
  }
}

class _QrSection extends StatelessWidget {
  const _QrSection({required this.voucher});

  final VoucherEntity voucher;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final isActive = voucher.status == VoucherStatus.active;

    final overlay = switch (voucher.status) {
      VoucherStatus.used => voucher.usedAt != null
          ? l10n.historyVoucherUsedDate(context.formatDate(voucher.usedAt!))
          : l10n.historyVoucherStatusUsed,
      VoucherStatus.expired =>
        l10n.historyVoucherExpiryPast(context.formatDate(voucher.expiresAt)),
      VoucherStatus.active => null,
    };

    final qr = Center(
      child: Container(
        padding: AppSpacing.insetSm,
        width: AppSpacing.yotta * 2.4,
        color: colorScheme.outlineVariant,
        alignment: Alignment.center,
        child: QrImageView(
          data: voucher.voucherCode,
          size: AppSpacing.yotta * 2.25,
        ),
      ),
    );

    if (isActive) return qr;

    return Stack(
      alignment: Alignment.center,
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0,      0,      0,      1, 0,
          ]),
          child: Opacity(opacity: 0.4, child: qr),
        ),
        if (overlay != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.85),
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Text(
              overlay,
              style: context.textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
