import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../views/user_home.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String demoUserName = "John";
  static const int demoNotificationCount = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            text: l10n.homeGreeting(demoUserName),
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
      body: const UserHome(),
    );
  }
}
