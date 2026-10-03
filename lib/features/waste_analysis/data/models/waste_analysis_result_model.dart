import "../../domain/entities/waste_analysis_result.dart";
import "detected_material_model.dart";

/// Modèle DTO pour la réponse globale d'analyse d'un déchet.
class WasteAnalysisResultModel {
  const WasteAnalysisResultModel({
    required this.materials,
    required this.estimatedQuantity,
    required this.estimatedWeightKg,
    required this.isAccepted,
    required this.preparationAdvice,
    this.rejectionReason,
    this.rawResponse,
  });

  factory WasteAnalysisResultModel.fromJson(
    Map<String, dynamic> json, {
    String? rawResponse,
  }) {
    final rawMaterials = json["materials"] as List<dynamic>? ?? [];
    final materials = rawMaterials
        .whereType<Map<String, dynamic>>()
        .map(DetectedMaterialModel.fromJson)
        .toList();

    final weight = (json["estimated_weight_kg"] as num?)?.toDouble() ?? 0.1;

    return WasteAnalysisResultModel(
      materials: materials,
      estimatedQuantity: (json["estimated_quantity"] as num?)?.toInt() ?? 1,
      estimatedWeightKg: weight,
      isAccepted: json["is_accepted"] as bool? ?? false,
      rejectionReason: json["rejection_reason"] as String?,
      preparationAdvice: json["preparation_advice"] as String? ??
          "Déposez votre déchet dans un point relais agréé.",
      rawResponse: rawResponse,
    );
  }

  final List<DetectedMaterialModel> materials;
  final int estimatedQuantity;
  final double estimatedWeightKg;
  final bool isAccepted;
  final String? rejectionReason;
  final String preparationAdvice;
  final String? rawResponse;

  Map<String, dynamic> toJson() {
    return {
      "materials": materials.map((m) => m.toJson()).toList(),
      "estimated_quantity": estimatedQuantity,
      "estimated_weight_kg": estimatedWeightKg,
      "is_accepted": isAccepted,
      "rejection_reason": rejectionReason,
      "preparation_advice": preparationAdvice,
    };
  }

  WasteAnalysisResult toEntity() {
    return WasteAnalysisResult(
      materials: materials.map((m) => m.toEntity()).toList(),
      estimatedQuantity: estimatedQuantity,
      estimatedWeightKg: estimatedWeightKg,
      isAccepted: isAccepted,
      preparationAdvice: preparationAdvice,
      rejectionReason: rejectionReason,
      rawResponse: rawResponse,
    );
  }
}
