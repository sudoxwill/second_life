import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";
import "../widgets/profile_settings_section.dart";

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  // Données de démo, à remplacer par celles du provider auth.
  static const String _demoUsername = "Ama Kwatcha";
  static const String _demoEmail = "ama@secondlife.com";
  static const String _demoLocation = "Bè-Kpota";
  static const int _demoAvailablePoints = 1250;
  static const int _demoPendingPoints = 80;
  static const double _demoRecycledKg = 18.4;

  String get _initials {
    final parts = _demoUsername.trim().split(" ");
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final userStats = <UserStat>[
      (
        value: l10n.profileStatAvailableValue(_demoAvailablePoints),
        label: l10n.profileStatAvailableLabel,
      ),
      (
        value: l10n.profileStatPendingValue(_demoPendingPoints),
        label: l10n.profileStatPendingLabel,
      ),
      (
        value: l10n.profileStatRecycledValue(_demoRecycledKg),
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
                          _initials,
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
                              _demoUsername,
                              style: textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.neutral50,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
                                    _demoEmail,
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
                            Row(
                              spacing: AppSpacing.sm,
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  size: AppSpacing.iconSm,
                                  color: AppColors.neutral50.withValues(
                                    alpha: 0.75,
                                  ),
                                ),
                                Text(
                                  _demoLocation,
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: AppColors.neutral50.withValues(
                                      alpha: 0.75,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
            onPressed: () {},
            text: l10n.authLogout,
            icon: const Icon(LucideIcons.logOut500, size: AppSpacing.iconMd),
            backgroundColor: colorScheme.error,
          ),
          AppSpacing.gapVMd,
        ],
      ),
    );
  }
}

typedef UserStat = ({String value, String label});
