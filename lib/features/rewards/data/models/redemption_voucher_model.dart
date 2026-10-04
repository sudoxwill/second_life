import "../../domain/entities/redemption_voucher.dart";

/// Modèle sérialisable d'un bon d'achat débloqué.
class RedemptionVoucherModel extends RedemptionVoucher {
  const RedemptionVoucherModel({
    required super.id,
    required super.rewardCardId,
    required super.rewardTitle,
    required super.brand,
    required super.tierName,
    required super.pointsSpent,
    required super.monetaryValue,
    required super.currency,
    required super.voucherCode,
    required super.createdAt,
    required super.expiresAt,
    required super.status,
    super.recipient,
    super.pinCode,
  });

  factory RedemptionVoucherModel.fromJson(Map<String, dynamic> json) {
    return RedemptionVoucherModel(
      id: json["id"] as String,
      rewardCardId: json["reward_card_id"] as String,
      rewardTitle: json["reward_title"] as String,
      brand: json["brand"] as String,
      tierName: json["tier_name"] as String,
      pointsSpent: json["points_spent"] as int,
      monetaryValue: (json["monetary_value"] as num).toDouble(),
      currency: (json["currency"] as String?) ?? "FCFA",
      voucherCode: json["voucher_code"] as String,
      createdAt: DateTime.parse(json["created_at"] as String),
      expiresAt: DateTime.parse(json["expires_at"] as String),
      status: VoucherStatus.values.firstWhere(
        (s) => s.name == json["status"],
        orElse: () => VoucherStatus.active,
      ),
      recipient: json["recipient"] as String?,
      pinCode: json["pin_code"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "reward_card_id": rewardCardId,
    "reward_title": rewardTitle,
    "brand": brand,
    "tier_name": tierName,
    "points_spent": pointsSpent,
    "monetary_value": monetaryValue,
    "currency": currency,
    "voucher_code": voucherCode,
    "created_at": createdAt.toIso8601String(),
    "expires_at": expiresAt.toIso8601String(),
    "status": status.name,
    "recipient": recipient,
    "pin_code": pinCode,
  };
}
