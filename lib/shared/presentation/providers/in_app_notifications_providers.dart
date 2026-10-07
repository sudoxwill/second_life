import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/repositories/notifications_repository_impl.dart";
import "../../data/sources/notifications_remote_source.dart";
import "../../domain/entities/app_notification.dart";
import "../../domain/repositories/notifications_repository.dart";
import "../../domain/usecases/mark_all_notifications_read.dart";
import "../../domain/usecases/mark_notification_read.dart";
import "../../domain/usecases/usecase.dart";
import "../../domain/usecases/watch_notifications.dart";
import "core_providers.dart";

part "in_app_notifications_providers.g.dart";

// ── Dépendances ─────────────────────────────────────────────

@Riverpod(keepAlive: true)
NotificationsRemoteSource notificationsRemoteSource(Ref ref) =>
    NotificationsRemoteSourceImpl(
      ref.watch(firebaseFirestoreProvider),
      ref.watch(firebaseAuthProvider),
    );

@Riverpod(keepAlive: true)
NotificationsRepository notificationsRepository(Ref ref) =>
    NotificationsRepositoryImpl(ref.watch(notificationsRemoteSourceProvider));

@Riverpod(keepAlive: true)
WatchNotifications watchNotifications(Ref ref) =>
    WatchNotifications(ref.watch(notificationsRepositoryProvider));

@Riverpod(keepAlive: true)
MarkNotificationRead markNotificationRead(Ref ref) =>
    MarkNotificationRead(ref.watch(notificationsRepositoryProvider));

@Riverpod(keepAlive: true)
MarkAllNotificationsRead markAllNotificationsRead(Ref ref) =>
    MarkAllNotificationsRead(ref.watch(notificationsRepositoryProvider));

// ── État ────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
Stream<List<AppNotification>> appNotifications(Ref ref) {
  if (ref.watch(firebaseUserProvider).value == null) {
    return Stream.value(const []);
  }
  return ref.watch(watchNotificationsProvider)(NoParam());
}

@riverpod
int unreadNotificationsCount(Ref ref) =>
    ref.watch(appNotificationsProvider).value?.where((n) => !n.read).length ??
    0;
