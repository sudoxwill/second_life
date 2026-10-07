import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";

part "auth_datasource.g.dart";

@Riverpod(keepAlive: true)
AuthDatasource authDatasource(Ref ref) => AuthDatasource(
  auth: ref.watch(firebaseAuthProvider),
  firestore: ref.watch(firebaseFirestoreProvider),
  googleSignIn: ref.watch(googleSignInProvider),
);

class AuthDatasource {
  const AuthDatasource({
    required this._auth,
    required this._firestore,
    required this._googleSignIn,
  });

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  Future<void> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Retourne true si l'utilisateur a annulé.
  Future<bool> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return true;
    final authentication = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    await _auth.signInWithCredential(credential);
    return false;
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isAgent(String uid) async {
    final doc = await _firestore.collection("relay_agents").doc(uid).get();
    return doc.exists;
  }

  Future<bool> hasUserProfile(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    final username = doc.data()?["username"] as String?;
    return doc.exists && (username?.isNotEmpty ?? false);
  }

  Future<void> saveUser(String uid, String email, String username) async {
    final batch = _firestore.batch()
      ..set(_firestore.collection("users").doc(uid), {
        "uid": uid,
        "email": email,
        "username": username,
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),
      })
      // Index d'unicité : permet de vérifier la disponibilité d'un username
      ..set(
        _firestore.collection("usernames").doc(username),
        {"uid": uid},
      );
    await batch.commit();
  }

  Future<bool> isUsernameAvailable(String username) async {
    final doc =
        await _firestore.collection("usernames").doc(username).get();
    return !doc.exists;
  }
}
