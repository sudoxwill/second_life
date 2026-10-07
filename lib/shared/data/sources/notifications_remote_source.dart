import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../core/constants/firestore_paths.dart";
import "../../../core/errors/exception.dart";
import "../models/app_notification_model.dart";

// users/{uid}/notifications/{id}
abstract class NotificationsRemoteSource {
  Stream<List<AppNotificationModel>> watchMine();
  Future<void> markRead(String id);
  Future<void> markAllRead(Iterable<String> ids);

  // Utilisé par la validation des dépôts et l'échange de points, qui
  // notifient l'usager concerné.
  Future<void> notify(
    String userId, {
    required String type,
    Map<String, dynamic> data,
  });
}

class NotificationsRemoteSourceImpl implements NotificationsRemoteSource {
  new(this.firestore, this.firebaseAuth);
  static const pageSize = 50;

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  CollectionReference<Map<String, dynamic>> _collection(String uid) => firestore
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.notifications);

  String _currentUserId() {
    final user = firebaseAuth.currentUser;
    if (user == null) throw UnauthenticatedException();
    return user.uid;
  }

  @override
  Stream<List<AppNotificationModel>> watchMine() {
    return _collection(_currentUserId())
        .orderBy("createdAt", descending: true)
        .limit(pageSize)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs)
              AppNotificationModel.fromFirestore(doc.id, doc.data()),
          ],
        );
  }

  @override
  Future<void> markRead(String id) =>
      _collection(_currentUserId()).doc(id).update({"read": true});

  @override
  Future<void> markAllRead(Iterable<String> ids) {
    final collection = _collection(_currentUserId());
    final batch = firestore.batch();
    for (final id in ids) {
      batch.update(collection.doc(id), {"read": true});
    }
    return batch.commit();
  }

  @override
  Future<void> notify(
    String userId, {
    required String type,
    Map<String, dynamic> data = const {},
  }) {
    return _collection(userId).add({
      "type": type,
      "data": data,
      "read": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
