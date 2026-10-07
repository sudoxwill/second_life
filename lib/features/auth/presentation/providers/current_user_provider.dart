import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";
import "../../data/models/app_user_model.dart";
import "../../domain/entities/app_user.dart";
import "auth_provider.dart";

part "current_user_provider.g.dart";

@Riverpod(keepAlive: true)
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  Future<AppUser?> build() async {
    final role = ref.watch(authProvider);
    if (role != AppRole.user) return null;

    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (uid == null) return null;

    final doc = await ref
        .read(firebaseFirestoreProvider)
        .collection("users")
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return AppUserModel.fromFirestore(doc.data()!, uid);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
