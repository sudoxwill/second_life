import "reward_category.dart";
import "reward_tier.dart";

/// Carte cadeau ou bon de réduction disponible dans le catalogue SecondLife.
class RewardCard {
  const RewardCard({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.description,
    required this.shortDescription,
    required this.tiers,
    required this.termsAndConditions,
    this.validityDays = 90,
    this.isPopular = false,
    this.isAvailable = true,
    this.accentColorHex,
    this.badgeText,
  });

  /// Identifiant unique de la carte cadeau.
  final String id;

  /// Nom complet de l'offre (ex: "Bon d'achat Jumia").
  final String title;

  /// Marque ou enseigne partenaire (ex: "T-Money", "Moov", "Jumia").
  final String brand;

  /// Catégorie de la récompense.
  final RewardCategory category;

  /// Description détaillée.
  final String description;

  /// Accroche courte pour la vignette.
  final String shortDescription;

  /// Différents paliers de montants disponibles.
  final List<RewardTier> tiers;

  /// Conditions générales d'utilisation.
  final List<String> termsAndConditions;

  /// Durée de validité du bon après échange (en jours).
  final int validityDays;

  /// Indique si la récompense est mise en avant.
  final bool isPopular;

  /// Disponibilité en stock.
  final bool isAvailable;

  /// Code couleur hexadécimal optionnel pour la personnalisation visuelle.
  final String? accentColorHex;

  /// Badge informatif (ex: "Populaire", "Nouveau", "Promo").
  final String? badgeText;

  /// Retourne le palier ayant le coût en points le plus bas.
  RewardTier get lowestTier {
    assert(tiers.isNotEmpty, "RewardCard must have at least one tier");
    return tiers.reduce(
      (curr, next) => curr.pointsCost < next.pointsCost ? curr : next,
    );
  }

  /// Retourne le palier ayant le coût en points le plus élevé.
  RewardTier get highestTier {
    assert(tiers.isNotEmpty, "RewardCard must have at least one tier");
    return tiers.reduce(
      (curr, next) => curr.pointsCost > next.pointsCost ? curr : next,
    );
  }
}
