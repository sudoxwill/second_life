import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../views/agent_home.dart";

class AgentDashboardPage extends StatelessWidget {
  const AgentDashboardPage({super.key});

  static const int demoNotificationCount = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return AppScaffold(
      scrollable: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: l10n.homeGreeting(l10n.homeAgentRoleLabel),
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
