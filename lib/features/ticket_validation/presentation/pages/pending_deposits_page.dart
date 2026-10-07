import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../../../waste_analysis/presentation/widgets/deposit_details_dialog.dart";
import "../providers/pending_tickets_provider.dart";
import "weighing_page.dart";

// Onglet "Dépôts" de l'agent : tickets en attente de pesée.
class PendingDepositsPage extends ConsumerWidget {
  const PendingDepositsPage({required this.agent, super.key});
  final RelayAgent agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingTicketsProvider);
    final refresh = ref.read(pendingTicketsProvider.notifier).refresh;
    final list = pending.value ?? const <RecyclingTicket>[];

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
        children: [
          PageHeader(
            title: "Dépôts à valider",
            subtitle: Text("Point relais : ${agent.relayPointName}"),
            trailing: pending.hasValue
                ? Pill(
                    label: "${list.length} en attente",
                    color: context.warning,
                    background: context.warningSoft,
                  )
                : null,
          ),
          const SizedBox(height: 18),
          ...switch (pending) {
            AsyncLoading() when !pending.hasValue => [
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            AsyncError(:final error) => [
              ErrorCard(error: error, onRetry: refresh),
            ],
            _ when list.isEmpty => [
              const EmptyState(
                icon: Icons.inventory_2_outlined,
                title: "Aucun dépôt en attente",
                message: "Tirez vers le bas pour actualiser.",
              ),
            ],
            _ => [
              for (final ticket in list) ...[
                _PendingDepositCard(ticket: ticket),
                const SizedBox(height: 12),
              ],
            ],
          },
        ],
      ),
    );
  }
}

class _PendingDepositCard extends StatelessWidget {
  const _PendingDepositCard({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final analysis = ticket.wasteAnalysisResult;
    final estimatedKg = Formatters.kg(analysis.itemWeight.estimatedWeight);
    return AppCard(
      onTap: () => showDepositDetails(context, ticket, showDepositor: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(
                icon: Icons.eco_outlined,
                color: context.primaryText,
                background: context.primarySoft,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          Formatters.userLabel(ticket.userId),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Pill(
                          label: Formatters.shortCode(ticket.code),
                          color: scheme.onSurfaceVariant,
                          background: scheme.surfaceContainerLow,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      analysis.detectedItem.itemLabel,
                      style: TextStyle(
                        color: context.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
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
                    const TextSpan(text: "Poids IA : "),
                    TextSpan(
                      text: "~$estimatedKg kg",
                      style: const TextStyle(fontWeight: FontWeight.w700),
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
                Formatters.time(ticket.createdAt),
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            onPressed: () => openWeighing(context, ticket.code),
            icon: const Icon(Icons.scale_outlined, size: 18),
            label: const Text("Passer à la pesée"),
          ),
        ],
      ),
    );
  }
}
