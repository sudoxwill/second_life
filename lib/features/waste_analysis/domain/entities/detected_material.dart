/// Catégories de matériaux reconnues par le système de tri SecondLife.
enum WasteCategory {
  plasticPet,
  plasticPeHd,
  metalAluminum,
  metalIron,
  cardboard,
  glass,
  electronic,
  organic,
  other;

  /// Libellé lisible en français.
  String get displayName {
    switch (this) {
      case WasteCategory.plasticPet:
        return "Plastique PET (bouteilles)";
      case WasteCategory.plasticPeHd:
        return "Plastique PEHD (flacons, bouchons)";
      case WasteCategory.metalAluminum:
        return "Aluminium (canettes)";
      case WasteCategory.metalIron:
        return "Ferraille / Fer";
      case WasteCategory.cardboard:
        return "Carton / Papier";
      case WasteCategory.glass:
        return "Verre";
      case WasteCategory.electronic:
        return "Déchets électroniques";
      case WasteCategory.organic:
        return "Déchets organiques";
      case WasteCategory.other:
        return "Autre déchet";
    }
  }

  /// Détermine si le matériau est éligible aux points relais SecondLife MVP.
  bool get isRecyclableInRelayPoint {
    switch (this) {
      case WasteCategory.plasticPet:
      case WasteCategory.plasticPeHd:
      case WasteCategory.metalAluminum:
      case WasteCategory.metalIron:
        return true;
      case WasteCategory.cardboard:
      case WasteCategory.glass:
      case WasteCategory.electronic:
      case WasteCategory.organic:
      case WasteCategory.other:
        return false;
    }
  }
}

/// Entité représentant un matériau détecté dans une image par l'IA.
class DetectedMaterial {
  const DetectedMaterial({
    required this.name,
    required this.category,
    required this.confidence,
    this.description,
  });

  final String name;
  final WasteCategory category;
  final double confidence;
  final String? description;

  /// Indique si la détection est considérée comme fiable (>= 70%).
  bool get isReliable => confidence >= 0.70;

  @override
  String toString() {
    return "DetectedMaterial("
        "name: $name, category: $category, confidence: $confidence)";
  }
}
