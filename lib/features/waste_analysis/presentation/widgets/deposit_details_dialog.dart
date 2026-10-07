import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/ticket_status.dart";
import "ticket_qr_card.dart";
import "ticket_widgets.dart";

// Fiche d'un dépôt. Tant qu'il peut être traité, affiche le QR code à
// présenter à l'agent.
Future<void> showDepositDetails(
  BuildContext context,
  RecyclingTicket ticket, {
  bool showDepositor = false,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _DepositDetailsDialog(ticket: ticket, showDepositor: showDepositor),
  );
}

class _DepositDetailsDialog extends StatelessWidget {
  const _DepositDetailsDialog({
    required this.ticket,
    required this.showDepositor,
  });
  final RecyclingTicket ticket;
  final bool showDepositor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final rows = [
      Row(
        children: [
          Expanded(
            child: Text(
              l10n.detailStatus,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Flexible(child: TicketStatusBadge(ticket: ticket)),
        ],
      ),
      ..._detailRows(context),
    ];

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: scheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionLabel(l10n.detailSheetTitle),
                      const SizedBox(height: 4),
                      Text(
                        l10n.detailId(Formatters.shortCode(ticket.code)),
                        style: AppTextStyles.heading(20),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: l10n.commonClose,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 16),
            if (ticket.canBeProcessed) ...[
              _QrBlock(ticket: ticket),
              const SizedBox(height: 12),
            ],
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(),
              rows[i],
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.commonClose),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _detailRows(BuildContext context) {
    final l10n = context.l10n;
    final analysis = ticket.wasteAnalysisResult;
    final validation = ticket.validation;
    return [
      DetailRow(l10n.depositMaterial, analysis.detectedItem.itemLabel),
      if (showDepositor)
        DetailRow(
          l10n.depositDepositor,
          Formatters.userLabel(l10n, ticket.userId),
        ),
      DetailRow(
        l10n.weighingEstimatedTitle,
        "~${Formatters.kg(analysis.itemWeight.estimatedWeight)} kg",
      ),
      if (validation?.measuredWeightGrams case final measured?)
        DetailRow(
          l10n.detailCertifiedWeight,
          "${Formatters.kg(measured)} kg",
          valueColor: context.primaryText,
        ),
      if (validation?.finalPoints case final points?)
        DetailRow(
          l10n.detailPointsAwarded,
          "${Formatters.points(points)} pts",
          valueColor: context.primaryText,
        )
      else if (ticket.status == TicketStatus.pending)
        DetailRow(
          l10n.detailPointsEstimated,
          "${Formatters.points(analysis.itemRecyclability.pointsEarned)} pts",
          valueColor: context.primaryText,
        ),
      if (validation?.rejectionReason case final reason?)
        DetailRow(
          l10n.detailReason,
          reason.label(l10n),
          valueColor: context.danger,
        ),
      if (validation?.comment case final comment?)
        DetailRow(l10n.detailComment, comment),
      if (validation != null) ...[
        DetailRow(
          ticket.status == TicketStatus.rejected
              ? l10n.detailRejectedBy
              : l10n.detailValidatedBy,
          "${validation.agent.displayName} "
          "(${validation.agent.relayPointName})",
        ),
        DetailRow(
          l10n.detailProcessedAt,
          context.formatDateTime(validation.processedAt),
        ),
      ] else
        DetailRow(
          l10n.detailDepositedAt,
          context.formatDateTime(ticket.createdAt),
        ),
    ];
  }
}

class _QrBlock extends StatelessWidget {
  const _QrBlock({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            l10n.detailQrTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          TicketQrCard(
            data: ticket.qrData,
            caption: "DEP-${Formatters.shortCode(ticket.code).substring(1)}",
            size: 140,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.detailQrHint(context.formatDateTime(ticket.expiresAt)),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
