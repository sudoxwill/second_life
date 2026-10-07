import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:qr_flutter/qr_flutter.dart";

import "../../../../core/errors/failure_message.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/routing/app_routes.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../domain/entities/reward.dart";
import "../../domain/entities/voucher.dart";
import "../../domain/redemption_policy.dart";
import "../providers/rewards_catalog_provider.dart";
import "../providers/rewards_providers.dart";
import "reward_style.dart";

// Fiche d'une récompense : confirmation, échange, puis bon obtenu.
Future<void> showRewardSheet(
  BuildContext context,
  WidgetRef ref,
  Reward reward,
) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _RewardSheet(reward: reward),
  );
}

class _RewardSheet extends ConsumerStatefulWidget {
  const _RewardSheet({required this.reward});

  final Reward reward;

  @override
  ConsumerState<_RewardSheet> createState() => _RewardSheetState();
}

class _RewardSheetState extends ConsumerState<_RewardSheet> {
  bool _redeeming = false;

  Reward get reward => widget.reward;

  Future<void> _redeem(int balance) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(LucideIcons.gift, color: context.primaryText),
        title: Text(l10n.rewardsConfirmTitle(reward.pointsCost)),
        content: Text(
          l10n.rewardsConfirmMessage(
            reward.nameIn(context),
            balance - reward.pointsCost,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.rewardsRedeem),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _redeeming = true);
    final result = await ref.read(redeemRewardProvider)(reward);
    if (!mounted) return;
    setState(() => _redeeming = false);

    final voucher = result.fold<Voucher?>((failure) {
      showAppSnackBar(context, failureMessage(l10n, failure), error: true);
      return null;
    }, (voucher) => voucher);
    if (voucher == null) return;

    await HapticFeedback.heavyImpact();
    if (!mounted) return;
    final navigator = Navigator.of(context);
    final router = GoRouter.of(context);
    navigator.pop();
    await showDialog<void>(
      context: navigator.context,
      builder: (_) => _VoucherUnlockedDialog(
        reward: reward,
        voucher: voucher,
        onSeeVouchers: () => router.go("${AppRoutes.history}?tab=gift"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final balance = ref.watch(pointsBalanceProvider);
    final (color, soft) = reward.category.colors(context);
    final affordable = balance >= reward.pointsCost;
    final available = !reward.isOutOfStock;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Center(
              child: IconTile(
                icon: reward.category.icon,
                color: color,
                background: soft,
                size: 72,
              ),
            ),
            Text(
              reward.nameIn(context),
              textAlign: TextAlign.center,
              style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              reward.partnerIn(context),
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(color: context.primaryText),
            ),
            if (reward.descriptionIn(context).isNotEmpty)
              Text(
                reward.descriptionIn(context),
                textAlign: TextAlign.center,
                style: textTheme.bodySmall!.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                Pill(
                  icon: LucideIcons.coins,
                  label: l10n.rewardsCost(reward.pointsCost),
                  color: context.onWarning,
                  background: context.warning,
                ),
                Pill(
                  icon: LucideIcons.calendarDays,
                  label: l10n.rewardsValidity(reward.validityDays),
                  color: scheme.onSurfaceVariant,
                  background: scheme.surfaceContainerHighest,
                ),
                if (reward.stock != null)
                  Pill(
                    label: available
                        ? l10n.rewardsStockLeft(reward.stock!)
                        : l10n.rewardsOutOfStock,
                    color: available ? context.info : context.danger,
                    background: available
                        ? context.infoSoft
                        : context.dangerSoft,
                  ),
              ],
            ),
            AppSpacing.gapVXs,
            if (!affordable && available)
              RewardCostProgress(balance: balance, cost: reward.pointsCost),
            FilledButton.icon(
              onPressed: affordable && available && !_redeeming
                  ? () => _redeem(balance)
                  : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSpacing.buttonHeightLg),
              ),
              icon: _redeeming
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Icon(affordable ? LucideIcons.gift : LucideIcons.lock),
              label: Text(
                affordable
                    ? l10n.rewardsRedeem
                    : l10n.rewardsMissing(reward.pointsCost - balance),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Barre de progression du solde vers le coût d'une récompense (aussi sur
// l'accueil).
class RewardCostProgress extends StatelessWidget {
  const RewardCostProgress({
    required this.balance,
    required this.cost,
    super.key,
  });

  final int balance;
  final int cost;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.roundedFull,
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          end: RedemptionPolicy.progress(balance: balance, cost: cost),
        ),
        duration: AppSpacing.durationSlow,
        builder: (context, value, _) => LinearProgressIndicator(
          value: value,
          minHeight: 8,
          color: context.primaryText,
          backgroundColor: context.primarySoft,
        ),
      ),
    );
  }
}

class _VoucherUnlockedDialog extends StatelessWidget {
  const _VoucherUnlockedDialog({
    required this.reward,
    required this.voucher,
    required this.onSeeVouchers,
  });

  final Reward reward;
  final Voucher voucher;
  final VoidCallback onSeeVouchers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return AlertDialog(
      icon: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.3, end: 1),
        duration: AppSpacing.durationSlow,
        curve: Curves.elasticOut,
        builder: (context, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Icon(
          LucideIcons.partyPopper,
          color: context.primaryText,
          size: AppSpacing.iconXxl,
        ),
      ),
      title: Text(l10n.rewardsSuccessTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          Text(
            reward.nameIn(context),
            textAlign: TextAlign.center,
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
          // Fond blanc : le QR reste lisible en mode sombre.
          Container(
            padding: AppSpacing.insetSm,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: QrImageView(data: voucher.code, size: 160),
          ),
          SelectableText(
            voucher.code,
            style: textTheme.titleLarge!.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            l10n.rewardsSuccessMessage(reward.partnerIn(context)),
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonClose),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onSeeVouchers();
          },
          child: Text(l10n.rewardsSeeVouchers),
        ),
      ],
    );
  }
}
