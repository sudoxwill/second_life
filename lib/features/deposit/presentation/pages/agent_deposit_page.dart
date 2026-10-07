import "package:flutter/widgets.dart";

import "../../../ticket_validation/presentation/pages/pending_deposits_page.dart";
import "../../../ticket_validation/presentation/widgets/relay_agent_builder.dart";

class AgentDepositPage extends StatelessWidget {
  const AgentDepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RelayAgentBuilder(
      builder: (ctx, agent) => PendingDepositsPage(agent: agent),
    );
  }
}
