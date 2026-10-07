import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../history/presentation/widget/material_type_icon.dart";
import "../../../ticket_validation/presentation/pages/weighing_page.dart";
import "../../../ticket_validation/presentation/providers/current_relay_agent_provider.dart";
import "../../../ticket_validation/presentation/providers/pending_tickets_provider.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/presentation/widgets/deposit_details_dialog.dart";

class AgentDepositPage extends ConsumerWidget {
  const AgentDepositPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final agent = ref.watch(currentRelayAgentProvider).value;
    final pending = ref.watch(pendingTicketsProvider);
    final refresh = ref.read(pendingTicketsProvider.notifier).refresh;
    final list = pending.value ?? const <RecyclingTicket>[];

    return AppScaffold(
      scrollable: false,
      padding: EdgeInsets.zero,
      appBar: AppBar(title: Text(l10n.homePendingDepositsTitle)),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.bottomScrollablePadding,
          ),
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                if (agent != null)
                  Text(
                    l10n.depositRelayPoint(agent.relayPointName),
                    style: textTheme.bodySmall!.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (pending.hasValue)
                  Pill(
                    label: l10n.depositPendingCount(list.length),
                    color: context.warning,
                    background: context.warningSoft,
                  ),
              ],
            ),
            AppSpacing.gapVMd,
            ...switch (pending) {
              AsyncLoading() when !pending.hasValue => [
                Padding(
                  padding: AppSpacing.insetXxxl,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
              AsyncError(:final error) => [
                ErrorCard(error: error, onRetry: refresh),
              ],
              _ when list.isEmpty => [
                EmptyState(
                  icon: LucideIcons.inbox,
                  title: l10n.homePendingDepositsEmpty,
                  message: l10n.depositRefreshHint,
                ),
              ],
              _ => [
                for (final ticket in list) ...[
                  _PendingDepositCard(ticket: ticket),
                  AppSpacing.gapVMd,
                ],
              ],
            },
          ],
        ),
      ),
    );
  }
}

class _PendingDepositCard extends StatelessWidget {
  const _PendingDepositCard({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final analysis = ticket.wasteAnalysisResult;
    final estimatedKg = Formatters.kg(analysis.itemWeight.estimatedWeight);
    final material = MaterialTypeFromCategory.fromCategory(
      analysis.detectedItem.itemMainCategory,
    );

    return AppCard(
      onTap: () => showDepositDetails(context, ticket, showDepositor: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              MaterialTypeIcon(material: material, size: AppSpacing.mega),
              AppSpacing.gapHMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          Formatters.userLabel(ticket.userId),
                          style: textTheme.titleSmall,
                        ),
                        Pill(
                          label: Formatters.shortCode(ticket.code),
                          color: colorScheme.onSurfaceVariant,
                          background: colorScheme.surfaceContainerLow,
                        ),
                      ],
                    ),
                    AppSpacing.gapVXs,
                    Text(
                      analysis.detectedItem.itemLabel,
                      style: textTheme.bodySmall!.copyWith(
                        color: context.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const AppDivider(),
          Row(
            children: [
              Icon(
                LucideIcons.scale,
                size: AppSpacing.iconSm,
                color: context.primaryText,
              ),
              AppSpacing.gapHXs,
              Text(
                l10n.depositAiWeight(estimatedKg),
                style: textTheme.labelMedium,
              ),
              const Spacer(),
              Icon(
                LucideIcons.clock,
                size: AppSpacing.iconSm,
                color: colorScheme.onSurfaceVariant,
              ),
              AppSpacing.gapHXs,
              Text(
                Formatters.time(ticket.createdAt),
                style: textTheme.labelMedium!.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.gapVMd,
          AppElevatedButton(
            onPressed: () => openWeighing(context, ticket.code),
            text: l10n.depositWeighButton,
          ),
        ],
      ),
    );
  }
}
