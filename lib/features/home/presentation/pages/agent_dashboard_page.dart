import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/greeting_header.dart";
import "../../../notifications/presentation/widgets/notifications_button.dart";
import "../../../ticket_validation/presentation/providers/agent_history_provider.dart";
import "../../../ticket_validation/presentation/providers/current_relay_agent_provider.dart";
import "../../../ticket_validation/presentation/providers/pending_tickets_provider.dart";
import "../views/agent_home.dart";

class AgentDashboardPage extends ConsumerWidget {
  const AgentDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName =
        ref.watch(currentRelayAgentProvider).value?.displayName ?? "";
    return AppScaffold(
      onRefresh: () => Future.wait([
        ref.read(agentHistoryProvider.notifier).refresh(),
        ref.read(pendingTicketsProvider.notifier).refresh(),
      ]),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        titleSpacing: AppSpacing.lg,
        title: GreetingHeader(
          name: displayName,
          onAvatarTap: context.goAgentProfile,
        ),
        actions: const [NotificationsButton(), AppSpacing.gapHSm],
      ),
      body: const AgentHome(),
    );
  }
}
