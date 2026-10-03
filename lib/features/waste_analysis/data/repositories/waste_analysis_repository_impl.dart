import "dart:io";
import "dart:typed_data";

import "../../domain/entities/waste_analysis_result.dart";
import "../../domain/repositories/waste_analysis_repository.dart";
import "../datasources/rodium_ai_remote_datasource.dart";

/// Implémentation concrète du référentiel d'analyse des déchets.
class WasteAnalysisRepositoryImpl implements WasteAnalysisRepository {
  const WasteAnalysisRepositoryImpl({
    required RodiumAiRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final RodiumAiRemoteDataSource _remoteDataSource;

  @override
  Future<WasteAnalysisResult> analyzeWasteFromBytes({
    required Uint8List imageBytes,
    required String mimeType,
  }) async {
    final model = await _remoteDataSource.analyzeWasteImage(
      imageBytes: imageBytes,
      mimeType: mimeType,
    );
    return model.toEntity();
  }

  @override
  Future<WasteAnalysisResult> analyzeWasteFromFile({
    required String filePath,
  }) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw const AiServiceException(
        "Le fichier image spécifié est introuvable.",
      );
    }

    final bytes = await file.readAsBytes();
    final mimeType = _resolveMimeType(filePath);

    return analyzeWasteFromBytes(
      imageBytes: bytes,
      mimeType: mimeType,
    );
  }

  String _resolveMimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith(".png")) return "image/png";
    if (lower.endsWith(".webp")) return "image/webp";
    if (lower.endsWith(".heic")) return "image/heic";
    return "image/jpeg";
  }
}
