import "package:flutter/material.dart" hide MaterialType;
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_outlined_button.dart";
import "../../domain/entities/deposit_entity.dart";
import "deposit_status_badge.dart";
import "material_type_icon.dart";

class DepositDetailSheet extends StatefulWidget {
  const DepositDetailSheet({
    required this.deposit,
    required this.scrollController,
    super.key,
  });

  final DepositEntity deposit;
  final ScrollController scrollController;

  @override
  State<DepositDetailSheet> createState() => _DepositDetailSheetState();
}

class _DepositDetailSheetState extends State<DepositDetailSheet> {
  Future<void> _launchMaps() async {
    final lat = widget.deposit.centerLatitude;
    final lng = widget.deposit.centerLongitude;
    final query = lat != null && lng != null
        ? "$lat,$lng"
        : Uri.encodeComponent(widget.deposit.centerAddress);
    final uri = Uri.parse("https://maps.google.com/?q=$query");
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.deposit.status) {
      DepositStatus.waiting => _WaitingContent(
        deposit: widget.deposit,
        scrollController: widget.scrollController,
        onLaunchMaps: _launchMaps,
      ),
      DepositStatus.validated => _ValidatedContent(
        deposit: widget.deposit,
        scrollController: widget.scrollController,
      ),
      DepositStatus.rejected => _RejectedContent(
        deposit: widget.deposit,
        scrollController: widget.scrollController,
      ),
    };
  }
}

// ── Waiting ───────────────────────────────────────────────────

class _WaitingContent extends StatelessWidget {
  const _WaitingContent({
    required this.deposit,
    required this.scrollController,
    required this.onLaunchMaps,
  });

  final DepositEntity deposit;
  final ScrollController scrollController;
  final VoidCallback onLaunchMaps;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return ListView(
      controller: scrollController,
      padding: AppSpacing.insetMd,
      children: [
        Center(child: DepositStatusBadge(status: deposit.status)),
        AppSpacing.gapVLg,
        Center(
          child: Container(
            padding: AppSpacing.insetSm,
            width: AppSpacing.yotta * 2.4,
            color: colorScheme.outlineVariant,
            alignment: Alignment.center,
            child: QrImageView(
              data: deposit.qrData,
              size: AppSpacing.yotta * 2.25,
            ),
          ),
        ),
        Text(
          l10n.historyQrHint,
          style: textTheme.bodySmall!.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapVSm,
        if (deposit.imageUrl != null) ...[
          AppSpacing.gapVLg,
          ClipRRect(
            borderRadius: AppSpacing.roundedMd,
            child: Image.network(
              deposit.imageUrl!,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
        AppSpacing.gapVLg,
        Text(l10n.historyInfoTitle, style: textTheme.titleSmall),
        AppSpacing.gapVSm,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            Chip(
              avatar: Icon(
                LucideIcons.recycle,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(deposit.material.label(l10n)),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.scale,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(l10n.historyWeightApprox(deposit.estimatedWeight)),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.building2,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(deposit.centerName),
            ),
            ActionChip(
              avatar: Icon(
                LucideIcons.navigation,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(deposit.centerAddress),
              onPressed: onLaunchMaps,
            ),
            Chip(
              avatar: Icon(
                LucideIcons.clock,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(
                context.formatDateTime(deposit.dateTime),
              ),
            ),
          ],
        ),
        AppSpacing.gapVLg,
        Container(
          padding: AppSpacing.insetMd,
          decoration: const BoxDecoration(
            color: AppColors.semanticWarningBg,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Text(
            l10n.historyPendingCredit(deposit.points ?? 0),
            style: textTheme.bodyMedium!.copyWith(
              color: AppColors.semanticWarning,
            ),
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

// ── Validated ─────────────────────────────────────────────────

class _ValidatedContent extends StatelessWidget {
  const _ValidatedContent({
    required this.deposit,
    required this.scrollController,
  });

  final DepositEntity deposit;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final weightDiffers =
        deposit.realWeight != null &&
        deposit.realWeight != deposit.estimatedWeight;

    return ListView(
      controller: scrollController,
      padding: AppSpacing.insetMd,
      children: [
        Container(
          padding: AppSpacing.insetMd,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(
                l10n.historyStatusValidated,
                style: textTheme.titleMedium!.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.historyPointsCredited(deposit.points ?? 0),
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              if (weightDiffers)
                Text(
                  l10n.historyWeightComparison(
                    deposit.estimatedWeight,
                    deposit.realWeight ?? deposit.estimatedWeight,
                  ),
                  style: textTheme.bodySmall!.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ),
        if (deposit.imageUrl != null) ...[
          AppSpacing.gapVLg,
          ClipRRect(
            borderRadius: AppSpacing.roundedMd,
            child: Image.network(
              deposit.imageUrl!,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
        AppSpacing.gapVLg,
        Text(l10n.historyInfoTitle, style: textTheme.titleSmall),
        AppSpacing.gapVSm,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (deposit.agentName != null)
              Chip(
                avatar: Icon(
                  LucideIcons.userCheck,
                  size: AppSpacing.iconSm,
                  color: colorScheme.secondary,
                ),
                label: Text(deposit.agentName!),
              ),

            Chip(
              avatar: Icon(
                LucideIcons.recycle,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(deposit.material.label(l10n)),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.building2,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(deposit.centerName),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.mapPin,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(deposit.centerAddress),
            ),
            if (deposit.validationDateTime != null)
              Chip(
                avatar: Icon(
                  LucideIcons.clock,
                  size: AppSpacing.iconSm,
                  color: colorScheme.secondary,
                ),
                label: Text(
                  context.formatDateTime(deposit.validationDateTime!),
                ),
              ),
          ],
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

// ── Rejected ──────────────────────────────────────────────────

class _RejectedContent extends StatelessWidget {
  const _RejectedContent({
    required this.deposit,
    required this.scrollController,
  });

  final DepositEntity deposit;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return ListView(
      controller: scrollController,
      padding: AppSpacing.insetMd,
      children: [
        Container(
          padding: AppSpacing.insetMd,
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(
                l10n.historyStatusRejected,
                style: textTheme.titleMedium!.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (deposit.rejectionReason != null)
                Text(
                  deposit.rejectionReason!,
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
            ],
          ),
        ),
        if (deposit.imageUrl != null) ...[
          AppSpacing.gapVLg,
          ClipRRect(
            borderRadius: AppSpacing.roundedMd,
            child: Image.network(
              deposit.imageUrl!,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
        AppSpacing.gapVLg,
        Text(l10n.historyInfoTitle, style: textTheme.titleSmall),
        AppSpacing.gapVSm,
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            if (deposit.agentName != null)
              Chip(
                avatar: const Icon(
                  LucideIcons.userX,
                  size: AppSpacing.iconSm,
                ),
                label: Text(deposit.agentName!),
              ),
            if (deposit.validationDateTime != null)
              Chip(
                avatar: const Icon(
                  LucideIcons.clock,
                  size: AppSpacing.iconSm,
                ),
                label: Text(
                  context.formatDateTime(deposit.validationDateTime!),
                ),
              ),
            Chip(
              avatar: const Icon(
                LucideIcons.recycle,
                size: AppSpacing.iconSm,
              ),
              label: Text(deposit.material.label(l10n)),
            ),
            Chip(
              avatar: const Icon(
                LucideIcons.building2,
                size: AppSpacing.iconSm,
              ),
              label: Text(deposit.centerName),
            ),
            Chip(
              avatar: const Icon(LucideIcons.mapPin, size: AppSpacing.iconSm),
              label: Text(deposit.centerAddress),
            ),
          ],
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
