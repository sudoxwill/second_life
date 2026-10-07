import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../../shared/presentation/widgets/others/pill_tabs.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/widgets/deposit_details_dialog.dart";
import "../../../waste_analysis/presentation/widgets/ticket_widgets.dart";
import "../../domain/entities/agent_daily_stats.dart";
import "../providers/agent_history_provider.dart";
import "../widgets/relay_agent_builder.dart";

// Onglet "Historique" de l'agent : dépôts qu'il a validés ou refusés.
class AgentHistoryPage extends StatelessWidget {
  const AgentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RelayAgentBuilder(
      builder: (_, agent) => _AgentHistoryView(agent: agent),
    );
  }
}

class _AgentHistoryView extends ConsumerStatefulWidget {
  const _AgentHistoryView({required this.agent});
  final RelayAgent agent;

  @override
  ConsumerState<_AgentHistoryView> createState() => _AgentHistoryViewState();
}

class _AgentHistoryViewState extends ConsumerState<_AgentHistoryView> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(title: Text(l10n.agentHistoryTitle)),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.bottomScrollablePadding,
          ),
          children: [
            Row(
              spacing: AppSpacing.xs,
              children: [
                Icon(
                  LucideIcons.building2,
                  size: AppSpacing.iconSm,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                Expanded(
                  child: Text(
                    l10n.agentHistorySubtitle(widget.agent.relayPointName),
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapVMd,
            PillTabs(
              selected: _tab,
              onChanged: (i) => setState(() => _tab = i),
              tabs: [
                PillTab(
                  l10n.agentHistoryTabToday(today.length),
                  icon: LucideIcons.calendarDays,
                ),
                PillTab(
                  l10n.agentHistoryTabAll(all.length),
                  icon: LucideIcons.history,
                ),
              ],
            ),
            AppSpacing.gapVLg,
            ...switch (history) {
              AsyncLoading() when !history.hasValue => [
                const Padding(
                  padding: AppSpacing.insetXxxl,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              AsyncError(:final error) => [
                ErrorCard(error: error, onRetry: refresh),
              ],
              _ when shown.isEmpty => [
                EmptyState(
                  icon: LucideIcons.clipboardCheck,
                  title: _tab == 0
                      ? l10n.agentHistoryEmptyToday
                      : l10n.agentHistoryEmptyAll,
                  message: l10n.agentHistoryEmptyMessage,
                ),
              ],
              _ => [
                for (final (i, t) in shown.indexed)
                  FadeSlideIn(
                    // Clé par onglet : les cartes se rejouent au changement.
                    key: ValueKey((_tab, t.code)),
                    index: i,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _AgentHistoryCard(ticket: t),
                    ),
                  ),
              ],
            },
          ],
        ),
      ),
    );
  }
}

class _AgentHistoryCard extends StatelessWidget {
  const _AgentHistoryCard({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final validation = ticket.validation;
    final validated = ticket.status == TicketStatus.validated;

    return AppCard(
      padding: AppSpacing.cardPaddingCompact,
      onTap: () => showDepositDetails(context, ticket, showDepositor: true),
      child: Column(
        children: [
          Row(
            children: [
              TicketIcon(ticket: ticket),
              AppSpacing.gapHMd,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: l10n.agentHistoryDepositor),
                          TextSpan(
                            text: Formatters.userLabel(
                              context.l10n,
                              ticket.userId,
                            ),
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
              AppSpacing.gapHSm,
              if (validated)
                Pill(
                  icon: LucideIcons.sparkles,
                  label: l10n.homeDepositPointsGain(
                    (validation?.finalPoints ?? 0).round(),
                  ),
                  color: context.primaryText,
                  background: context.primarySoft,
                )
              else
                TicketStatusBadge(ticket: ticket),
            ],
          ),
          const Divider(height: AppSpacing.xxl),
          Row(
            children: [
              Icon(
                LucideIcons.scale,
                size: AppSpacing.iconSm,
                color: context.primaryText,
              ),
              AppSpacing.gapHXs,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: l10n.agentHistoryRealWeight),
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
                LucideIcons.clock,
                size: AppSpacing.iconSm,
                color: scheme.onSurfaceVariant,
              ),
              AppSpacing.gapHXs,
              Text(
                validation == null
                    ? ""
                    : context.formatDateTime(validation.processedAt),
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          if (!validated && validation?.rejectionReason != null) ...[
            AppSpacing.gapVSm,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validation!.rejectionReason!.label(l10n),
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
