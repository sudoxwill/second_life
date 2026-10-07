import "package:flutter/widgets.dart";

import "../../../ticket_validation/presentation/pages/agent_history_page.dart"
    as tv;
import "../../../ticket_validation/presentation/widgets/relay_agent_builder.dart";

class AgentHistoryPage extends StatelessWidget {
  const AgentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RelayAgentBuilder(
      builder: (ctx, agent) => tv.AgentHistoryPage(agent: agent),
    );
  }
}
