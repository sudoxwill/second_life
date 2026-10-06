import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/pill_tabs.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/widgets/deposit_details_dialog.dart";
import "../../../waste_analysis/presentation/widgets/ticket_widgets.dart";
import "../../domain/entities/agent_daily_stats.dart";
import "../providers/agent_history_provider.dart";

// Onglet "Historique" de l'agent : dépôts qu'il a validés ou refusés.
class AgentHistoryPage extends ConsumerStatefulWidget {
  const AgentHistoryPage({required this.agent, super.key});
  final RelayAgent agent;

  @override
  ConsumerState<AgentHistoryPage> createState() => _AgentHistoryPageState();
}

class _AgentHistoryPageState extends ConsumerState<AgentHistoryPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(agentHistoryProvider);
    final refresh = ref.read(agentHistoryProvider.notifier).refresh;
    final all = history.value ?? const <RecyclingTicket>[];
    final now = DateTime.now();
    final today = [
      for (final t in all)
        if (t.validation != null &&
            AgentDailyStats.isSameDay(t.validation!.processedAt, now))
          t,
    ];
    final shown = _tab == 0 ? today : all;

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
        children: [
          PageHeader(
            title: "Historique des validations",
            subtitle: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: "Dépôts certifiés à : "),
                  TextSpan(
                    text: widget.agent.relayPointName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          PillTabs(
            selected: _tab,
            onChanged: (i) => setState(() => _tab = i),
            tabs: [
              PillTab(
                "Aujourd’hui (${today.length})",
                icon: Icons.calendar_today_outlined,
              ),
              PillTab(
                "Dépôts traités (${all.length})",
                icon: Icons.history_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...switch (history) {
            AsyncLoading() when !history.hasValue => [
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            AsyncError(:final error) => [
              ErrorCard(error: error, onRetry: refresh),
            ],
            _ when shown.isEmpty => [
              EmptyState(
                icon: Icons.fact_check_outlined,
                title: _tab == 0
                    ? "Aucun dépôt traité aujourd’hui"
                    : "Aucun dépôt traité",
                message: "Scannez le QR code d’un usager pour commencer.",
              ),
            ],
            _ => [
              for (final t in shown) ...[
                _AgentHistoryCard(ticket: t),
                const SizedBox(height: 12),
              ],
            ],
          },
        ],
      ),
    );
  }
}

class _AgentHistoryCard extends StatelessWidget {
  const _AgentHistoryCard({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final validation = ticket.validation;
    final validated = ticket.status == TicketStatus.validated;

    return AppCard(
      onTap: () => showDepositDetails(context, ticket, showDepositor: true),
      child: Column(
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
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Déposant : "),
                          TextSpan(
                            text: Formatters.userLabel(ticket.userId),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (validated)
                Pill(
                  label:
                      "+${Formatters.points(validation?.finalPoints ?? 0)} pts",
                  color: context.primaryText,
                  background: context.primarySoft,
                )
              else
                TicketStatusBadge(ticket: ticket),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.scale_outlined, size: 16, color: context.primaryText),
              const SizedBox(width: 6),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Poids réel : "),
                    TextSpan(
                      text: switch (validation?.measuredWeightGrams) {
                        null => "–",
                        final grams => "${Formatters.kg(grams)} kg",
                      },
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: validated ? context.primaryText : null,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(fontSize: 13),
              ),
              const Spacer(),
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                validation == null
                    ? ""
                    : Formatters.dateTime(validation.processedAt),
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          if (!validated && validation?.rejectionReason != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validation!.rejectionReason!.label,
                style: TextStyle(
                  color: context.danger,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
