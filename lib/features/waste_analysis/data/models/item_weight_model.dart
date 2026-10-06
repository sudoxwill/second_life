import "../../domain/entities/item_weight.dart";

class ItemWeightModel extends ItemWeight {
  const ItemWeightModel({
    required super.estimatedWeight,
    required super.estimatedMinWeight,
    required super.estimatedMaxWeight,
    required super.estimationBasis,
  });

  factory ItemWeightModel.fromJson(Map<String, dynamic> json) {
    final weightRange = json["weight_range"] as Map<String, dynamic>?;
    return ItemWeightModel(
      estimatedWeight: (json["estimated_weight_grams"] as num? ?? 0).toDouble(),
      estimatedMinWeight: (weightRange?["min_grams"] as num? ?? 0).toDouble(),
      estimatedMaxWeight: (weightRange?["max_grams"] as num? ?? 0).toDouble(),
      estimationBasis: json["estimation_basis"] as String? ?? "",
    );
  }

  factory ItemWeightModel.fromEntity(ItemWeight entity) {
    return ItemWeightModel(
      estimatedWeight: entity.estimatedWeight,
      estimatedMinWeight: entity.estimatedMinWeight,
      estimatedMaxWeight: entity.estimatedMaxWeight,
      estimationBasis: entity.estimationBasis,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "estimated_weight_grams": estimatedWeight,
      "weight_range": {
        "min_grams": estimatedMinWeight,
        "max_grams": estimatedMaxWeight,
      },
      "estimation_basis": estimationBasis,
    };
  }
}
