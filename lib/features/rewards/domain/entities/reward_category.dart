import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// Catégories de besoins essentiels couverts par les récompenses SecondLife.
enum RewardCategory {
  all(
    label: "Tout l'essentiel",
    icon: LucideIcons.layoutGrid,
    description: "Tous les biens et services vitaux",
  ),
  food(
    label: "Alimentation",
    icon: LucideIcons.utensils,
    description:
        "Ravitaillement et produits alimentaires de première nécessité",
  ),
  health(
    label: "Santé & Soins",
    icon: LucideIcons.heartPulse,
    description: "Médicaments essentiels, consultations et soins de santé",
  ),
  education(
    label: "Scolarisation",
    icon: LucideIcons.graduationCap,
    description: "Frais scolaires, fournitures et cantine pour les enfants",
  ),
  hygieneWater(
    label: "Eau & Hygiène",
    icon: LucideIcons.droplets,
    description: "Eau potable purifiée et kits d'hygiène familiale de base",
  );

  const RewardCategory({
    required this.label,
    required this.icon,
    required this.description,
  });

  final String label;
  final IconData icon;
  final String description;
}
