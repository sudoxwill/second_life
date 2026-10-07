import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../core/constants/firestore_paths.dart";

// Réglages du compte stockés dans users/{uid}, lus par le serveur.
abstract class UserSettingsRemoteSource {
  Future<void> setNotificationsEnabled(bool enabled);
}

class UserSettingsRemoteSourceImpl implements UserSettingsRemoteSource {
  new(this.firestore, this.firebaseAuth);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null) return;
    try {
      await firestore.collection(FirestorePaths.users).doc(uid).update({
        "notificationsEnabled": enabled,
      });
    } on FirebaseException catch (e) {
      // Les agents n'ont pas de document users : réglage local seulement.
      if (e.code != "not-found") rethrow;
    }
  }
}
