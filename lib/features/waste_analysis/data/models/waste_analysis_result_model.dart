import "../../domain/entities/waste_analysis_result.dart";
import "detected_item_model.dart";
import "item_recyclability_model.dart";
import "item_weight_model.dart";

class WasteAnalysisResultModel extends WasteAnalysisResult {
  const WasteAnalysisResultModel({
    required super.detectedItem,
    required super.itemWeight,
    required super.itemRecyclability,
    required super.warnings,
  });

  factory WasteAnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return WasteAnalysisResultModel(
      detectedItem: DetectedItemModel.fromJson(
        json["item_identification"] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
      itemWeight: ItemWeightModel.fromJson(
        json["weight_estimation"] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
      itemRecyclability: ItemRecyclabilityModel.fromJson(
        json["recyclability"] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      warnings: List<String>.from(json["warnings"] as List<dynamic>? ?? []),
    );
  }

  factory WasteAnalysisResultModel.fromEntity(WasteAnalysisResult entity) {
    return WasteAnalysisResultModel(
      detectedItem: DetectedItemModel.fromEntity(entity.detectedItem),
      itemWeight: ItemWeightModel.fromEntity(entity.itemWeight),
      itemRecyclability: ItemRecyclabilityModel.fromEntity(
        entity.itemRecyclability,
      ),
      warnings: entity.warnings,
    );
  }

  // Même forme que la réponse de l'IA : fromJson relit le ticket Firestore.
  Map<String, dynamic> toJson() {
    return {
      "item_identification": DetectedItemModel.fromEntity(detectedItem)
          .toJson(),
      "weight_estimation": ItemWeightModel.fromEntity(itemWeight).toJson(),
      "recyclability": ItemRecyclabilityModel.fromEntity(itemRecyclability)
          .toJson(),
      "warnings": warnings,
    };
  }
}
