import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../history/presentation/widgets/material_type_icon.dart";
import "../../../ticket_validation/domain/entities/relay_point_stock.dart";
import "../../../ticket_validation/presentation/pages/weighing_page.dart";
import "../../../ticket_validation/presentation/providers/agent_history_provider.dart";
import "../../../ticket_validation/presentation/providers/current_relay_agent_provider.dart";
import "../../../ticket_validation/presentation/providers/pending_tickets_provider.dart";
import "../../../ticket_validation/presentation/providers/relay_point_stock_provider.dart";
import "../../../ticket_validation/presentation/providers/ticket_validation_providers.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";

class AgentHome extends ConsumerWidget {
  const AgentHome({super.key});

  static const _maxPendingShown = 3;
  // Au-delà, le lot est annoncé comme bientôt prêt pour l'enlèvement.
  static const _almostFullRatio = 0.8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final agent = ref.watch(currentRelayAgentProvider).value;
    final stats = ref.watch(agentStatsProvider).value;
    final history = ref.watch(agentHistoryProvider).value ?? [];
    final pending = ref.watch(pendingTicketsProvider).value ?? [];

    final treatedDeposits =
        (stats?.validatedCount ?? 0) + (stats?.rejectedCount ?? 0);
    final totalPoints = history
        .where((t) => t.status == TicketStatus.validated)
        .fold<double>(0.0, (sum, t) => sum + (t.validation?.finalPoints ?? 0))
        .round();
    // Lot en cours, tenu dans relay_point_stocks/{relayPointId}.
    final stock = ref.watch(relayPointStockProvider).value;
    final goalKg = stock?.batchTargetKg ?? RelayPointStock.defaultBatchTargetKg;
    final progress = stock?.progress ?? 0;
    final collectedKg = stock?.collectedKg ?? 0;
    final siteName = agent?.relayPointName ?? "";
    final remainingKg = stock?.remainingKg ?? goalKg;

