import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/providers/core_providers.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../auth/presentation/providers/current_user_provider.dart";
import "../../../rewards/presentation/providers/rewards_catalog_provider.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";
import "../widgets/profile_settings_section.dart";
import "../widgets/profile_widgets.dart";

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    final user = ref.watch(currentUserProvider).value;
    final email = ref.watch(firebaseAuthProvider).currentUser?.email ?? "";

    // Solde et kg : users/{uid}. Points en attente : tickets non traités.
    final stats = ref.watch(citizenStatsProvider).value;
    final pointsBalance = ref.watch(pointsBalanceProvider);
    final pendingPoints = stats?.pendingPoints.round() ?? 0;
    final recycledKg = user?.stats.totalKg ?? 0;

    final userStats = <UserStat>[
      (
        value: l10n.profileStatAvailableValue(pointsBalance),
        label: l10n.profileStatAvailableLabel,
      ),
      (
        value: l10n.profileStatPendingValue(pendingPoints),
        label: l10n.profileStatPendingLabel,
      ),
      (
        value: "${Formatters.number(recycledKg)} kg",
        label: l10n.profileStatRecycledLabel,
      ),
    ];

    return AppScaffold(
      scrollable: true,
      appBar: AppBar(elevation: 0, title: Text(l10n.profileTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.xl,
        children: [
          FadeSlideIn(
            child: ProfileHeaderCard(
              name: user?.displayName ?? "",
              subtitle: email,
              subtitleIcon: LucideIcons.mail,
              footer: IntrinsicHeight(
                child: Row(
                  children: [
                    for (int i = 0; i < userStats.length; i++) ...[
                      if (i > 0)
                        VerticalDivider(
                          color: BrandCard.foreground.withValues(alpha: 0.15),
                        ),
                      Expanded(child: _StatCell(stat: userStats[i])),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const FadeSlideIn(index: 1, child: ProfileSettingsSection()),
          const FadeSlideIn(index: 2, child: LogoutButton()),
          AppSpacing.gapVXl,
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.stat});

  final UserStat stat;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Column(
      spacing: AppSpacing.xs,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            stat.value,
            style: textTheme.titleMedium!.copyWith(
              color: AppColors.supernova,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          stat.label,
          textAlign: TextAlign.center,
          style: textTheme.labelMedium!.copyWith(
            color: BrandCard.foregroundMuted,
          ),
        ),
      ],
    );
  }
}

typedef UserStat = ({String value, String label});
