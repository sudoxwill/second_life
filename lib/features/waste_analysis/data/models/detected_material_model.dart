import "../../domain/entities/detected_material.dart";

/// Modèle DTO pour un matériau détecté dans la réponse API RodiumAI.
class DetectedMaterialModel {
  const DetectedMaterialModel({
    required this.name,
    required this.category,
    required this.confidence,
    this.description,
  });

  factory DetectedMaterialModel.fromJson(Map<String, dynamic> json) {
    return DetectedMaterialModel(
      name: json["name"] as String? ?? "Déchet non identifié",
      category: _parseCategory(json["category"] as String?),
      confidence: (json["confidence"] as num?)?.toDouble() ?? 0.0,
      description: json["description"] as String?,
    );
  }

  final String name;
  final WasteCategory category;
  final double confidence;
  final String? description;

  static WasteCategory _parseCategory(String? raw) {
    if (raw == null) return WasteCategory.other;
    final normalized = raw.toLowerCase().trim().replaceAll("-", "_");
    switch (normalized) {
      case "plastic_pet":
      case "pet":
      case "plastique_pet":
        return WasteCategory.plasticPet;
      case "plastic_pehd":
      case "plastic_hdpe":
      case "pehd":
      case "hdpe":
      case "plastique_pehd":
        return WasteCategory.plasticPeHd;
      case "metal_aluminum":
      case "aluminum":
      case "alu":
      case "aluminium":
        return WasteCategory.metalAluminum;
      case "metal_iron":
      case "iron":
      case "fer":
      case "ferraille":
        return WasteCategory.metalIron;
      case "cardboard":
      case "carton":
      case "paper":
      case "papier":
        return WasteCategory.cardboard;
      case "glass":
      case "verre":
        return WasteCategory.glass;
      case "electronic":
      case "electronique":
        return WasteCategory.electronic;
      case "organic":
      case "organique":
        return WasteCategory.organic;
      default:
        return WasteCategory.other;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category.name,
      "confidence": confidence,
      if (description != null) "description": description,
    };
  }

  DetectedMaterial toEntity() {
    return DetectedMaterial(
      name: name,
      category: category,
      confidence: confidence,
      description: description,
    );
  }
}
