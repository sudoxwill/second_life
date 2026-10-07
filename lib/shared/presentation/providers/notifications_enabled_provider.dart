import "package:cloud_firestore/cloud_firestore.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/configs/logger.dart";
import "../../../core/constants/app_keys.dart";
import "../../data/sources/user_settings_remote_source.dart";
import "core_providers.dart";
import "local_storage_provider.dart";
import "notification_provider.dart";

part "notifications_enabled_provider.g.dart";

// Préférence "Notifications" du profil. Gardée sur l'appareil, et recopiée
// dans users/{uid}.notificationsEnabled pour que le serveur la respecte.
@Riverpod(keepAlive: true)
class AppNotificationsEnabled extends _$AppNotificationsEnabled {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(AppKeys.notificationsEnabled) ?? true;
  }

  /// Renvoie false si la permission système est refusée ou si
  /// l'enregistrement en ligne échoue ; l'état n'est alors pas modifié.
  Future<bool> setEnabled(bool enabled) async {
    final service = ref.read(notificationServiceProvider);
    if (enabled && !await service.requestPermission()) return false;

    try {
      await ref
          .read(userSettingsRemoteSourceProvider)
          .setNotificationsEnabled(enabled);
    } on FirebaseException catch (e) {
      Log.e("Préférence notifications non enregistrée", error: e);
      return false;
    }

    await ref
        .read(sharedPreferencesProvider)
        .setBool(AppKeys.notificationsEnabled, enabled);
    state = enabled;
    if (!enabled) await service.cancelAll();
    return true;
  }
}

@Riverpod(keepAlive: true)
UserSettingsRemoteSource userSettingsRemoteSource(Ref ref) =>
    UserSettingsRemoteSourceImpl(
      ref.watch(firebaseFirestoreProvider),
      ref.watch(firebaseAuthProvider),
    );
