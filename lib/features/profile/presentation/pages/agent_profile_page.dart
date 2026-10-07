import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../ticket_validation/presentation/widgets/relay_agent_builder.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../widgets/profile_settings_section.dart";
import "../widgets/profile_widgets.dart";

class AgentProfilePage extends StatelessWidget {
  const AgentProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RelayAgentBuilder(
      builder: (ctx, agent) => _AgentProfileContent(agent: agent),
    );
  }
}

class _AgentProfileContent extends StatelessWidget {
  const _AgentProfileContent({required this.agent});

  final RelayAgent agent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return AppScaffold(
      scrollable: true,
      appBar: AppBar(elevation: 0, title: Text(l10n.profileTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.xl,
        children: [
          FadeSlideIn(
            child: ProfileHeaderCard(
              name: agent.displayName,
              subtitle: l10n.profileAgentRole,
              subtitleIcon: LucideIcons.badgeCheck,
            ),
          ),
          FadeSlideIn(
            index: 1,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.sm,
                children: [
                  Row(
                    children: [
                      IconTile(
                        icon: LucideIcons.building2,
                        color: context.primaryText,
                        background: context.primarySoft,
                        size: 40,
                      ),
                      AppSpacing.gapHMd,
                      Expanded(
                        child: Text(
                          agent.relayPointName,
                          style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (agent.relayPointDescription != null)
                    _InfoRow(
                      icon: LucideIcons.mapPin,
                      label: agent.relayPointDescription!,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  if (agent.serviceHours != null)
                    _InfoRow(
                      icon: LucideIcons.clock,
                      label: agent.serviceHours!,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
          const FadeSlideIn(index: 2, child: ProfileSettingsSection()),
          const FadeSlideIn(index: 3, child: LogoutButton()),
          AppSpacing.gapVXl,
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
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSpacing.sm,
      children: [
        Icon(icon, size: AppSpacing.iconSm, color: color),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodyMedium!.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
