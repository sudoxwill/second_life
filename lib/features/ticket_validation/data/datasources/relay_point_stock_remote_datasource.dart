import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../../core/constants/firestore_paths.dart";
import "../../../../core/errors/exception.dart";
import "../../../../core/errors/exceptions_mapper.dart";
import "../models/relay_point_stock_model.dart";

// relay_point_stocks/{relayPointId}
abstract class RelayPointStockRemoteDatasource {
  Stream<RelayPointStockModel> watch(String relayPointId);
  Future<void> addWeight(String relayPointId, double grams);
  Future<void> markBatchCollected(String relayPointId);
}

class RelayPointStockRemoteDatasourceImpl
    implements RelayPointStockRemoteDatasource {
  new(this.firestore, this.firebaseAuth);
  static const writeTimeout = Duration(seconds: 15);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  DocumentReference<Map<String, dynamic>> _doc(String relayPointId) =>
      firestore.collection(FirestorePaths.relayPointStocks).doc(relayPointId);

  @override
  Stream<RelayPointStockModel> watch(String relayPointId) =>
      _doc(relayPointId)
          .snapshots()
          .map((s) => RelayPointStockModel.fromFirestore(s.data()));

  @override
  Future<void> addWeight(String relayPointId, double grams) =>
      _doc(relayPointId).set({
        "currentBatchGrams": FieldValue.increment(grams),
        "totalCollectedGrams": FieldValue.increment(grams),
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

  @override
  Future<void> markBatchCollected(String relayPointId) async {
    final agentId = firebaseAuth.currentUser?.uid;
    if (agentId == null) throw UnauthenticatedException();
    try {
      await _doc(relayPointId)
          .set({
            "currentBatchGrams": 0,
            "lastPickupAt": FieldValue.serverTimestamp(),
            "lastPickupBy": agentId,
            "pickupsCount": FieldValue.increment(1),
            "updatedAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true))
          .timeout(writeTimeout);
    } on FirebaseException catch (e) {
      throw firebaseExceptionMapper(e);
    } on TimeoutException {
      throw NetworkException();
    }
  }
}
