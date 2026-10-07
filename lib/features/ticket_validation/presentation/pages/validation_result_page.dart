import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
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
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final validated = ticket.status == TicketStatus.validated;
    final validation = ticket.validation;
    final color = validated ? context.primaryText : context.danger;
    final soft = validated ? context.primarySoft : context.dangerSoft;
    final user = Formatters.userLabel(l10n, ticket.userId);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.weighingTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          AppCard(
            borderColor: color.withValues(alpha: 0.5),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Petit rebond de l'icône à l'arrivée sur l'écran.
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.4, end: 1),
                  duration: AppSpacing.durationSlow,
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: soft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      validated ? LucideIcons.circleCheck : LucideIcons.circleX,
                      color: color,
                      size: 44,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Pill(
                  label: validated
                      ? l10n.resultCertifiedPill
                      : l10n.resultRejectedPill,
                  color: color,
                  background: soft,
                ),
                const SizedBox(height: 12),
                Text(
                  validated
                      ? l10n.resultValidatedTitle
                      : l10n.resultRejectedTitle,
                  style: AppTextStyles.heading(24),
                ),
                const SizedBox(height: 4),
                Text(
                  validated
                      ? l10n.resultPointsCredited(
                          Formatters.points(validation?.finalPoints ?? 0),
                          user,
                        )
                      : l10n.resultUserNotified(user),
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
                        DetailRow(
                          l10n.detailRealWeight,
                          "${Formatters.kg(grams)} kg",
                        ),
                      DetailRow(
                        l10n.depositMaterial,
                        ticket.wasteAnalysisResult.detectedItem.itemLabel,
                      ),
                      DetailRow(l10n.depositDepositor, user),
                      if (validation?.rejectionReason case final reason?)
                        DetailRow(
                          l10n.detailReason,
                          reason.label(l10n),
                          valueColor: context.danger,
                        ),
                      if (validation?.comment case final comment?)
                        DetailRow(l10n.detailComment, comment),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(LucideIcons.layoutDashboard),
                  label: Text(l10n.resultBackToDashboard),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
