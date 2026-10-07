import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/rewards/data/models/voucher_model.dart";
import "package:second_life/features/rewards/domain/entities/reward.dart";
import "package:second_life/features/rewards/domain/entities/voucher.dart";

Map<String, dynamic> json({required DateTime expiresAt, String? status}) => {
  "rewardId": "food_1000",
  "name": {"fr": "Bon alimentaire", "en": "Food voucher"},
  "partnerName": "Marché",
  "pointsSpent": 100,
  "obtainedAt": Timestamp.fromDate(DateTime(2026, 9)),
  "expiresAt": Timestamp.fromDate(expiresAt),
  "code": "SL-ABCDEF",
  "status": ?status,
};

void main() {
  final future = DateTime.now().add(const Duration(days: 10));
  final past = DateTime.now().subtract(const Duration(days: 1));

  test("un bon non utilisé et non expiré est actif", () {
    final voucher = VoucherModel.fromFirestore("v1", json(expiresAt: future));
    expect(voucher.status, VoucherStatus.active);
    expect(voucher.code, "SL-ABCDEF");
    expect(voucher.pointsSpent, 100);
  });

  test("l'expiration se déduit de la date", () {
    final voucher = VoucherModel.fromFirestore(
      "v1",
      json(expiresAt: past, status: "active"),
    );
    expect(voucher.status, VoucherStatus.expired);
  });

  test("un bon utilisé reste utilisé, même expiré", () {
    final voucher = VoucherModel.fromFirestore(
      "v1",
      json(expiresAt: past, status: "used"),
    );
    expect(voucher.status, VoucherStatus.used);
  });

  test("issue() calcule l'expiration depuis la validité de la récompense", () {
    const reward = Reward(
      id: "r1",
      name: "Bon",
      partnerName: "Partenaire",
      description: null,
      pointsCost: 50,
      category: RewardCategory.mobile,
      validityDays: 15,
    );
    final now = DateTime(2026, 10);
    final voucher = VoucherModel.issue(
      id: "v1",
      reward: reward,
      code: "SL-AAAAAA",
      now: now,
    );
    expect(voucher.expiresAt, DateTime(2026, 10, 16));
    expect(voucher.status, VoucherStatus.active);
    expect(voucher.toFirestore()["pointsSpent"], 50);
  });
}
