import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";

class AgentHome extends StatefulWidget {
  const AgentHome({super.key});

  @override
  State<AgentHome> createState() => _AgentHomeState();
}

class _AgentHomeState extends State<AgentHome> {
  static const int _demoDeposits = 42;
  static const int _demoPoints = 1250;
  static const int _demoCollectedKg = 142;
  static const int _demoGoalKg = 200;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final percent = (_demoCollectedKg / _demoGoalKg * 100).round();
    return Column(
      spacing: AppSpacing.md,
      children: [
        Row(
          spacing: AppSpacing.md,
          children: [
            Expanded(
              child: _AgentStatCard(
                icon: LucideIcons.inbox,
                value: _demoDeposits.toString(),
                label: l10n.agentStatsTreatedDeposits,
              ),
            ),
            Expanded(
              child: _AgentStatCard(
                icon: LucideIcons.badgeDollarSign,
                value: _demoPoints.toString(),
                label: l10n.agentStatsValidatedPoints,
              ),
            ),
          ],
        ),
        _AgentStockCard(
          title: l10n.agentStockTitle,
          collectedLabel: l10n.agentStockKgCollected(_demoCollectedKg),
          goalLabel: l10n.agentStockKgGoal(_demoGoalKg),
          percent: percent,
          progress: _demoCollectedKg / _demoGoalKg,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Text(l10n.homePendingDepositsTitle),
                    Badge(
                      label: Text(
                        "2",
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                      backgroundColor: colorScheme.secondary,
                    ),
                  ],
                ),
                TextButton(onPressed: () {}, child: const Text("Voir plus")),
                // TextButton(onPressed: () {}, child: Text(l10n.seeMore)),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: AppSpacing.insetVXs,
                  leading: Container(
                    width: AppSpacing.mega,
                    height: AppSpacing.mega,
                    padding: AppSpacing.insetSm,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: .2),
                      borderRadius: AppSpacing.roundedLg,
                    ),
                    child: Icon(
                      LucideIcons.bottleWine,
                      color: colorScheme.secondary,
                    ),
                  ),
                  title: Text("Bouteille", style: textTheme.bodyLarge),
                  trailing: Text(
                    "+50 pts",
                    style: textTheme.labelLarge!.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                  // subtitle: Text(
                  //   "+50 pts",
                  //   style: textTheme.labelLarge!.copyWith(
                  //     color: colorScheme.secondary,
                  //   ),
                  // ),
                );
              },
            ),
          ],
        ),
        // Info
        Container(
          padding: AppSpacing.insetXs,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: .5),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: AppSpacing.mega,
              height: AppSpacing.mega,
              padding: AppSpacing.insetSm,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.roundedLg,
                color: colorScheme.onSurface,
              ),
              child: Icon(LucideIcons.badgeInfo, color: colorScheme.surface),
            ),
            title: Text("Info", style: textTheme.labelMedium),
            subtitle: Text(
              "Lôt bientôt prêt pour l'enlèvement par le camion municipal.",
              style: textTheme.labelSmall,
            ),
          ),
        ),
      ],
    );
  }
}

class _AgentStatCard extends StatelessWidget {
  const _AgentStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Card(
      margin: .zero,
      color: AppColors.grassCourt,
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      child: Padding(
        padding: AppSpacing.insetMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colorScheme.secondary, size: AppSpacing.iconMd),
            AppSpacing.gapVSm,
            Text(
              value,
              style: textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: textTheme.labelLarge!.copyWith(color: AppColors.neutral50),
            ),
          ],
        ),
      ),
    );
  }
}

class _AgentStockCard extends StatelessWidget {
  const _AgentStockCard({
    required this.title,
    required this.collectedLabel,
    required this.goalLabel,
    required this.percent,
    required this.progress,
  });

  final String title;
  final String collectedLabel;
  final String goalLabel;
  final int percent;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Card(
      margin: .zero,
      // color: AppColors.grassCourt,
      child: Padding(
        padding: AppSpacing.insetMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                Container(
                  padding: AppSpacing.insetMd,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: AppSpacing.roundedMd,
                  ),
                  child: Icon(LucideIcons.weight, color: colorScheme.secondary),
                ),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(title, style: textTheme.titleMedium),
                    const Text("EcoCentre de Bè"),
                  ],
                ),
                const Spacer(),
                Text(
                  "$percent%",
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            AppSpacing.gapVSm,
            ClipRRect(
              borderRadius: AppSpacing.roundedFull,
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            AppSpacing.gapVSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(collectedLabel, style: textTheme.bodyMedium),
                Text(
                  goalLabel,
                  style: textTheme.labelMedium!.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
