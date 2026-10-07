import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/routing/app_routes.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/localized_field.dart";
import "../../../../shared/domain/entities/app_notification.dart";
import "../../../../shared/presentation/providers/in_app_notifications_providers.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/widgets/ticket_widgets.dart";

// Cloche des barres d'accueil, avec le nombre de notifications non lues.
class NotificationsButton extends ConsumerWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationsCountProvider);
    return IconButton(
      tooltip: context.l10n.notificationsTitle,
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => const _NotificationsSheet(),
      ),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text("$unread"),
        child: Icon(
          unread > 0 ? LucideIcons.bellRing : LucideIcons.bell,
          size: AppSpacing.iconLg,
        ),
      ),
    );
  }
}

class _NotificationsSheet extends ConsumerWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final notifications = ref.watch(appNotificationsProvider).value ?? [];
    final unread = [
      for (final n in notifications)
        if (!n.read) n.id,
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: AppSpacing.screenPaddingH,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.notificationsTitle,
                    style: context.textTheme.titleLarge,
                  ),
                ),
                if (unread.isNotEmpty)
                  Flexible(
                    child: TextButton.icon(
                      onPressed: () =>
                          ref.read(markAllNotificationsReadProvider)(unread),
                      icon: const Icon(LucideIcons.checkCheck, size: 18),
                      label: Text(
                        l10n.notificationsMarkAllRead,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: notifications.isEmpty
                ? EmptyState(
                    icon: LucideIcons.bellOff,
                    title: l10n.notificationsEmptyTitle,
                    message: l10n.notificationsEmptyMessage,
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    itemCount: notifications.length,
                    separatorBuilder: (_, _) => AppSpacing.gapVSm,
                    itemBuilder: (context, i) => _NotificationTile(
                      notification: notifications[i],
                      onTap: () {
                        final n = notifications[i];
                        if (!n.read) {
                          ref.read(markNotificationReadProvider)(n.id);
                        }
                        final route = _routeFor(n);
                        if (route == null) return;
                        Navigator.pop(context);
                        GoRouter.of(context).go(route);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  static String? _routeFor(AppNotification n) => switch (n.type) {
    AppNotificationType.depositValidated ||
    AppNotificationType.depositRejected => "${AppRoutes.history}?tab=processed",
    AppNotificationType.voucherRedeemed => "${AppRoutes.history}?tab=gift",
    AppNotificationType.welcome => AppRoutes.rewards,
    AppNotificationType.unknown => null,
  };
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final data = notification.data;
    final points = (data["points"] as num?)?.round() ?? 0;
    final item = data["itemLabel"] as String? ?? "";

    final (icon, color, soft, title, body) = switch (notification.type) {
      AppNotificationType.welcome => (
        LucideIcons.partyPopper,
        context.primaryText,
        context.primarySoft,
        l10n.notifWelcomeTitle,
        l10n.notifWelcomeBody(points),
      ),
      AppNotificationType.depositValidated => (
        LucideIcons.circleCheck,
        context.primaryText,
        context.primarySoft,
        l10n.notifValidatedTitle,
        l10n.notifValidatedBody(points, item),
      ),
      AppNotificationType.depositRejected => (
        LucideIcons.circleX,
        context.danger,
        context.dangerSoft,
        l10n.notifRejectedTitle,
        l10n.notifRejectedBody(
          item,
          RejectionReason.values.asNameMap()[data["reason"] as String?]?.label(
                l10n,
              ) ??
              l10n.rejectionOther,
        ),
      ),
      AppNotificationType.voucherRedeemed => (
        LucideIcons.gift,
        context.warning,
        context.warningSoft,
        l10n.notifVoucherTitle,
        l10n.notifVoucherBody(
          localizedField(data["rewardName"], l10n.localeName),
        ),
      ),
      AppNotificationType.unknown => (
        LucideIcons.bell,
        scheme.onSurfaceVariant,
        scheme.surfaceContainerHighest,
        l10n.notifUnknown,
        "",
      ),
    };

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.listItemPaddingSm,
      color: notification.read ? null : soft.withValues(alpha: 0.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon: icon, color: color, background: soft, size: 40),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall!.copyWith(
                    fontWeight: notification.read
                        ? FontWeight.w600
                        : FontWeight.w800,
                  ),
                ),
                if (body.isNotEmpty)
                  Text(
                    body,
                    style: textTheme.bodySmall!.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                Text(
                  _relativeTime(context, notification.createdAt),
                  style: textTheme.labelSmall!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!notification.read)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }

  static String _relativeTime(BuildContext context, DateTime date) {
    final l10n = context.l10n;
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inHours < 1) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.timeHoursAgo(diff.inHours);
    return context.formatDate(date);
  }
}
