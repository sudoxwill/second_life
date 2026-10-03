import "../../domain/entities/waste_analysis_result.dart";

/// États possibles du processus d'analyse IA d'un déchet.
sealed class WasteAnalysisState {
  const WasteAnalysisState();
}

/// État initial en attente d'une prise de vue.
class WasteAnalysisInitial extends WasteAnalysisState {
  const WasteAnalysisInitial();
}

/// Analyse en cours par RodiumAI.
class WasteAnalysisLoading extends WasteAnalysisState {
  const WasteAnalysisLoading();
}

/// Analyse terminée avec succès.
class WasteAnalysisSuccess extends WasteAnalysisState {
  const WasteAnalysisSuccess(this.result);

  final WasteAnalysisResult result;
}

/// Échec de l'analyse (problème réseau, image floue, rejet API).
class WasteAnalysisFailure extends WasteAnalysisState {
  const WasteAnalysisFailure(this.errorMessage);

  final String errorMessage;
}
