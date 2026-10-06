import "package:flutter/material.dart";

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
    final scheme = Theme.of(context).colorScheme;
    final rows = [
      Row(
        children: [
          const Text("Statut", style: TextStyle(fontSize: 13)),
          const Spacer(),
          TicketStatusBadge(ticket: ticket),
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
                      const SectionLabel("Fiche du dépôt"),
                      const SizedBox(height: 4),
                      Text(
                        "ID : ${Formatters.shortCode(ticket.code)}",
                        style: AppTextStyles.heading(20),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: "Fermer",
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
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
              child: const Text("Fermer"),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _detailRows(BuildContext context) {
    final analysis = ticket.wasteAnalysisResult;
    final validation = ticket.validation;
    return [
      DetailRow("Matière", analysis.detectedItem.itemLabel),
      if (showDepositor)
        DetailRow("Déposant", Formatters.userLabel(ticket.userId)),
      DetailRow(
        "Poids estimé (IA)",
        "~${Formatters.kg(analysis.itemWeight.estimatedWeight)} kg",
      ),
      if (validation?.measuredWeightGrams case final measured?)
        DetailRow(
          "Poids réel certifié",
          "${Formatters.kg(measured)} kg",
          valueColor: context.primaryText,
        ),
      if (validation?.finalPoints case final points?)
        DetailRow(
          "Points attribués",
          "${Formatters.points(points)} pts",
          valueColor: context.primaryText,
        )
      else if (ticket.status == TicketStatus.pending)
        DetailRow(
          "Points estimés",
          "${Formatters.points(analysis.itemRecyclability.pointsEarned)} pts",
          valueColor: context.primaryText,
        ),
      if (validation?.rejectionReason case final reason?)
        DetailRow("Motif du refus", reason.label, valueColor: context.danger),
      if (validation?.comment case final comment?)
        DetailRow("Commentaire de l’agent", comment),
      if (validation != null) ...[
        DetailRow(
          ticket.status == TicketStatus.rejected ? "Refusé par" : "Validé par",
          "${validation.agent.displayName} "
          "(${validation.agent.relayPointName})",
        ),
        DetailRow("Traité le", Formatters.dateTime(validation.processedAt)),
      ] else
        DetailRow("Déposé le", Formatters.dateTime(ticket.createdAt)),
    ];
  }
}

class _QrBlock extends StatelessWidget {
  const _QrBlock({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            "QR Code à présenter à l’agent",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          TicketQrCard(
            data: ticket.qrData,
            caption: "DEP-${Formatters.shortCode(ticket.code).substring(1)}",
            size: 140,
          ),
          const SizedBox(height: 10),
          Text(
            "L’agent scannera ce code pour charger votre pesée. "
            "Valable jusqu’au ${Formatters.dateTime(ticket.expiresAt)}.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
