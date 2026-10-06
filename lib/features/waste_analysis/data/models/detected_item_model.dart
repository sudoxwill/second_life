import "../../domain/entities/detected_item.dart";

class DetectedItemModel extends DetectedItem {
  const DetectedItemModel({
    required super.itemLabel,
    required super.itemMainCategory,
    required super.itemsubCategory,
    required super.itemconfidenceScore,
  });

  factory DetectedItemModel.fromJson(Map<String, dynamic> json) {
    return DetectedItemModel(
      itemLabel: json["detected_item"] as String? ?? "Inconnu",
      itemMainCategory: json["main_category"] as String? ?? "Autre",
      itemsubCategory: json["sub_category"] as String? ?? "Autre",
      itemconfidenceScore: (json["confidence_score"] as num? ?? 0).toDouble(),
    );
  }

  factory DetectedItemModel.fromEntity(DetectedItem entity) {
    return DetectedItemModel(
      itemLabel: entity.itemLabel,
      itemMainCategory: entity.itemMainCategory,
      itemsubCategory: entity.itemsubCategory,
      itemconfidenceScore: entity.itemconfidenceScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "detected_item": itemLabel,
      "main_category": itemMainCategory,
      "sub_category": itemsubCategory,
      "confidence_score": itemconfidenceScore,
    };
  }
}
