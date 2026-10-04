/// Palier de conversion d'une récompense (ex: 500 FCFA pour 100 points).
class RewardTier {
  const RewardTier({
    required this.id,
    required this.name,
    required this.pointsCost,
    required this.monetaryValue,
    this.currency = "FCFA",
  });

  /// Identifiant unique du palier.
  final String id;

  /// Libellé affiché (ex: "1 000 FCFA").
  final String name;

  /// Coût en points SecondLife.
  final int pointsCost;

  /// Valeur monétaire équivalente en monnaie locale.
  final double monetaryValue;

  /// Devise (ex: "FCFA").
  final String currency;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardTier &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          pointsCost == other.pointsCost &&
          monetaryValue == other.monetaryValue;

  @override
  int get hashCode =>
      id.hashCode ^ pointsCost.hashCode ^ monetaryValue.hashCode;
}
