import "package:flutter/material.dart" hide ButtonSegment;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../l10n/app_localizations.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/buttons/app_segmented_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
import "../../domain/entities/deposit_entity.dart";
import "../providers/history_providers.dart";
import "../widget/deposit_history_card.dart";

class AgentHistoryPage extends ConsumerStatefulWidget {
  const AgentHistoryPage({super.key});

  @override
  ConsumerState<AgentHistoryPage> createState() => _AgentHistoryPageState();
}

class _AgentHistoryPageState extends ConsumerState<AgentHistoryPage> {
  Set<_AgentFilter> _filter = {_AgentFilter.all};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return AppScaffold(
      appBar: AppBar(elevation: 0, title: Text(l10n.historyAgentTitle)),
      body: Column(
        spacing: AppSpacing.md,
        children: [
          /*
          // ── Résumé ───────────────────────────────────────────
          ref.watch(agentProcessedDepositsProvider).when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (deposits) {
                  final validated = deposits
                      .where((d) => d.status == DepositStatus.validated)
                      .length;
                  final rejected = deposits
                      .where((d) => d.status == DepositStatus.rejected)
                      .length;
                  return Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: AppSpacing.insetMd,
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _StatCell(
                                icon: LucideIcons.badgeCheck,
                                count: validated,
                                label: l10n.historyFilterValidated,
                                color: colorScheme.primary,
                                bgColor: colorScheme.primaryContainer,
                              ),
                            ),
                            VerticalDivider(
                              color: colorScheme.outlineVariant,
                              width: AppSpacing.lg,
                            ),
                            Expanded(
                              child: _StatCell(
                                icon: LucideIcons.badgeX,
                                count: rejected,
                                label: l10n.historyFilterRejected,
                                color: colorScheme.error,
                                bgColor: colorScheme.errorContainer,
                              ),
                            ),
                            VerticalDivider(
                              color: colorScheme.outlineVariant,
                              width: AppSpacing.lg,
                            ),
                            Expanded(
                              child: _StatCell(
                                icon: LucideIcons.clipboardList,
                                count: deposits.length,
                                label: l10n.historyStatTotal,
                                color: colorScheme.onSurfaceVariant,
                                bgColor: colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          */
          AppSegmentedButton<_AgentFilter>(
            segments: _AgentFilter.values
                .map(
                  (f) =>
                      ButtonSegment(value: f, label: Text(f.label(l10n))),
                )
                .toList(),
            selected: _filter,
            onSelectionChanged: (v) => setState(() => _filter = v),
          ),
          Expanded(
            child: ref
                .watch(agentProcessedDepositsProvider)
                .when(
                  loading: () => SkeletonLoader(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, _) => const Padding(
                        padding: AppSpacing.insetXs,
                        child: SkeletonTile(showTrailing: true),
                      ),
                    ),
                  ),
                  error: (_, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.md,
                      children: [
                        Icon(
                          LucideIcons.circleAlert,
                          size: AppSpacing.iconXxl,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        Text(
                          l10n.commonError,
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppElevatedButton(
                          onPressed: () =>
                              ref.invalidate(agentProcessedDepositsProvider),
                          text: l10n.commonRetry,
                        ),
                      ],
                    ),
                  ),
                  data: (deposits) {
                    final filtered = _filter.first == _AgentFilter.all
                        ? deposits
                        : deposits
                              .where(
                                (d) => _filter.first == _AgentFilter.validated
                                    ? d.status == DepositStatus.validated
                                    : d.status == DepositStatus.rejected,
                              )
                              .toList();

                    if (filtered.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.md,
                          children: [
                            Icon(
                              LucideIcons.inbox,
                              size: AppSpacing.iconXxl,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            Text(
                              l10n.historyAgentEmpty,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          DepositHistoryCard(deposit: filtered[i]),
                    );
                  },
                ),
          ),
          AppSpacing.gapVMd,
        ],
      ),
    );
  }
}

/*
class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final int count;
  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        Container(
          padding: AppSpacing.insetSm,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Icon(icon, size: AppSpacing.iconMd, color: color),
        ),
        Text(
          "$count",
          style: textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall!.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
*/

enum _AgentFilter {
  all,
  validated,
  rejected;

  String label(AppLocalizations l10n) => switch (this) {
    _AgentFilter.all => l10n.historyFilterAll,
    _AgentFilter.validated => l10n.historyFilterValidated,
    _AgentFilter.rejected => l10n.historyFilterRejected,
  };
}
