import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/greeting_header.dart";
import "../../../auth/presentation/providers/current_user_provider.dart";
import "../../../notifications/presentation/widgets/notifications_button.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";
import "../views/user_home.dart";

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = ref.watch(currentUserProvider).value?.displayName ?? "";
    return AppScaffold(
      onRefresh: ref.read(userTicketsProvider.notifier).refresh,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 72,
        titleSpacing: AppSpacing.lg,
        title: GreetingHeader(
          name: displayName,
          onAvatarTap: context.goProfile,
        ),
        actions: const [NotificationsButton(), AppSpacing.gapHSm],
      ),
      body: const UserHome(),
    );
  }
}
