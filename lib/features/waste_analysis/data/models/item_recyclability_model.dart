import "../../domain/entities/item_recyclability.dart";

class ItemRecyclabilityModel extends ItemRecyclability {
  const ItemRecyclabilityModel({
    required super.isRecyclable,
    required super.sortingInstructions,
    required super.co2SavedGrams,
    required super.pointsEarned,
  });

  factory ItemRecyclabilityModel.fromJson(Map<String, dynamic> json) {
    final environmentalImpact =
        json["environmental_impact"] as Map<String, dynamic>?;
    return ItemRecyclabilityModel(
      isRecyclable: json["is_recyclable"] as bool? ?? false,
      sortingInstructions: json["sorting_instructions"] as String? ?? "",
      co2SavedGrams: (environmentalImpact?["co2_saved_grams"] as num? ?? 0)
          .toDouble(),
      pointsEarned: (environmentalImpact?["points_earned"] as num? ?? 0)
          .toDouble(),
    );
  }

  factory ItemRecyclabilityModel.fromEntity(ItemRecyclability entity) {
    return ItemRecyclabilityModel(
      isRecyclable: entity.isRecyclable,
      sortingInstructions: entity.sortingInstructions,
      co2SavedGrams: entity.co2SavedGrams,
      pointsEarned: entity.pointsEarned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_recyclable": isRecyclable,
      "sorting_instructions": sortingInstructions,
      "environmental_impact": {
        "co2_saved_grams": co2SavedGrams,
        "points_earned": pointsEarned,
      },
    };
  }
}
