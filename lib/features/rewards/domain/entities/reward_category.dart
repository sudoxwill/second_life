import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// Catégories de récompenses disponibles dans SecondLife.
enum RewardCategory {
  all(
    label: "Tout",
    icon: LucideIcons.layoutGrid,
    description: "Toutes les récompenses",
  ),
  telecom(
    label: "Mobile & Data",
    icon: LucideIcons.smartphone,
    description: "Crédit d'appel, data Internet et Mobile Money",
  ),
  shopping(
    label: "Achats & Courses",
    icon: LucideIcons.shoppingBag,
    description: "Bons d'achat supermarchés et e-commerce",
  ),
  services(
    label: "Énergie & Services",
    icon: LucideIcons.zap,
    description: "Carburant, CashPower et services du quotidien",
  ),
  entertainment(
    label: "Divertissement",
    icon: LucideIcons.tv,
    description: "Abonnements streaming et TV",
  ),
  ecoImpact(
    label: "Impact Écolo",
    icon: LucideIcons.sprout,
    description: "Dons et soutien à des initiatives environnementales",
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
