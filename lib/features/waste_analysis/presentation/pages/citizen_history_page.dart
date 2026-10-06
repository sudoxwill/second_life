import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/pill_tabs.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/ticket_status.dart";
import "../providers/user_tickets_provider.dart";
import "../widgets/deposit_details_dialog.dart";
import "../widgets/ticket_widgets.dart";

// Onglet "Historique" de l'usager : en attente, traités, récompenses.
class CitizenHistoryPage extends ConsumerStatefulWidget {
  const CitizenHistoryPage({super.key});

  @override
  ConsumerState<CitizenHistoryPage> createState() => _CitizenHistoryPageState();
}

class _CitizenHistoryPageState extends ConsumerState<CitizenHistoryPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final tickets = ref.watch(userTicketsProvider);
    final refresh = ref.read(userTicketsProvider.notifier).refresh;
    final list = tickets.value ?? const <RecyclingTicket>[];
    final pending = [
      for (final t in list)
        if (t.status == TicketStatus.pending) t,
    ];
    final processed = [
      for (final t in list)
        if (t.status != TicketStatus.pending) t,
    ];

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
        children: [
          const PageHeader(
            title: "Historique de vos activités",
            subtitle: Text(
              "Suivez la validation de vos pesées et l’utilisation de vos "
              "récompenses.",
            ),
          ),
          const SizedBox(height: 18),
          PillTabs(
            selected: _tab,
            onChanged: (i) => setState(() => _tab = i),
            tabs: [
              PillTab(
                "En attente",
                badge: pending.where((t) => t.canBeProcessed).length,
              ),
              // Comme la maquette : "Validés" inclut aussi les refus.
              PillTab("Validés (${processed.length})"),
              const PillTab("Récompenses (0)"),
            ],
          ),
          const SizedBox(height: 16),
          ...switch (tickets) {
            AsyncLoading() when tickets.value == null => [
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            AsyncError(:final error) => [
              ErrorCard(error: error, onRetry: refresh),
            ],
            _ => switch (_tab) {
              0 => _tickets(
                pending,
                const EmptyState(
                  icon: Icons.schedule_rounded,
                  title: "Aucun dépôt en attente",
                  message:
                      "Scannez un déchet pour créer un dépôt, puis "
                      "présentez son QR code à un agent relais.",
                ),
                (t) => _PendingTile(ticket: t),
              ),
              1 => _tickets(
                processed,
                const EmptyState(
                  icon: Icons.verified_outlined,
                  title: "Aucun dépôt traité",
                  message:
                      "Vos dépôts apparaîtront ici après la pesée "
                      "par un agent relais.",
                ),
                (t) => _ProcessedTile(ticket: t),
              ),
              _ => [
                const EmptyState(
                  icon: Icons.redeem_outlined,
                  title: "Aucune récompense pour l’instant",
                  message:
                      "La boutique arrive bientôt : vous pourrez échanger "
                      "vos points contre du riz, de l’huile, des bons santé "
                      "ou scolarité.",
                ),
              ],
            },
          },
        ],
      ),
    );
  }

  List<Widget> _tickets(
    List<RecyclingTicket> tickets,
    Widget empty,
    Widget Function(RecyclingTicket) tile,
  ) {
    if (tickets.isEmpty) return [empty];
    return [
      for (final t in tickets) ...[tile(t), const SizedBox(height: 12)],
    ];
  }
}

class _PendingTile extends StatelessWidget {
  const _PendingTile({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final analysis = ticket.wasteAnalysisResult;
    final estimatedKg = Formatters.kg(analysis.itemWeight.estimatedWeight);
    final estimatedPoints = Formatters.points(
      analysis.itemRecyclability.pointsEarned,
    );
    return _HistoryCard(
      ticket: ticket,
      footer: Row(
        children: [
          Expanded(
            child: Text(
              "Poids estimé : ~$estimatedKg kg",
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Pill(
            label: "≈ +$estimatedPoints pts",
            color: context.warning,
            background: context.warningSoft,
          ),
        ],
      ),
    );
  }
}

class _ProcessedTile extends StatelessWidget {
  const _ProcessedTile({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final validation = ticket.validation;
    if (ticket.status == TicketStatus.rejected) {
      return _HistoryCard(
        ticket: ticket,
        footer: Text(
          [
            validation?.rejectionReason?.label,
            validation?.comment,
          ].nonNulls.join(" : "),
          style: TextStyle(
            color: context.danger,
            fontStyle: FontStyle.italic,
            fontSize: 13,
          ),
        ),
      );
    }

    final estimated = ticket.wasteAnalysisResult.itemWeight.estimatedWeight;
    final measured = validation?.measuredWeightGrams;
    return _HistoryCard(
      ticket: ticket,
      footer: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "Estimé ${Formatters.kg(estimated)} kg → "),
                  TextSpan(
                    text: "Réel ${Formatters.kg(measured ?? 0)} kg",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Pill(
            label:
                "+${Formatters.points(validation?.finalPoints ?? 0)} "
                "pts certifiés",
            color: context.primaryText,
            background: context.primarySoft,
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.ticket, required this.footer});
  final RecyclingTicket ticket;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final date = ticket.validation?.processedAt ?? ticket.createdAt;
    return AppCard(
      onTap: () => showDepositDetails(context, ticket),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TicketIcon(ticket: ticket),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.wasteAnalysisResult.detectedItem.itemLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.dateTime(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              TicketStatusBadge(ticket: ticket),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          footer,
        ],
      ),
    );
  }
}
