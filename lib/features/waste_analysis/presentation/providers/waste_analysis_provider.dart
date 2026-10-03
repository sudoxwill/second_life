import "dart:typed_data";

import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../core/configs/logger.dart";
import "../../data/datasources/rodium_ai_remote_datasource.dart";
import "../../data/repositories/waste_analysis_repository_impl.dart";
import "../../domain/repositories/waste_analysis_repository.dart";
import "waste_analysis_state.dart";

/// Provider injectant la source de données RodiumAI.
final rodiumAiDataSourceProvider =
    Provider<RodiumAiRemoteDataSource>((Ref ref) {
  return RodiumAiRemoteDataSource();
});

/// Provider injectant le référentiel d'analyse des déchets.
final wasteAnalysisRepositoryProvider =
    Provider<WasteAnalysisRepository>((Ref ref) {
  final dataSource = ref.watch(rodiumAiDataSourceProvider);
  return WasteAnalysisRepositoryImpl(remoteDataSource: dataSource);
});

/// Notifier gérant le cycle de vie de l'analyse IA d'un déchet.
class WasteAnalysisNotifier extends Notifier<WasteAnalysisState> {
  @override
  WasteAnalysisState build() => const WasteAnalysisInitial();

  WasteAnalysisRepository get _repository =>
      ref.read(wasteAnalysisRepositoryProvider);

  /// Lance l'analyse à partir d'octets d'image (ex: capture caméra mémoire).
  Future<void> analyzeImageBytes(
    Uint8List bytes, {
    String mimeType = "image/jpeg",
  }) async {
    state = const WasteAnalysisLoading();
    try {
      Log.i("Démarrage de l'analyse visuelle...", tag: "WasteAnalysis");
      final result = await _repository.analyzeWasteFromBytes(
        imageBytes: bytes,
        mimeType: mimeType,
      );
      state = WasteAnalysisSuccess(result);
      Log.s("Analyse IA réussie : $result", tag: "WasteAnalysis");
    } catch (e, st) {
      Log.e(
        "Échec de l'analyse IA",
        error: e,
        stackTrace: st,
        tag: "WasteAnalysis",
      );
      state = WasteAnalysisFailure(e.toString());
    }
  }

  /// Lance l'analyse à partir d'un chemin de fichier image sur l'appareil.
  Future<void> analyzeImageFile(String filePath) async {
    state = const WasteAnalysisLoading();
    try {
      Log.i("Lecture et analyse du fichier: $filePath", tag: "WasteAnalysis");
      final result = await _repository.analyzeWasteFromFile(
        filePath: filePath,
      );
      state = WasteAnalysisSuccess(result);
      Log.s("Analyse IA réussie : $result", tag: "WasteAnalysis");
    } catch (e, st) {
      Log.e(
        "Échec de l'analyse du fichier",
        error: e,
        stackTrace: st,
        tag: "WasteAnalysis",
      );
      state = WasteAnalysisFailure(e.toString());
    }
  }

  /// Réinitialise l'état pour une nouvelle prise de vue.
  void reset() {
    state = const WasteAnalysisInitial();
  }
}

/// Provider d'état pour l'UI de scan et d'analyse.
final wasteAnalysisNotifierProvider =
    NotifierProvider<WasteAnalysisNotifier, WasteAnalysisState>(
  WasteAnalysisNotifier.new,
);
