import "../../domain/entities/reward_tier.dart";

/// Modèle de données pour les paliers d'une récompense.
class RewardTierModel extends RewardTier {
  const RewardTierModel({
    required super.id,
    required super.name,
    required super.pointsCost,
    required super.monetaryValue,
    super.currency,
  });

  factory RewardTierModel.fromJson(Map<String, dynamic> json) {
    return RewardTierModel(
      id: json["id"] as String,
      name: json["name"] as String,
      pointsCost: json["points_cost"] as int,
      monetaryValue: (json["monetary_value"] as num).toDouble(),
      currency: (json["currency"] as String?) ?? "FCFA",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "points_cost": pointsCost,
    "monetary_value": monetaryValue,
    "currency": currency,
  };
}
