import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/services/notification_service.dart";
import "notifications_enabled_provider.dart";

part "notification_provider.g.dart";

/// Fourni par main() dans les overrides, comme sharedPreferencesProvider.
@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(Ref ref) {
  throw UnimplementedError(
    "Overrider flutterLocalNotificationsPluginProvider dans main() "
    "après NotificationService.createAndInit()",
  );
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService(
    ref.watch(flutterLocalNotificationsPluginProvider),
    isEnabled: () => ref.read(appNotificationsEnabledProvider),
  );
}
