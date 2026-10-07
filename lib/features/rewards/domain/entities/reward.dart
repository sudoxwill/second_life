import "package:equatable/equatable.dart";

enum RewardCategory {
  food,
  health,
  mobile,
  transport,
  school,
  shopping;

  static RewardCategory fromName(String? name) =>
      values.asNameMap()[name] ?? RewardCategory.shopping;
}

// Récompense du catalogue rewards/{id}. Les textes sont gardés dans toutes
// les langues ; l'écran choisit selon la langue courante.
class Reward extends Equatable {
  const Reward({
    required this.id,
    required this.name,
    required this.partnerName,
    required this.description,
    required this.pointsCost,
    required this.category,
    required this.validityDays,
    this.stock,
  });

  final String id;
  final Object? name;
  final Object? partnerName;
  final Object? description;
  final int pointsCost;
  final RewardCategory category;
  final int validityDays;
  // null : illimité.
  final int? stock;

  bool get isOutOfStock => stock != null && stock! <= 0;

  @override
  List<Object?> get props => [id, pointsCost, stock];
}
