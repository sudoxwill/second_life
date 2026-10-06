import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/settings_card.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";

// Onglet "Profil" de l'agent.
class AgentProfilePage extends StatelessWidget {
  const AgentProfilePage({required this.agent, super.key});
  static const _missions = [
    // ignore: no_adjacent_strings_in_list
    "Contrôler la pureté et la conformité des déchets déposés "
        "(sans salissures).",
    "Effectuer la pesée réelle sur la balance homologuée du point.",
    // ignore: no_adjacent_strings_in_list
    "Scanner le QR du déposant pour certifier l’attribution des points "
        "citoyens.",
    "Alerter lors de l’atteinte des 200 kg pour enlèvement municipal.",
  ];

  final RelayAgent agent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
      children: [
        AppCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 68,
                height: 68,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  Formatters.initials(agent.displayName),
                  style: AppTextStyles.heading(24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(agent.displayName, style: AppTextStyles.heading(20)),
                    const SizedBox(height: 6),
                    Pill(
                      label: "Agent Relais Officiel",
                      color: context.primaryText,
                      background: context.primarySoft,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconTile(
                    icon: Icons.apartment_rounded,
                    color: context.primaryText,
                    background: context.primarySoft,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Point relais d’affectation",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          agent.relayPointName,
                          style: TextStyle(
                            color: context.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (agent.serviceHours != null ||
                  agent.relayPointDescription != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (agent.serviceHours != null)
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 18,
                              color: context.primaryText,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Horaires de permanence : ",
                                    ),
                                    TextSpan(
                                      text: agent.serviceHours,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      if (agent.relayPointDescription != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          agent.relayPointDescription!,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel("Missions de l’agent relais"),
              const SizedBox(height: 12),
              for (final mission in _missions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: context.primaryText,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          mission,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SettingsCard(),
      ],
    );
  }
}
