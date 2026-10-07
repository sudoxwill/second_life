import "package:flutter/widgets.dart";

import "../../../../core/extensions/navigation_extension.dart";
import "../../../ticket_validation/presentation/pages/agent_dashboard_page.dart"
    as tv;
import "../../../ticket_validation/presentation/widgets/relay_agent_builder.dart";

class AgentDashboardPage extends StatelessWidget {
  const AgentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RelayAgentBuilder(
      builder: (ctx, agent) => tv.AgentDashboardPage(
        agent: agent,
        onScan: ctx.pushAgentScan,
        onOpenPending: ctx.goAgentDeposits,
      ),
    );
  }
}
