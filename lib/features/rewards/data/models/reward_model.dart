import "../../domain/entities/reward.dart";

class RewardModel extends Reward {
  const RewardModel({
    required super.id,
    required super.name,
    required super.partnerName,
    required super.description,
    required super.pointsCost,
    required super.category,
    required super.validityDays,
    super.stock,
  });

  factory RewardModel.fromFirestore(String id, Map<String, dynamic> json) {
    return RewardModel(
      id: id,
      name: json["name"],
      partnerName: json["partnerName"],
      description: json["description"],
      pointsCost: (json["pointsCost"] as num?)?.round() ?? 0,
      category: RewardCategory.fromName(json["category"] as String?),
      validityDays: (json["validityDays"] as num?)?.round() ?? 30,
      stock: (json["stock"] as num?)?.round(),
    );
  }
}
