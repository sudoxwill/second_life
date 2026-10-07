import "package:firebase_auth/firebase_auth.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/errors/exception.dart";
import "../../../../shared/presentation/providers/core_providers.dart";
import "../../data/datasources/auth_datasource.dart";

part "auth_provider.g.dart";

enum AppRole { user, agent, pendingUsername }

/// null  = non authentifié / en cours de restauration
/// user  = utilisateur connecté avec profil complet
/// agent = agent relais connecté
/// pendingUsername = connecté mais username pas encore choisi (OAuth)
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AppRole? build() {
    _tryRestoreSession();
    return null;
  }

  Future<void> _tryRestoreSession() async {
    final auth = ref.read(firebaseAuthProvider);
    final user = auth.currentUser;
    if (user == null) return;
    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") return;
      await auth.signOut();
      return;
    }
    final role = await _resolveRole(user.uid);
    if (ref.mounted) state = role;
  }

  Future<AppRole> _resolveRole(String uid) async {
    final ds = ref.read(authDatasourceProvider);
    if (await ds.isAgent(uid)) return AppRole.agent;
    if (await ds.hasUserProfile(uid)) return AppRole.user;
    return AppRole.pendingUsername;
  }

  Future<AppRole> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final uid = await ref
        .read(authDatasourceProvider)
        .signInWithEmailPassword(email, password);
    final role = await _resolveRole(uid);
    state = role;
    return role;
  }

  Future<AppRole> signUpWithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    final ds = ref.read(authDatasourceProvider);
    final available = await ds.isUsernameAvailable(username);
    if (!available) throw const UsernameTakenException();
    final uid = await ds.signUpWithEmailPassword(email, password);
    await ds.saveUser(uid, username);
    state = AppRole.user;
    return AppRole.user;
  }

  Future<AppRole> signInWithGoogle() async {
    final uid = await ref.read(authDatasourceProvider).signInWithGoogle();
    if (uid == null) throw const SignInCancelledException();
    final role = await _resolveRole(uid);
    state = role;
    return role;
  }

  Future<AppRole> saveUsername(String username) async {
    final ds = ref.read(authDatasourceProvider);
    final available = await ds.isUsernameAvailable(username);
    if (!available) throw const UsernameTakenException();
    final currentUser = ref.read(firebaseAuthProvider).currentUser!;
    await ds.saveUser(currentUser.uid, username);
    state = AppRole.user;
    return AppRole.user;
  }

  Future<void> signOut() async {
    await ref.read(authDatasourceProvider).signOut();
    state = null;
  }
}
