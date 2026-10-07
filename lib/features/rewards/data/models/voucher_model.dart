import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/reward.dart";
import "../../domain/entities/voucher.dart";

class VoucherModel extends Voucher {
  const VoucherModel({
    required super.id,
    required super.name,
    required super.partnerName,
    required super.pointsSpent,
    required super.obtainedAt,
    required super.expiresAt,
    required super.code,
    required super.status,
    super.rewardId,
    super.usedAt,
  });

  // Nouveau bon, avant écriture : actif jusqu'à son expiration.
  factory VoucherModel.issue({
    required String id,
    required Reward reward,
    required String code,
    required DateTime now,
  }) {
    return VoucherModel(
      id: id,
      rewardId: reward.id,
      name: reward.name,
      partnerName: reward.partnerName,
      pointsSpent: reward.pointsCost,
      obtainedAt: now,
      expiresAt: now.add(Duration(days: reward.validityDays)),
      code: code,
      status: VoucherStatus.active,
    );
  }

  // "Expiré" n'est pas stocké : le statut se déduit de la date.
  factory VoucherModel.fromFirestore(String id, Map<String, dynamic> json) {
    final now = DateTime.now();
    final expiresAt = (json["expiresAt"] as Timestamp?)?.toDate() ?? now;
    final used = json["status"] == VoucherStatus.used.name;
    return VoucherModel(
      id: id,
      rewardId: json["rewardId"] as String?,
      name: json["name"],
      partnerName: json["partnerName"],
      pointsSpent: (json["pointsSpent"] as num?)?.round() ?? 0,
      obtainedAt: (json["obtainedAt"] as Timestamp?)?.toDate() ?? now,
      expiresAt: expiresAt,
      code: json["code"] as String? ?? "",
      usedAt: (json["usedAt"] as Timestamp?)?.toDate(),
      status: used
          ? VoucherStatus.used
          : expiresAt.isBefore(now)
          ? VoucherStatus.expired
          : VoucherStatus.active,
    );
  }

  Map<String, dynamic> toFirestore() => {
    "rewardId": rewardId,
    "name": name,
    "partnerName": partnerName,
    "pointsSpent": pointsSpent,
    "obtainedAt": Timestamp.fromDate(obtainedAt),
    "expiresAt": Timestamp.fromDate(expiresAt),
    "code": code,
    "status": status.name,
  };
}
