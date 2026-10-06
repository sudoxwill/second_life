import "package:flutter/material.dart";

import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "agent_dashboard_page.dart";
import "agent_history_page.dart";
import "agent_profile_page.dart";
import "agent_scanner_page.dart";
import "pending_deposits_page.dart";

// Espace de l'agent relais : Tableau, Dépôts, [scan QR], Historique, Profil.
class AgentShell extends StatefulWidget {
  const AgentShell({required this.agent, super.key});
  final RelayAgent agent;

  @override
  State<AgentShell> createState() => _AgentShellState();
}

class _AgentShellState extends State<AgentShell> {
  static const _pendingTab = 1;

  int _index = 0;

  void _scan() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const AgentScannerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      index: _index,
      onIndexChanged: (i) => setState(() => _index = i),
      centerIcon: Icons.qr_code_scanner_rounded,
      centerTooltip: "Scanner un QR de dépôt",
      onCenterPressed: _scan,
      destinations: [
        ShellDestination(
          label: "Tableau",
          icon: Icons.space_dashboard_outlined,
          selectedIcon: Icons.space_dashboard_rounded,
          page: AgentDashboardPage(
            agent: widget.agent,
            onScan: _scan,
            onOpenPending: () => setState(() => _index = _pendingTab),
          ),
        ),
        ShellDestination(
          label: "Dépôts",
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2_rounded,
          page: PendingDepositsPage(agent: widget.agent),
        ),
        ShellDestination(
          label: "Historique",
          icon: Icons.history_rounded,
          selectedIcon: Icons.history_rounded,
          page: AgentHistoryPage(agent: widget.agent),
        ),
        ShellDestination(
          label: "Profil",
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          page: AgentProfilePage(agent: widget.agent),
        ),
      ],
    );
  }
}
