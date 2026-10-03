import "detected_material.dart";

/// Résultat complet de l'analyse visuelle effectuée par RodiumAI.
class WasteAnalysisResult {
  const WasteAnalysisResult({
    required this.materials,
    required this.estimatedQuantity,
    required this.estimatedWeightKg,
    required this.isAccepted,
    required this.preparationAdvice,
    this.rejectionReason,
    this.rawResponse,
  });

  /// Liste des matériaux identifiés dans la prise de vue.
  final List<DetectedMaterial> materials;

  /// Quantité approximative d'unités détectées (ex. 3 bouteilles).
  final int estimatedQuantity;

  /// Poids indicatif estimé en kilogrammes.
  final double estimatedWeightKg;

  /// Indique si le déchet est accepté dans le réseau de points relais.
  final bool isAccepted;

  /// Motif de rejet si non conforme ou non pris en charge.
  final String? rejectionReason;

  /// Recommandations pour préparer le déchet (ex: rincer, écraser, vider).
  final String preparationAdvice;

  /// Réponse brute pour diagnostic ou logs.
  final String? rawResponse;

  /// Matériau dominant (plus haut score de confiance).
  DetectedMaterial? get primaryMaterial {
    if (materials.isEmpty) return null;
    return materials.reduce((a, b) => a.confidence >= b.confidence ? a : b);
  }

  /// Estimation théorique des points (100 pts/kg selon le barème
  /// de référence).
  int get estimatedPoints => (estimatedWeightKg * 100).round();

  @override
  String toString() {
    return "WasteAnalysisResult("
        "materials: ${materials.length}, "
        "weight: ${estimatedWeightKg}kg, "
        "accepted: $isAccepted)";
  }
}
