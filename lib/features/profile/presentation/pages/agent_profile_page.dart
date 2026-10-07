import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../auth/presentation/providers/auth_provider.dart";
import "../../../ticket_validation/presentation/widgets/relay_agent_builder.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../widgets/profile_settings_section.dart";

class AgentProfilePage extends ConsumerWidget {
  const AgentProfilePage({super.key});

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
    if (confirmed != true) return;
    await ref.read(authProvider.notifier).signOut();
    if (!context.mounted) return;
    context.goAuthLogin();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RelayAgentBuilder(
      builder: (ctx, agent) => _AgentProfileContent(
        agent: agent,
        onLogout: () => _confirmLogout(ctx, ref),
      ),
    );
  }
}

class _AgentProfileContent extends StatelessWidget {
  const _AgentProfileContent({
    required this.agent,
    required this.onLogout,
  });

  final RelayAgent agent;
  final VoidCallback onLogout;

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
                      Formatters.initials(agent.displayName),
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
                          agent.displayName,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                          agent.relayPointName,
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (agent.relayPointDescription != null)
                    _InfoRow(
                      icon: LucideIcons.mapPin,
                      label: agent.relayPointDescription!,
                      color: colorScheme.onSurfaceVariant,
                      textTheme: textTheme,
                    ),
                  if (agent.serviceHours != null)
                    _InfoRow(
                      icon: LucideIcons.clock,
                      label: agent.serviceHours!,
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
            onPressed: onLogout,
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
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium!.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
