import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/services/notification_service.dart";

part "notification_provider.g.dart";

/// Plugin brut injecté depuis main() via ProviderScope.overrides,
/// exactement comme sharedPreferencesProvider.
@Riverpod(keepAlive: true)
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin(Ref ref) {
  throw UnimplementedError(
    "Overrider flutterLocalNotificationsPluginProvider dans main() "
    "après NotificationService.createAndInit()",
  );
}

/// Facade du service de notifications, construite synchronement
/// à partir du plugin pré-initialisé.
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService(
    ref.watch(flutterLocalNotificationsPluginProvider),
  );
}
