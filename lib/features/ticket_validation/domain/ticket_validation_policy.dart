// Règles métier de la pesée au point relais.
// Doivent rester identiques aux contrôles de firestore.rules.
abstract final class TicketValidationPolicy {
  static const maxWeightGrams = 50000.0;
  // Au-delà de 50 % d'écart avec l'estimation de l'IA, un commentaire
  // est obligatoire.
  static const maxWeightDeviation = 0.5;
  static const maxCommentLength = 500;

  static bool isWeightAllowed(double weightGrams) =>
      weightGrams > 0 && weightGrams <= maxWeightGrams;

  static bool isWeightDeviated(double measuredGrams, double estimatedGrams) =>
      estimatedGrams <= 0 ||
      (measuredGrams - estimatedGrams).abs() >
          estimatedGrams * maxWeightDeviation;

  // Points et CO₂ au prorata du poids réel. Même ordre d'opérations que
  // dans firestore.rules, sinon l'égalité sur les flottants échoue.
  static double prorate(
    double estimatedValue,
    double measuredGrams,
    double estimatedGrams,
  ) => estimatedGrams > 0
      ? estimatedValue * measuredGrams / estimatedGrams
      : estimatedValue;

  // Commentaire vide ou blanc = pas de commentaire.
  static String? normalizeComment(String? comment) {
    final trimmed = comment?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
