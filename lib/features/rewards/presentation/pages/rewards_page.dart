import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/routing/app_routes.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
import "../../domain/entities/reward.dart";
import "../providers/rewards_catalog_provider.dart";
import "../widgets/reward_sheet.dart";
import "../widgets/reward_style.dart";

// Catalogue rewards/ : solde en tête, récompenses de la moins chère à la
// plus chère. Les récompenses hors de portée montrent la progression.
class RewardsPage extends ConsumerWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final balance = ref.watch(pointsBalanceProvider);
    final rewards = ref.watch(rewardsProvider);

    return AppScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        title: Text(l10n.rewardsTitle),
        actions: [
          IconButton(
            tooltip: l10n.rewardsSeeVouchers,
            onPressed: () => context.go("${AppRoutes.history}?tab=gift"),
            icon: const Icon(LucideIcons.ticket),
          ),
          AppSpacing.gapHSm,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.bottomScrollablePadding,
        ),
        children: [
          FadeSlideIn(child: _BalanceHeader(balance: balance)),
          AppSpacing.gapVXl,
          ...switch (rewards) {
            AsyncError(:final error) => [ErrorCard(error: error)],
            AsyncData(:final value) when value.isEmpty => [
              EmptyState(icon: LucideIcons.gift, title: l10n.rewardsEmpty),
            ],
            AsyncData(:final value) => [
              for (final (i, reward) in value.indexed)
                FadeSlideIn(
                  index: i + 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _RewardCard(
                      reward: reward,
                      balance: balance,
                      onTap: () => showRewardSheet(context, ref, reward),
                    ),
                  ),
                ),
            ],
            _ => [
              SkeletonLoader(
                child: Column(
                  children: [
                    for (var i = 0; i < 4; i++)
                      const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: SkeletonTile(showTrailing: true),
                      ),
                  ],
                ),
              ),
            ],
          },
        ],
      ),
    );
  }
}

class _BalanceHeader extends StatelessWidget {
  const _BalanceHeader({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return BrandCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rewardsBalanceLabel,
                  style: textTheme.titleSmall!.copyWith(
                    color: BrandCard.foregroundMuted,
                  ),
                ),
                AnimatedCount(
                  value: balance,
                  builder: (context, value) => Text(
                    l10n.homePointsBalance(value),
                    style: textTheme.headlineMedium!.copyWith(
                      color: BrandCard.foreground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const IconTile(
            icon: LucideIcons.gift,
            color: AppColors.onAccent,
            background: AppColors.supernova,
            size: 52,
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.reward,
    required this.balance,
    required this.onTap,
  });

  final Reward reward;
  final int balance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final (color, soft) = reward.category.colors(context);
    final affordable = balance >= reward.pointsCost;
    final outOfStock = reward.isOutOfStock;

    return Opacity(
      opacity: outOfStock ? 0.55 : 1,
      child: AppCard(
        onTap: onTap,
        padding: AppSpacing.cardPaddingCompact,
        borderColor: affordable && !outOfStock
            ? context.primaryText.withValues(alpha: 0.35)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconTile(
                  icon: reward.category.icon,
                  color: color,
                  background: soft,
                  size: 48,
                ),
                AppSpacing.gapHMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.nameIn(context),
                        style: textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        reward.partnerIn(context),
                        style: textTheme.bodySmall!.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapHSm,
                Pill(
                  icon: LucideIcons.coins,
                  label: l10n.rewardsCost(reward.pointsCost),
                  color: context.onWarning,
                  background: context.warning,
                ),
              ],
            ),
            AppSpacing.gapVMd,
            if (outOfStock)
              Text(
                l10n.rewardsOutOfStock,
                style: textTheme.labelMedium!.copyWith(color: context.danger),
              )
            else if (affordable)
              Row(
                children: [
                  Icon(
                    LucideIcons.lockOpen,
                    size: AppSpacing.iconSm,
                    color: context.primaryText,
                  ),
                  AppSpacing.gapHXs,
                  Expanded(
                    child: Text(
                      reward.stock == null
                          ? l10n.rewardsValidity(reward.validityDays)
                          : l10n.rewardsStockLeft(reward.stock!),
                      style: textTheme.labelMedium!.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(l10n.rewardsRedeem),
                  ),
                ],
              )
            else ...[
              RewardCostProgress(balance: balance, cost: reward.pointsCost),
              AppSpacing.gapVXs,
              Text(
                l10n.rewardsMissing(reward.pointsCost - balance),
                style: textTheme.labelMedium!.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
