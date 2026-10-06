import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../providers/agent_history_provider.dart";
import "../providers/pending_tickets_provider.dart";

// Onglet "Tableau" de l'agent.
class AgentDashboardPage extends ConsumerWidget {
  const AgentDashboardPage({
    required this.agent,
    required this.onScan,
    required this.onOpenPending,
    super.key,
  });
  // Seuil d'enlèvement du lot par le camion municipal.
  static const batchTargetGrams = 200000.0;

  final RelayAgent agent;
  final VoidCallback onScan;
  final VoidCallback onOpenPending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingTicketsProvider);
    final daily = ref.watch(agentDailyStatsProvider);
    final stats = ref.watch(agentStatsProvider);

    Future<void> refresh() async {
      ref.invalidate(pendingTicketsProvider);
      await ref.read(agentHistoryProvider.notifier).refresh();
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
        children: [
          _AgentCard(agent: agent),
          const SizedBox(height: 14),
          _PendingCard(count: pending.value?.length, onTap: onOpenPending),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onScan,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(64),
              textStyle: AppTextStyles.heading(17),
            ),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text("Scanner un QR de dépôt"),
          ),
          const SizedBox(height: 22),
          const SectionLabel("Statistiques du jour"),
          const SizedBox(height: 10),
          if (daily case AsyncError(:final error))
            ErrorCard(error: error, onRetry: refresh)
          else ...[
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.check_circle_outline_rounded,
                    title: "Traités",
                    value: daily.value?.processedCount.toString(),
                    caption: "dépôts traités",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    icon: Icons.workspace_premium_outlined,
                    title: "Points",
                    value: daily.value == null
                        ? null
                        : Formatters.points(daily.value!.validatedPoints),
                    caption: "pts validés",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _StockCard(
              relayPointName: agent.relayPointName,
              collectedGrams: stats.value?.collectedWeightGrams,
            ),
          ],
        ],
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({required this.agent});
  final RelayAgent agent;

  @override
  Widget build(BuildContext context) {
    final white70 = Colors.white.withValues(alpha: 0.75);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.grassCourt, AppColors.primaryPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg + 4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  Formatters.initials(agent.displayName),
                  style: AppTextStyles.heading(20, color: Colors.white),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "AGENT RELAIS CERTIFIÉ",
                          style: TextStyle(
                            color: white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6EE7A8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      agent.displayName,
                      style: AppTextStyles.heading(20, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Rattaché à : "),
                          TextSpan(
                            text: agent.relayPointName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(color: white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  agent.serviceHours == null
                      ? "Point relais ${agent.relayPointId}"
                      : "Horaires de service : ${agent.serviceHours}",
                  style: TextStyle(color: white70, fontSize: 13),
                ),
              ),
              const Text(
                "Poste actif",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.check_box_rounded,
                color: Color(0xFF6EE7A8),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.count, required this.onTap});
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(
            icon: Icons.inventory_2_outlined,
            color: context.warning,
            background: context.warningSoft,
            size: 48,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Dépôts en attente",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (count != null)
                      Pill(
                        label: "$count",
                        color: context.onWarning,
                        background: context.warning,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "Usagers en file d’attente pour pesée",
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
  });
  final IconData icon;
  final String title;
  final String? value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: context.primaryText),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value ?? "–", style: AppTextStyles.heading(28)),
          Text(
            caption,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// Total pesé et validé par l'agent, comparé au seuil d'enlèvement.
// Il n'y a pas encore de suivi des enlèvements : le total ne repart
// pas à zéro.
class _StockCard extends StatelessWidget {
  const _StockCard({
    required this.relayPointName,
    required this.collectedGrams,
  });
  final String relayPointName;
  final double? collectedGrams;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final grams = collectedGrams ?? 0;
    final ratio = (grams / AgentDashboardPage.batchTargetGrams).clamp(0.0, 1.0);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(
                icon: Icons.scale_outlined,
                color: context.primaryText,
                background: context.primarySoft,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Stock actuel du point relais",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      relayPointName,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                collectedGrams == null ? "–" : "${Formatters.kg(grams)} kg",
                style: AppTextStyles.heading(20, color: context.primaryText),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "Progression du lot (${Formatters.percent(ratio)})",
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
              const Spacer(),
              Text(
                "Objectif : "
                "${Formatters.kg(AgentDashboardPage.batchTargetGrams)} kg",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 10,
              color: context.primaryText,
            ),
          ),
          if (ratio >= 0.7) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    color: context.primaryText,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ratio >= 1
                          ? "Lot prêt : prévenez le service municipal "
                                "pour l’enlèvement !"
                          : "Lot bientôt prêt pour enlèvement par le "
                                "camion municipal !",
                      style: TextStyle(
                        color: context.primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
