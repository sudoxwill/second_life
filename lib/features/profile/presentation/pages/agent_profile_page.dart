import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../widgets/profile_settings_section.dart";

class AgentProfilePage extends StatelessWidget {
  const AgentProfilePage({super.key});

  static const String _demoAgentName = "Kofi Mensah";
  static const String _demoAgentEmail = "kofi@secondlife.com";
  static const String _demoCenterName = "Centre Bè-Kpota";
  static const String _demoCenterAddress = "Bè-Kpota, Lomé";
  static const bool _demoIsOpen = true;

  static String get _initials {
    final parts = _demoAgentName.trim().split(" ");
    return parts.length >= 2
        ? "${parts[0][0]}${parts[1][0]}".toUpperCase()
        : parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return AppScaffold(
      scrollable: true,
      appBar: AppBar(elevation: 0, title: Text(l10n.profileTitle)),
      body: Column(
        spacing: AppSpacing.lg,
        children: [
          // Carte de profil
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
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  CircleAvatar(
                    radius: AppSpacing.mega,
                    backgroundColor: colorScheme.secondary,
                    child: Text(
                      _initials,
                      style: textTheme.titleLarge!.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _demoAgentName,
                          style: textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutral50,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.profileAgentRole,
                          style: textTheme.bodyMedium!.copyWith(
                            color: AppColors.neutral50.withValues(alpha: 0.75),
                          ),
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
                                _demoAgentEmail,
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
            ),
          ),

          // Centre de dépôts
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: AppSpacing.insetMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: AppSpacing.insetSm,
                        decoration: const BoxDecoration(
                          color: AppColors.primarySubtle,
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: const Icon(
                          LucideIcons.building2,
                          size: AppSpacing.iconMd,
                          color: AppColors.primary,
                        ),
                      ),
                      AppSpacing.gapHMd,
                      Expanded(
                        child: Text(
                          _demoCenterName,
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: const BoxDecoration(
                          color: _demoIsOpen
                              ? AppColors.semanticSuccessBg
                              : AppColors.semanticErrorBg,
                          borderRadius: AppSpacing.roundedFull,
                        ),
                        child: Text(
                          _demoIsOpen
                              ? l10n.profileStatusOpen
                              : l10n.profileStatusClosed,
                          style: textTheme.labelSmall!.copyWith(
                            color: _demoIsOpen
                                ? AppColors.semanticSuccess
                                : AppColors.semanticError,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _InfoRow(
                    icon: LucideIcons.mapPin,
                    label: _demoCenterAddress,
                    color: colorScheme.onSurfaceVariant,
                    textTheme: textTheme,
                  ),
                  _InfoRow(
                    icon: LucideIcons.clock,
                    label: l10n.profileCenterHours,
                    color: colorScheme.onSurfaceVariant,
                    textTheme: textTheme,
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final Color color;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      children: [
        Icon(icon, size: AppSpacing.iconSm, color: color),
        Text(label, style: textTheme.bodyMedium!.copyWith(color: color)),
      ],
    );
  }
}
