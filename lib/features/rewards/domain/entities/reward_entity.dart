enum RewardCategory { food, education, health }

enum RewardAvailability { comingSoon, available }

class RewardEntity {
  const RewardEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.pointsCost,
    this.availability = RewardAvailability.comingSoon,
    this.conditionsText,
    this.partnerName,
  });

  final String id;
  final String name;
  final RewardCategory category;
  final int pointsCost;
  final RewardAvailability availability;
  // Conditions d'utilisation affichées dans la page détail.
  final String? conditionsText;
  // Nom du partenaire : null au MVP, renseigné en V2.
  final String? partnerName;

  bool get isComingSoon => availability == RewardAvailability.comingSoon;
}
