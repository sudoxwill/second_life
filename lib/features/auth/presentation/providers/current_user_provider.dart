import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";
import "../../data/datasources/auth_datasource.dart";
import "../../domain/entities/app_user.dart";
import "auth_provider.dart";

part "current_user_provider.g.dart";

// Profil de l'usager connecté (null pour un agent ou hors connexion).
@Riverpod(keepAlive: true)
Stream<AppUser?> currentUser(Ref ref) {
  if (ref.watch(authProvider) != AppRole.user) return Stream.value(null);

  final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
  if (uid == null) return Stream.value(null);

  return ref.watch(authDatasourceProvider).watchUser(uid);
}
