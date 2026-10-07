import "package:flutter/material.dart" hide MaterialType;
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_outlined_button.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/widgets/ticket_widgets.dart";
import "deposit_status_badge.dart";
import "material_type_icon.dart";

class DepositDetailSheet extends StatelessWidget {
  const DepositDetailSheet({
    required this.ticket,
    required this.scrollController,
    super.key,
  });

  final RecyclingTicket ticket;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return switch (ticket.status) {
      TicketStatus.pending => _WaitingContent(
        ticket: ticket,
        scrollController: scrollController,
      ),
      TicketStatus.validated => _ValidatedContent(
        ticket: ticket,
        scrollController: scrollController,
      ),
      TicketStatus.rejected => _RejectedContent(
        ticket: ticket,
        scrollController: scrollController,
      ),
    };
  }
}

// ── Waiting ───────────────────────────────────────────────────

class _WaitingContent extends StatelessWidget {
  const _WaitingContent({
    required this.ticket,
    required this.scrollController,
  });

  final RecyclingTicket ticket;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final material = MaterialTypeFromCategory.fromCategory(
      ticket.wasteAnalysisResult.detectedItem.itemMainCategory,
    );
    final estimatedWeight =
        ticket.wasteAnalysisResult.itemWeight.estimatedWeight;
    final estimatedPoints =
        ticket.wasteAnalysisResult.itemRecyclability.pointsEarned.round();

    return ListView(
      controller: scrollController,
      padding: AppSpacing.insetMd,
      children: [
        Center(child: DepositStatusBadge(status: ticket.status)),
        AppSpacing.gapVLg,
        Center(
          child: Container(
            padding: AppSpacing.insetSm,
            width: AppSpacing.yotta * 2.4,
            color: colorScheme.outlineVariant,
            alignment: Alignment.center,
            child: QrImageView(
              data: ticket.qrData,
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
              label: Text(material.label(l10n)),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.scale,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(l10n.historyWeightApprox(estimatedWeight)),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.clock,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(context.formatDateTime(ticket.createdAt)),
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
            l10n.historyPendingCredit(estimatedPoints),
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
    required this.ticket,
    required this.scrollController,
  });

  final RecyclingTicket ticket;
  final ScrollController scrollController;

  Future<void> _launchMaps(String address) async {
    final uri = Uri.parse(
      "https://maps.google.com/?q=${Uri.encodeComponent(address)}",
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final validation = ticket.validation!;
    final material = MaterialTypeFromCategory.fromCategory(
      ticket.wasteAnalysisResult.detectedItem.itemMainCategory,
    );
    final estimatedWeight =
        ticket.wasteAnalysisResult.itemWeight.estimatedWeight;
    final realWeightKg = validation.measuredWeightGrams != null
        ? validation.measuredWeightGrams! / 1000
        : null;
    final weightDiffers =
        realWeightKg != null && realWeightKg != estimatedWeight;
    final points = validation.finalPoints?.round() ?? 0;
    final centerAddress = validation.agent.relayPointDescription;

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
                l10n.historyPointsCredited(points),
                style: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              if (weightDiffers)
                Text(
                  l10n.historyWeightComparison(estimatedWeight, realWeightKg),
                  style: textTheme.bodySmall!.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ),
        AppSpacing.gapVLg,
        Text(l10n.historyInfoTitle, style: textTheme.titleSmall),
        AppSpacing.gapVSm,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            Chip(
              avatar: Icon(
                LucideIcons.userCheck,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(validation.agent.displayName),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.recycle,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(material.label(l10n)),
            ),
            Chip(
              avatar: Icon(
                LucideIcons.building2,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(validation.agent.relayPointName),
            ),
            if (centerAddress != null)
              ActionChip(
                avatar: Icon(
                  LucideIcons.navigation,
                  size: AppSpacing.iconSm,
                  color: colorScheme.secondary,
                ),
                label: Text(centerAddress),
                onPressed: () => _launchMaps(centerAddress),
              ),
            Chip(
              avatar: Icon(
                LucideIcons.clock,
                size: AppSpacing.iconSm,
                color: colorScheme.secondary,
              ),
              label: Text(context.formatDateTime(validation.processedAt)),
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
    required this.ticket,
    required this.scrollController,
  });

  final RecyclingTicket ticket;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final validation = ticket.validation!;
    final material = MaterialTypeFromCategory.fromCategory(
      ticket.wasteAnalysisResult.detectedItem.itemMainCategory,
    );
    final rejectionText = validation.rejectionReason?.label ??
        validation.comment ??
        "";
    final centerAddress = validation.agent.relayPointDescription;

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
              if (rejectionText.isNotEmpty)
                Text(
                  rejectionText,
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
            ],
          ),
        ),
        AppSpacing.gapVLg,
        Text(l10n.historyInfoTitle, style: textTheme.titleSmall),
        AppSpacing.gapVSm,
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            Chip(
              avatar: const Icon(
                LucideIcons.userX,
                size: AppSpacing.iconSm,
              ),
              label: Text(validation.agent.displayName),
            ),
            Chip(
              avatar: const Icon(
                LucideIcons.clock,
                size: AppSpacing.iconSm,
              ),
              label: Text(context.formatDateTime(validation.processedAt)),
            ),
            Chip(
              avatar: const Icon(
                LucideIcons.recycle,
                size: AppSpacing.iconSm,
              ),
              label: Text(material.label(l10n)),
            ),
            Chip(
              avatar: const Icon(
                LucideIcons.building2,
                size: AppSpacing.iconSm,
              ),
              label: Text(validation.agent.relayPointName),
            ),
            if (centerAddress != null)
              Chip(
                avatar: const Icon(LucideIcons.mapPin, size: AppSpacing.iconSm),
                label: Text(centerAddress),
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
