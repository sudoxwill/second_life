import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../views/agent_home.dart";
import "../views/user_home.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserType userType = UserType.user;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: "Bonjour, ",
            style: textTheme.headlineSmall,
            children: [TextSpan(text: "John", style: textTheme.headlineMedium)],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Badge(
              label: Text("1"),
              child: Icon(LucideIcons.bell, size: AppSpacing.iconLg),
            ),
          ),
          AppSpacing.gapHSm,
          // FilledButton(onPressed: () {}, child: Row())
        ],
      ),
      body: switch (userType) {
        UserType.agent => const AgentHome(),
        UserType.user => const UserHome(),
      },
    );
  }
}

enum UserType { agent, user }
