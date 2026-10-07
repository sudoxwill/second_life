import "package:flutter/material.dart" hide MaterialType;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/routing/app_routes.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../history/presentation/providers/history_providers.dart";
import "../../../history/presentation/widgets/deposit_history_card.dart";
import "../../../history/presentation/widgets/material_type_icon.dart";
import "../../../rewards/domain/redemption_policy.dart";
import "../../../rewards/presentation/providers/rewards_catalog_provider.dart";
import "../../../rewards/presentation/widgets/reward_style.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";

class UserHome extends ConsumerWidget {
  const UserHome({super.key});

  // Au-delà, "Voir plus" mène à l'historique.
  static const _maxPendingShown = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final stats = ref.watch(citizenStatsProvider).value;
    final pendingDeposits = ref.watch(pendingDepositsProvider).value ?? [];

    var index = 0;
    Widget appear(Widget child) => FadeSlideIn(index: index++, child: child);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        appear(_PointsCard(pending: stats?.pendingPoints.round() ?? 0)),
        appear(
          Row(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: _MiniStat(
                  icon: LucideIcons.recycle,
                  value: "${Formatters.kg(stats?.recycledWeightGrams ?? 0)} kg",
                  label: l10n.homeStatRecycledLabel,
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: LucideIcons.circleCheck,
                  value: "${stats?.validatedCount ?? 0}",
                  label: l10n.homeStatValidatedLabel,
                  onTap: () => context.go("${AppRoutes.history}?tab=processed"),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  icon: LucideIcons.hourglass,
                  value: "${stats?.pendingCount ?? 0}",
                  label: l10n.homeStatPendingLabel,
                  onTap: () => context.go("${AppRoutes.history}?tab=waiting"),
                ),
              ),
            ],
          ),
        ),
        appear(
          Column(
            spacing: AppSpacing.sm,
            children: [
              QuickActionCard(
                highlighted: true,
                icon: LucideIcons.scanBox,
                title: l10n.homeQuickScanTitle,
                subtitle: l10n.homeQuickScanSubtitle,
                onTap: context.pushScan,
              ),
              QuickActionCard(
                icon: LucideIcons.mapPinned,
                title: l10n.homeQuickPlacesTitle,
                subtitle: l10n.homeQuickPlacesSubtitle,
                onTap: context.goPlaces,
              ),
            ],
          ),
        ),
        appear(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.xs,
            children: [
              SectionHeader(
                title: l10n.homePendingDepositsTitle,
                count: pendingDeposits.length,
                actionLabel: pendingDeposits.isEmpty
                    ? null
                    : l10n.commonSeeMore,
                onAction: () => context.go("${AppRoutes.history}?tab=waiting"),
              ),
              if (pendingDeposits.isEmpty)
                _PendingEmpty(onScan: context.pushScan)
              else
                for (final ticket in pendingDeposits.take(_maxPendingShown))
                  _PendingDepositTile(ticket: ticket),
            ],
          ),
        ),
        appear(const _EcoImpactCard()),
        // Le bouton central de la barre déborde au-dessus du contenu.
        AppSpacing.gapVXl,
      ],
    );
  }
}

// Solde de users/{uid}, points en attente (tickets) et objectif de la
// prochaine récompense du catalogue.
class _PointsCard extends ConsumerWidget {
  const _PointsCard({required this.pending});

  final int pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final balance = ref.watch(pointsBalanceProvider);
    final next = ref.watch(nextRewardProvider);
    final hasCatalog = ref.watch(rewardsProvider).value?.isNotEmpty ?? false;
    return BrandCard(
      onTap: context.pushRewards,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homePointsTitle,
                  style: textTheme.titleMedium!.copyWith(
                    color: BrandCard.foregroundMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AppSpacing.gapHSm,
              _RedeemButton(
                label: l10n.homePointsRedeemCta,
                onTap: context.pushRewards,
              ),
            ],
          ),
          AppSpacing.gapVSm,
          AnimatedCount(
            value: balance,
            builder: (context, value) => FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.homePointsBalance(value),
                style: textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: BrandCard.foreground,
                ),
              ),
            ),
          ),
          AppSpacing.gapVSm,
          if (pending > 0) ...[
            Pill(
              icon: LucideIcons.hourglass,
              label: l10n.homePointsPendingValidation(pending),
              color: AppColors.supernova,
              background: AppColors.supernova.withValues(alpha: 0.15),
            ),
            AppSpacing.gapVMd,
          ],
          if (next != null) ...[
            Row(
              children: [
                const Icon(LucideIcons.target, size: AppSpacing.iconSm),
                AppSpacing.gapHXs,
                Expanded(
                  child: Text(
                    l10n.homeNextReward(
                      next.pointsCost - balance,
                      next.nameIn(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelLarge!.copyWith(
                      color: BrandCard.foreground,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapVSm,
            ClipRRect(
              borderRadius: AppSpacing.roundedFull,
              child: TweenAnimationBuilder<double>(
                tween: Tween(
                  end: RedemptionPolicy.progress(
                    balance: balance,
                    cost: next.pointsCost,
                  ),
                ),
                duration: AppSpacing.durationSlow,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  color: AppColors.supernova,
                  backgroundColor: BrandCard.foreground.withValues(alpha: 0.15),
                ),
              ),
            ),
            AppSpacing.gapVMd,
          ] else if (hasCatalog) ...[
            Row(
              children: [
                const Icon(LucideIcons.partyPopper, size: AppSpacing.iconSm),
                AppSpacing.gapHXs,
                Expanded(
                  child: Text(
                    l10n.homeAllRewardsUnlocked,
                    style: textTheme.labelLarge!.copyWith(
                      color: BrandCard.foreground,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapVMd,
          ],
          Text(
            l10n.homePointsNotCash,
            style: textTheme.labelMedium!.copyWith(
              color: BrandCard.foregroundMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _RedeemButton extends StatelessWidget {
  const _RedeemButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.supernova,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [
              const Icon(
                LucideIcons.gift,
                size: AppSpacing.iconSm,
                color: AppColors.onAccent,
              ),
              Text(
                label,
                style: context.textTheme.labelLarge!.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.insetMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSpacing.iconMd, color: context.primaryText),
          AppSpacing.gapVSm,
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingDepositTile extends StatelessWidget {
  const _PendingDepositTile({required this.ticket});

  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final analysis = ticket.wasteAnalysisResult;
    final points = analysis.itemRecyclability.pointsEarned.round();
    return Padding(
      padding: AppSpacing.insetVXs,
      child: AppCard(
        padding: AppSpacing.listItemPaddingSm,
        onTap: () => showDepositDetailSheet(context, ticket),
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
                    context.formatDateTime(ticket.createdAt),
                    style: textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Pill(
              label: l10n.homeDepositPointsGain(points),
              color: context.warning,
              background: context.warningSoft,
            ),
          ],
        ),
      ),
    );
  }
}

class _PendingEmpty extends StatelessWidget {
  const _PendingEmpty({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.colorScheme;
    return AppCard(
      onTap: onScan,
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
                  l10n.homePendingDepositsEmpty,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.homePendingDepositsEmptyHint,
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

class _EcoImpactCard extends StatelessWidget {
  const _EcoImpactCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return AppCard(
      color: context.primarySoft,
      borderColor: context.primaryText.withValues(alpha: 0.2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: LucideIcons.leaf,
            color: context.colorScheme.onPrimary,
            background: context.primaryText,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xs,
              children: [
                Text(
                  l10n.homeEcoImpactTitle,
                  style: textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  l10n.homeEcoImpactSubtitle,
                  style: textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onPrimaryContainer,
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
