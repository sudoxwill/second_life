import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/providers/core_providers.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";
import "../../../auth/presentation/providers/auth_provider.dart";
import "../../../auth/presentation/providers/current_user_provider.dart";
import "../widgets/profile_settings_section.dart";

Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.authLogoutConfirmTitle),
      content: Text(l10n.authLogoutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            l10n.authLogoutButton,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await ref.read(authProvider.notifier).signOut();
  if (!context.mounted) return;
  context.goAuthLogin();
}

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final user = ref.watch(currentUserProvider).value;
    final email =
        ref.watch(firebaseAuthProvider).currentUser?.email ?? "";

    final displayName = user?.displayName ?? "";
    final pointsBalance = user?.pointsBalance ?? 0;
    final pendingPoints = user?.pendingPoints ?? 0;
    final totalKg = user?.stats.totalKg ?? 0.0;

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
        value: l10n.profileStatRecycledValue(totalKg),
        label: l10n.profileStatRecycledLabel,
      ),
    ];

    return AppScaffold(
      scrollable: true,
      appBar: AppBar(elevation: 0, title: Text(l10n.profileTitle)),
      body: Column(
        spacing: AppSpacing.lg,
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedLg,
            ),
            child: Container(
              padding: AppSpacing.insetMd,
              decoration: const BoxDecoration(
                borderRadius: AppSpacing.roundedLg,
                gradient: LinearGradient(
                  colors: [AppColors.grassCourt, AppColors.jungleGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    spacing: AppSpacing.md,
                    children: [
                      CircleAvatar(
                        radius: AppSpacing.mega,
                        backgroundColor: AppColors.accent,
                        child: Text(
                          Formatters.initials(displayName),
                          style: textTheme.titleLarge!.copyWith(
                            color: AppColors.onAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral50,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (email.isNotEmpty)
                              Row(
                                spacing: AppSpacing.sm,
                                children: [
                                  Icon(
                                    LucideIcons.mail,
                                    size: AppSpacing.iconSm,
                                    color: AppColors.neutral50.withValues(
                                      alpha: 0.75,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      email,
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: AppColors.neutral50.withValues(
                                          alpha: 0.75,
                                        ),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppDivider(color: colorScheme.outline),
                  SizedBox(
                    height: AppSpacing.giga,
                    child: Row(
                      children: [
                        for (int i = 0; i < userStats.length; i++) ...[
                          if (i > 0)
                            VerticalDivider(color: colorScheme.outline),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userStats[i].value,
                                  style: textTheme.titleMedium!.copyWith(
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  userStats[i].label,
                                  style: textTheme.labelMedium!.copyWith(
                                    color: AppColors.neutral50.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ProfileSettingsSection(),
          AppSpacing.gapVLg,
          AppElevatedButton(
            onPressed: () => _confirmLogout(context, ref),
            text: l10n.authLogout,
            icon: const Icon(LucideIcons.logOut, size: AppSpacing.iconMd),
            backgroundColor: colorScheme.error,
          ),
          AppSpacing.gapVMd,
        ],
      ),
    );
  }
}

typedef UserStat = ({String value, String label});
