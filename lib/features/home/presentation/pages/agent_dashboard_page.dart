import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../ticket_validation/presentation/providers/current_relay_agent_provider.dart";
import "../views/agent_home.dart";

class AgentDashboardPage extends ConsumerWidget {
  const AgentDashboardPage({super.key});

  static const int demoNotificationCount = 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final displayName =
        ref.watch(currentRelayAgentProvider).value?.displayName ?? "";
    return AppScaffold(
      scrollable: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: l10n.homeGreeting(displayName),
            style: textTheme.headlineMedium,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Badge(
              label: Text("$demoNotificationCount"),
              child: Icon(LucideIcons.bell, size: AppSpacing.iconLg),
            ),
          ),
          AppSpacing.gapHSm,
        ],
      ),
      body: const AgentHome(),
    );
  }
}
