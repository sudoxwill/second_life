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

  Future<String> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!.uid;
  }

  Future<String> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user!.uid;
  }

  /// Retourne null si l'utilisateur a annulé, sinon l'uid Firebase.
  Future<String?> signInWithGoogle() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return null;
    final authentication = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    return result.user?.uid;
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isAgent(String uid) async {
    try {
      final doc = await _firestore.collection("relay_agents").doc(uid).get();
      return doc.exists;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> hasUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();
      final displayName = doc.data()?["displayName"] as String?;
      return doc.exists && (displayName?.isNotEmpty ?? false);
    } on FirebaseException {
      return false;
    }
  }

  // Le client écrit uniquement les champs qu'il possède.
  // role, createdAt, pointsBalance, stats, etc. sont écrits par Functions.
  Future<void> saveUser(String uid, String displayName) async {
    final batch = _firestore.batch()
      ..set(
        _firestore.collection("users").doc(uid),
        {"displayName": displayName, "notificationsEnabled": true},
        SetOptions(merge: true),
      )
      // Index d'unicité pour le displayName
      ..set(
        _firestore.collection("usernames").doc(displayName),
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
