import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/widgets/ticket_widgets.dart";

// Confirmation après validation ou refus d'un dépôt.
class ValidationResultPage extends StatelessWidget {
  const ValidationResultPage({required this.ticket, super.key});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final validated = ticket.status == TicketStatus.validated;
    final validation = ticket.validation;
    final color = validated ? context.primaryText : context.danger;
    final soft = validated ? context.primarySoft : context.dangerSoft;
    final user = Formatters.userLabel(ticket.userId);

    return Scaffold(
      appBar: AppBar(title: const Text("Validation de la pesée")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          AppCard(
            borderColor: color.withValues(alpha: 0.5),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: soft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    validated
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    color: color,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 16),
                Pill(
                  label: validated ? "PESÉE CERTIFIÉE ✅" : "DÉPÔT REFUSÉ",
                  color: color,
                  background: soft,
                ),
                const SizedBox(height: 12),
                Text(
                  validated ? "Dépôt validé !" : "Dépôt refusé",
                  style: AppTextStyles.heading(24),
                ),
                const SizedBox(height: 4),
                Text(
                  validated
                      ? "${Formatters.points(validation?.finalPoints ?? 0)} "
                            "pts crédités à $user"
                      : "$user a été notifié du motif.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      if (validation?.measuredWeightGrams case final grams?)
                        DetailRow("Poids réel :", "${Formatters.kg(grams)} kg"),
                      DetailRow(
                        "Matériau :",
                        ticket.wasteAnalysisResult.detectedItem.itemLabel,
                      ),
                      DetailRow("Déposant :", user),
                      if (validation?.rejectionReason case final reason?)
                        DetailRow(
                          "Motif :",
                          reason.label,
                          valueColor: context.danger,
                        ),
                      if (validation?.comment case final comment?)
                        DetailRow("Commentaire :", comment),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("Retour au tableau de bord"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
