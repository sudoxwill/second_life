import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
import "../../domain/entities/reward_entity.dart";
import "../providers/rewards_provider.dart";
import "../widgets/reward_category_style.dart";

class RewardDetailPage extends ConsumerWidget {
  const RewardDetailPage({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final rewardAsync = ref.watch(rewardByIdProvider(id));

    return Scaffold(
      appBar: AppBar(),
      body: rewardAsync.when(
        loading: () => SkeletonList(
          itemCount: 3,
          itemBuilder: (_, _) => const SkeletonCard(),
        ),
        error: (e, _) => ErrorCard(
          error: e,
          onRetry: () => ref.invalidate(rewardByIdProvider(id)),
        ),
        data: (reward) {
          if (reward == null) {
            return EmptyState(
              icon: LucideIcons.gift,
              title: l10n.rewardsEmptyTitle,
              message: l10n.rewardsEmptyMessage,
            );
          }
          return _RewardDetail(reward: reward);
        },
      ),
    );
  }
}

class _RewardDetail extends StatelessWidget {
  const _RewardDetail({required this.reward});
  final RewardEntity reward;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final fg = reward.category.foregroundColor(context);
    final bg = reward.category.backgroundColor(context);

    return ListView(
      padding: AppSpacing.insetMd,
      children: [
        // Illustration
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(
              reward.category.icon,
              color: fg,
              size: AppSpacing.iconXl,
            ),
          ),
        ),
        AppSpacing.gapVLg,

        // Nom et catégorie
        Text(
          reward.name,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        AppSpacing.gapVXs,
        Center(
          child: Pill(
            label: reward.category.label(l10n),
            color: fg,
            background: bg,
          ),
        ),
        AppSpacing.gapVLg,

        // Coût
        AppCard(
          padding: AppSpacing.insetMd,
          child: Row(
            children: [
              Icon(LucideIcons.coins, color: fg, size: AppSpacing.iconMd),
              AppSpacing.gapHSm,
              Expanded(
                child: Text(
                  l10n.rewardsCostPts(reward.pointsCost),
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: fg,
                  ),
                ),
              ),
              if (reward.isComingSoon)
                Pill(
                  label: l10n.rewardsSoon,
                  color: scheme.onSurfaceVariant,
                  background: scheme.surfaceContainerHighest,
                ),
            ],
          ),
        ),
        AppSpacing.gapVMd,

        // Conditions
        if (reward.conditionsText != null) ...[
          AppCard(
            padding: AppSpacing.insetMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      size: AppSpacing.iconSm,
                      color: scheme.onSurfaceVariant,
                    ),
                    AppSpacing.gapHXs,
                    Text(
                      l10n.rewardsDetailConditionsTitle,
                      style: textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapVSm,
                Text(
                  reward.conditionsText!,
                  style: textTheme.bodyMedium!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapVMd,
        ],

        // Avertissement no-cash
        Container(
          padding: AppSpacing.insetMd,
          decoration: BoxDecoration(
            color: context.warningSoft,
            borderRadius: AppSpacing.roundedMd,
          ),
          child: Row(
            children: [
              Icon(
                LucideIcons.alertTriangle,
                size: AppSpacing.iconSm,
                color: context.warning,
              ),
              AppSpacing.gapHSm,
              Expanded(
                child: Text(
                  l10n.rewardsDetailNoCash,
                  style: textTheme.labelMedium!.copyWith(
                    color: context.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
