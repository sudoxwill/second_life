import "package:firebase_auth/firebase_auth.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/constants/app_keys.dart";
import "../../../../core/errors/exception.dart";
import "../../../../shared/presentation/providers/core_providers.dart";
import "../../../../shared/presentation/providers/local_storage_provider.dart";
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
    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return null;
    // Rôle mémorisé à la dernière session : l'accueil s'ouvre sans attendre
    // le réseau. La vérification continue en arrière-plan et corrige le
    // rôle (ou déconnecte) si besoin.
    _verifySession(user);
    return _cachedRole(user.uid);
  }

  Future<void> _verifySession(User user) async {
    final auth = ref.read(firebaseAuthProvider);
    try {
      await user.reload();
    } on FirebaseAuthException catch (e) {
      // Hors ligne : on garde le rôle mémorisé.
      if (e.code == "network-request-failed") return;
      // Compte supprimé ou désactivé côté Firebase.
      await auth.signOut();
      _setRole(null);
      return;
    }
    final role = await _resolveRole(user.uid);
    if (ref.mounted && role != state) _setRole(role);
  }

  Future<AppRole> _resolveRole(String uid) async {
    final ds = ref.read(authDatasourceProvider);
    // Les deux lectures en parallèle : un aller-retour réseau au lieu de deux.
    final (isAgent, hasProfile) = await (
      ds.isAgent(uid),
      ds.hasUserProfile(uid),
    ).wait;
    if (isAgent) return AppRole.agent;
    if (hasProfile) return AppRole.user;
    return AppRole.pendingUsername;
  }

  // ── Rôle mémorisé ("uid|role") ─────────────────────────────

  AppRole? _cachedRole(String uid) {
    final cached = ref
        .read(sharedPreferencesProvider)
        .getString(AppKeys.cachedAuthRole);
    final parts = cached?.split("|");
    if (parts == null || parts.length != 2 || parts.first != uid) return null;
    return AppRole.values.asNameMap()[parts.last];
  }

  void _setRole(AppRole? role) {
    state = role;
    final prefs = ref.read(sharedPreferencesProvider);
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (role == null || uid == null) {
      prefs.remove(AppKeys.cachedAuthRole);
    } else {
      prefs.setString(AppKeys.cachedAuthRole, "$uid|${role.name}");
    }
  }

  // ── Actions ────────────────────────────────────────────────

  Future<AppRole> signInWithEmailPassword(String email, String password) async {
    final uid = await ref
        .read(authDatasourceProvider)
        .signInWithEmailPassword(email, password);
    final role = await _resolveRole(uid);
    _setRole(role);
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
    _setRole(AppRole.user);
    return AppRole.user;
  }

  Future<AppRole> signInWithGoogle() async {
    final uid = await ref.read(authDatasourceProvider).signInWithGoogle();
    if (uid == null) throw const SignInCancelledException();
    final role = await _resolveRole(uid);
    _setRole(role);
    return role;
  }

  Future<AppRole> saveUsername(String username) async {
    final ds = ref.read(authDatasourceProvider);
    final available = await ds.isUsernameAvailable(username);
    if (!available) throw const UsernameTakenException();
    final currentUser = ref.read(firebaseAuthProvider).currentUser!;
    await ds.saveUser(currentUser.uid, username);
    _setRole(AppRole.user);
    return AppRole.user;
  }

  Future<void> sendPasswordResetEmail(String email) =>
      ref.read(authDatasourceProvider).sendPasswordResetEmail(email);

  Future<void> signOut() async {
    await ref.read(authDatasourceProvider).signOut();
    _setRole(null);
  }
}
