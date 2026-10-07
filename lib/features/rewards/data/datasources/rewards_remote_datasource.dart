import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../../core/configs/logger.dart";
import "../../../../core/constants/firestore_paths.dart";
import "../../../../core/errors/exception.dart";
import "../../../../core/errors/exceptions_mapper.dart";
import "../../../../shared/data/sources/notifications_remote_source.dart";
import "../../domain/entities/reward.dart";
import "../../domain/redemption_policy.dart";
import "../models/reward_model.dart";
import "../models/voucher_model.dart";

abstract class RewardsRemoteDatasource {
  Stream<List<RewardModel>> watchCatalog();
  Stream<List<VoucherModel>> watchMyVouchers();
  Future<VoucherModel> redeem(Reward reward);
}

class RewardsRemoteDatasourceImpl implements RewardsRemoteDatasource {
  new(this.firestore, this.firebaseAuth, this.notifications);
  static const writeTimeout = Duration(seconds: 15);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final NotificationsRemoteSource notifications;

  CollectionReference<Map<String, dynamic>> get _rewards =>
      firestore.collection(FirestorePaths.rewards);

  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      firestore.collection(FirestorePaths.users).doc(uid);

  String _currentUserId() {
    final user = firebaseAuth.currentUser;
    if (user == null) throw UnauthenticatedException();
    return user.uid;
  }

  @override
  Stream<List<RewardModel>> watchCatalog() {
    return _rewards
        .where("isActive", isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs)
              RewardModel.fromFirestore(doc.id, doc.data()),
          ]..sort((a, b) => a.pointsCost.compareTo(b.pointsCost)),
        );
  }

  @override
  Stream<List<VoucherModel>> watchMyVouchers() {
    return _user(_currentUserId())
        .collection(FirestorePaths.vouchers)
        .orderBy("obtainedAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => [
            for (final doc in snapshot.docs)
              VoucherModel.fromFirestore(doc.id, doc.data()),
          ],
        );
  }

  // Transaction : le solde est relu puis débité d'un seul tenant, deux
  // échanges simultanés ne peuvent pas dépenser les mêmes points.
  @override
  Future<VoucherModel> redeem(Reward reward) async {
    try {
      final uid = _currentUserId();
      final userRef = _user(uid);
      final rewardRef = _rewards.doc(reward.id);
      final voucherRef = userRef.collection(FirestorePaths.vouchers).doc();
      final voucher = VoucherModel.issue(
        id: voucherRef.id,
        reward: reward,
        code: RedemptionPolicy.generateCode(),
        now: DateTime.now(),
      );

      await firestore
          .runTransaction<void>((tx) async {
            final user = await tx.get(userRef);
            final current = await tx.get(rewardRef);
            if (!current.exists || current.data()?["isActive"] != true) {
              throw RewardUnavailableException();
            }
            final fresh = RewardModel.fromFirestore(
              current.id,
              current.data()!,
            );
            final balance =
                (user.data()?["pointsBalance"] as num?)?.round() ?? 0;
            switch (RedemptionPolicy.check(balance: balance, reward: fresh)) {
              case RedemptionCheck.outOfStock:
                throw RewardOutOfStockException();
              case RedemptionCheck.insufficientPoints:
                throw InsufficientPointsException();
              case RedemptionCheck.allowed:
                break;
            }
            tx
              ..update(userRef, {
                "pointsBalance": FieldValue.increment(-fresh.pointsCost),
                "pointsSpentTotal": FieldValue.increment(fresh.pointsCost),
              })
              ..set(voucherRef, voucher.toFirestore());
          })
          .timeout(writeTimeout);

      // Après coup : un refus des règles sur le stock ou la notification
      // n'annule pas un échange déjà payé.
      if (reward.stock != null) {
        await _bestEffort(
          "stock",
          () => rewardRef.update({"stock": FieldValue.increment(-1)}),
        );
      }
      await _bestEffort(
        "notification",
        () => notifications.notify(
          uid,
          type: "voucherRedeemed",
          data: {"rewardName": reward.name, "voucherId": voucher.id},
        ),
      );
      return voucher;
    } on CustomException {
      rethrow;
    } on FirebaseException catch (e) {
      throw firebaseExceptionMapper(e);
    } on TimeoutException {
      throw NetworkException();
    }
  }

  Future<void> _bestEffort(String what, Future<void> Function() write) async {
    try {
      await write().timeout(writeTimeout);
    } on Object catch (e) {
      Log.w("Échange : écriture $what impossible ($e)");
    }
  }
}