    var index = 0;
    Widget appear(Widget child) => FadeSlideIn(index: index++, child: child);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        appear(
          _AgentStockCard(
            title: l10n.agentStockTitle,
            siteName: siteName,
            collectedLabel: l10n.agentStockKgCollected(collectedKg),
            goalLabel: l10n.agentStockKgGoal(goalKg),
            progress: progress,
            lastPickupAt: stock?.lastPickupAt,
            onCollect: agent == null || collectedKg == 0
                ? null
                : () => _confirmBatchCollected(
                    context,
                    ref,
                    relayPointId: agent.relayPointId,
                    collectedKg: collectedKg,
                  ),
          ),
        ),
        appear(
          Row(
            spacing: AppSpacing.md,
            children: [
              Expanded(
                child: _AgentStatCard(
                  icon: LucideIcons.packageCheck,
                  value: treatedDeposits,
                  label: l10n.agentStatsTreatedDeposits,
                  onTap: context.goAgentHistory,
                ),
              ),
              Expanded(
                child: _AgentStatCard(
                  icon: LucideIcons.sparkles,
                  value: totalPoints,
                  label: l10n.agentStatsValidatedPoints,
                  onTap: context.goAgentHistory,
                ),
              ),
            ],
          ),
        ),
        appear(
          QuickActionCard(
            highlighted: true,
            icon: LucideIcons.scanQrCode,
            title: l10n.agentQuickScanTitle,
            subtitle: l10n.agentQuickScanSubtitle,
            onTap: context.pushAgentScan,
          ),
        ),
        appear(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              SectionHeader(
                title: l10n.homePendingDepositsTitle,
                count: pending.length,
                actionLabel: pending.isEmpty ? null : l10n.commonSeeMore,
                onAction: context.goAgentDeposits,
              ),
              if (pending.isEmpty)
                _PendingEmpty(message: l10n.agentPendingEmptyMessage)
              else
                for (final ticket in pending.take(_maxPendingShown))
                  _PendingTile(ticket: ticket),
            ],
          ),
        ),
        appear(
          AppCard(
            color: context.infoSoft,
            borderColor: context.info.withValues(alpha: 0.25),
            child: Row(
              children: [
                IconTile(
                  icon: LucideIcons.truck,
                  color: context.colorScheme.surface,
                  background: context.info,
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Text(
                    progress >= _almostFullRatio
                        ? l10n.agentInfoMessage
                        : l10n.agentInfoRemaining(remainingKg),
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Le bouton central de la barre déborde au-dessus du contenu.
        AppSpacing.gapVXl,
      ],
    );
  }
}

class _AgentStatCard extends StatelessWidget {
  const _AgentStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final int value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: icon,
            color: context.primaryText,
            background: context.primarySoft,
            size: 40,
          ),
          AppSpacing.gapVMd,
          AnimatedCount(
            value: value,
            builder: (context, v) => Text(
              "$v",
              style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            label,
            style: textTheme.labelLarge!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentStockCard extends StatelessWidget {
  const _AgentStockCard({
    required this.title,
    required this.siteName,
    required this.collectedLabel,
    required this.goalLabel,
    required this.progress,
    this.lastPickupAt,
    this.onCollect,
  });

  final String title;
  final String siteName;
  final String collectedLabel;
  final String goalLabel;
  final double progress;
  final DateTime? lastPickupAt;
  final VoidCallback? onCollect;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return BrandCard(
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: progress),
        duration: AppSpacing.durationMegaSlow,
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: AppSpacing.md,
              children: [
                const IconTile(
                  icon: LucideIcons.weight,
                  color: AppColors.onAccent,
                  background: AppColors.supernova,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium!.copyWith(
                          color: BrandCard.foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (siteName.isNotEmpty)
                        Text(
                          siteName,
                          style: textTheme.bodySmall!.copyWith(
                            color: BrandCard.foregroundMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  Formatters.percent(value),
                  style: textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.supernova,
                  ),
                ),
              ],
            ),
            AppSpacing.gapVLg,
            ClipRRect(
              borderRadius: AppSpacing.roundedFull,
              child: LinearProgressIndicator(
                value: value,
                minHeight: 10,
                color: AppColors.supernova,
                backgroundColor: BrandCard.foreground.withValues(alpha: 0.15),
              ),
            ),
            AppSpacing.gapVSm,
            // Wrap : passe à la ligne sur les petits écrans ou grandes polices.
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpacing.sm,
              children: [
                Text(
                  collectedLabel,
                  style: textTheme.bodyMedium!.copyWith(
                    color: BrandCard.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  goalLabel,
                  style: textTheme.labelMedium!.copyWith(
                    color: BrandCard.foregroundMuted,
                  ),
                ),
              ],
            ),
            Divider(
              height: AppSpacing.xxl,
              color: BrandCard.foreground.withValues(alpha: 0.15),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    lastPickupAt == null
                        ? ""
                        : context.l10n.agentBatchLastPickup(
                            context.formatDate(lastPickupAt!),
                          ),
                    style: textTheme.labelMedium!.copyWith(
                      color: BrandCard.foregroundMuted,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: onCollect,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.supernova,
                    foregroundColor: AppColors.onAccent,
                    disabledBackgroundColor: BrandCard.foreground.withValues(
                      alpha: 0.12,
                    ),
                    disabledForegroundColor: BrandCard.foregroundMuted,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(LucideIcons.truck, size: AppSpacing.iconSm),
                  label: Text(context.l10n.agentBatchCollect),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Le camion est passé : le compteur du lot repart de zéro.
Future<void> _confirmBatchCollected(
  BuildContext context,
  WidgetRef ref, {
  required String relayPointId,
  required int collectedKg,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(LucideIcons.truck, color: context.primaryText),
      title: Text(l10n.agentBatchCollectConfirmTitle),
      content: Text(l10n.agentBatchCollectConfirmMessage(collectedKg)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.commonConfirm),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  final result = await ref.read(markBatchCollectedProvider)(relayPointId);
  if (!context.mounted) return;
  result.fold(
    (_) => showAppSnackBar(context, l10n.agentBatchError, error: true),
    (_) => showAppSnackBar(context, l10n.agentBatchCollected),
  );
}

class _PendingTile extends StatelessWidget {
  const _PendingTile({required this.ticket});

  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final analysis = ticket.wasteAnalysisResult;
    return Padding(
      padding: AppSpacing.insetVXs,
      child: AppCard(
        padding: AppSpacing.listItemPaddingSm,
        onTap: () => openWeighing(context, ticket.code),
        child: Row(
          children: [
            MaterialTypeIcon(
              material: MaterialTypeFromCategory.fromCategory(
                analysis.detectedItem.itemMainCategory,
              ),
              size: AppSpacing.mega,
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    analysis.detectedItem.itemLabel,
                    style: textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${Formatters.userLabel(context.l10n, ticket.userId)} · "
                    "${Formatters.time(ticket.createdAt)}",
                    style: textTheme.bodySmall!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.scale,
              size: AppSpacing.iconMd,
              color: context.primaryText,
            ),
            AppSpacing.gapHXs,
            Icon(
              LucideIcons.chevronRight,
              size: AppSpacing.iconMd,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingEmpty extends StatelessWidget {
  const _PendingEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return AppCard(
      child: Row(
        children: [
          IconTile(
            icon: LucideIcons.inbox,
            color: scheme.onSurfaceVariant,
            background: scheme.surfaceContainerHighest,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homePendingDepositsEmpty,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
