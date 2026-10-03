import "dart:typed_data";

import "../entities/waste_analysis_result.dart";

/// Contrat du référentiel pour l'analyse des déchets par vision IA.
abstract class WasteAnalysisRepository {
  /// Analyse une image fournie sous forme d'octets mémoire.
  Future<WasteAnalysisResult> analyzeWasteFromBytes({
    required Uint8List imageBytes,
    required String mimeType,
  });

  /// Analyse une image stockée sur le système de fichiers local.
  Future<WasteAnalysisResult> analyzeWasteFromFile({
    required String filePath,
  });
}
