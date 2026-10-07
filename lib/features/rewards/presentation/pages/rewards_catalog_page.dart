import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";
import "../../domain/entities/reward_entity.dart";
import "../providers/rewards_provider.dart";
import "../widgets/reward_category_style.dart";

class RewardsCatalogPage extends ConsumerStatefulWidget {
  const RewardsCatalogPage({super.key});

  @override
  ConsumerState<RewardsCatalogPage> createState() => _RewardsCatalogPageState();
}

class _RewardsCatalogPageState extends ConsumerState<RewardsCatalogPage> {
  RewardCategory? _category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final stats = ref.watch(citizenStatsProvider).value;
    final balance = stats?.pointsBalance.round() ?? 0;
    final pending = stats?.pendingPoints.round() ?? 0;
    final rewardsAsync = ref.watch(rewardsProvider);

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.rewardsCatalogTitle), centerTitle: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BalanceHeader(balance: balance, pending: pending),
          AppSpacing.gapVSm,
          _CategoryBar(
            selected: _category,
            onChanged: (c) => setState(() => _category = c),
          ),
          AppSpacing.gapVSm,
          Expanded(
            child: rewardsAsync.when(
              loading: () => SkeletonList(
                itemCount: 4,
                itemBuilder: (_, _) => const SkeletonCard(showAvatar: true),
              ),
              error: (e, _) => ErrorCard(
                error: e,
                onRetry: () => ref.invalidate(rewardsProvider),
              ),
              data: (all) {
                final list = _category == null
                    ? all
                    : all.where((r) => r.category == _category).toList();
                if (list.isEmpty) {
                  return EmptyState(
                    icon: LucideIcons.gift,
                    title: l10n.rewardsEmptyTitle,
                    message: l10n.rewardsEmptyMessage,
                  );
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, _) => AppSpacing.gapVSm,
                  itemBuilder: (_, i) =>
                      _RewardTile(reward: list[i], balance: balance),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader({required this.balance, required this.pending});
  final int balance;
  final int pending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return Container(
      padding: AppSpacing.insetMd,
      decoration: const BoxDecoration(
        color: AppColors.grassCourt,
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Row(
        children: [
          Container(
            padding: AppSpacing.insetSm,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: AppSpacing.roundedMd,
            ),
            child: const Icon(
              LucideIcons.coins,
              size: AppSpacing.iconLg,
              color: AppColors.neutral50,
            ),
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rewardsBalanceLabel,
                  style: textTheme.labelMedium!.copyWith(
                    color: AppColors.neutral50.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  l10n.homePointsBalance(balance),
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral50,
                  ),
                ),
              ],
            ),
          ),
          if (pending > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: AppSpacing.roundedFull,
              ),
              child: Text(
                l10n.rewardsPendingPts(pending),
                style: textTheme.labelSmall!.copyWith(
                  color: AppColors.neutral50,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Chips de catégorie ────────────────────────────────────────────────

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.selected, required this.onChanged});
  final RewardCategory? selected;
  final ValueChanged<RewardCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.colorScheme;

    final chips = <(RewardCategory?, String, IconData)>[
      (null, l10n.rewardsCategoryAll, LucideIcons.layoutGrid),
      (RewardCategory.food, l10n.rewardsCategoryFood, RewardCategory.food.icon),
      (
        RewardCategory.education,
        l10n.rewardsCategoryEducation,
        RewardCategory.education.icon,
      ),
      (
        RewardCategory.health,
        l10n.rewardsCategoryHealth,
        RewardCategory.health.icon,
      ),
    ];

    return SizedBox(
      height: AppSpacing.chipHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final (value, label, icon) in chips) ...[
            _CategoryChip(
              label: label,
              icon: icon,
              selected: selected == value,
              color: value == null
                  ? scheme.primary
                  : value.foregroundColor(context),
              soft: value == null
                  ? context.primarySoft
                  : value.backgroundColor(context),
              onTap: () => onChanged(selected == value ? null : value),
            ),
            AppSpacing.gapHXs,
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.soft,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final Color soft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final fg = selected ? scheme.surface : scheme.onSurface;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.durationFast,
        padding: AppSpacing.insetHMd,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : soft,
          borderRadius: AppSpacing.roundedFull,
          border: selected
              ? null
              : Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          spacing: AppSpacing.xs,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: AppSpacing.iconSm, color: selected ? fg : color),
            Text(
              label,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? fg : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.reward, required this.balance});
  final RewardEntity reward;
  final int balance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final fg = reward.category.foregroundColor(context);
    final bg = reward.category.backgroundColor(context);
    final affordable = balance >= reward.pointsCost;
    final missing = reward.pointsCost - balance;

    return Opacity(
      opacity: affordable ? 1.0 : 0.7,
      child: AppCard(
        padding: AppSpacing.insetMd,
        child: Row(
          children: [
            Container(
              width: AppSpacing.mega,
              height: AppSpacing.mega,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: AppSpacing.roundedMd,
              ),
              child: Icon(
                reward.category.icon,
                color: fg,
                size: AppSpacing.iconMd,
              ),
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reward.name,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapVXs,
                  Text(
                    reward.category.label(l10n),
                    style: textTheme.labelSmall!.copyWith(color: fg),
                  ),
                  AppSpacing.gapVXs,
                  if (!affordable)
                    Text(
                      l10n.rewardsMissingPts(missing),
                      style: textTheme.labelSmall!.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Text(
                      l10n.rewardsCostPts(reward.pointsCost),
                      style: textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                ],
              ),
            ),
            AppSpacing.gapHSm,
            Column(
              spacing: AppSpacing.xs,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (reward.isComingSoon)
                  Pill(
                    label: l10n.rewardsSoon,
                    color: scheme.onSurfaceVariant,
                    background: scheme.surfaceContainerHighest,
                  )
                else
                  Icon(
                    LucideIcons.chevronRight,
                    size: AppSpacing.iconSm,
                    color: scheme.onSurfaceVariant,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
