import "../../domain/entities/reward_card.dart";
import "../../domain/entities/reward_category.dart";
import "reward_tier_model.dart";

/// Modèle sérialisable d'une carte cadeau.
class RewardCardModel extends RewardCard {
  const RewardCardModel({
    required super.id,
    required super.title,
    required super.brand,
    required super.category,
    required super.description,
    required super.shortDescription,
    required super.tiers,
    required super.termsAndConditions,
    super.validityDays,
    super.isPopular,
    super.isAvailable,
    super.accentColorHex,
    super.badgeText,
  });

  factory RewardCardModel.fromJson(Map<String, dynamic> json) {
    return RewardCardModel(
      id: json["id"] as String,
      title: json["title"] as String,
      brand: json["brand"] as String,
      category: RewardCategory.values.firstWhere(
        (c) => c.name == json["category"],
        orElse: () => RewardCategory.telecom,
      ),
      description: json["description"] as String,
      shortDescription: json["short_description"] as String,
      tiers: (json["tiers"] as List<dynamic>)
          .map((t) => RewardTierModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      termsAndConditions:
          (json["terms"] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      validityDays: (json["validity_days"] as int?) ?? 90,
      isPopular: (json["is_popular"] as bool?) ?? false,
      isAvailable: (json["is_available"] as bool?) ?? true,
      accentColorHex: json["accent_color_hex"] as String?,
      badgeText: json["badge_text"] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "brand": brand,
    "category": category.name,
    "description": description,
    "short_description": shortDescription,
    "tiers": tiers
        .map(
          (t) => (t is RewardTierModel)
              ? t.toJson()
              : RewardTierModel(
                  id: t.id,
                  name: t.name,
                  pointsCost: t.pointsCost,
                  monetaryValue: t.monetaryValue,
                  currency: t.currency,
                ).toJson(),
        )
        .toList(),
    "terms": termsAndConditions,
    "validity_days": validityDays,
    "is_popular": isPopular,
    "is_available": isAvailable,
    "accent_color_hex": accentColorHex,
    "badge_text": badgeText,
  };
}
