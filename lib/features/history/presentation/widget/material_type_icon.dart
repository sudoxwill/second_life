import "package:flutter/material.dart" hide MaterialType;
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../l10n/app_localizations.dart";

enum MaterialType { plastic, paper, metal, glass, ewaste, organic }

/// Libellé localisé d'un type de matériau : `Plastique` / `Plastic`.
extension MaterialTypeLabel on MaterialType {
  String label(AppLocalizations l10n) => switch (this) {
    MaterialType.plastic => l10n.materialPlastic,
    MaterialType.paper => l10n.materialPaper,
    MaterialType.metal => l10n.materialMetal,
    MaterialType.glass => l10n.materialGlass,
    MaterialType.ewaste => l10n.materialEwaste,
    MaterialType.organic => l10n.materialOrganic,
  };
}

/// Mappe la chaîne `itemMainCategory` de l'API vers `MaterialType`.
extension MaterialTypeFromCategory on MaterialType {
  static MaterialType fromCategory(String category) {
    return switch (category.toLowerCase()) {
      "plastic" || "plastique" => MaterialType.plastic,
      "paper" || "papier" || "cardboard" || "carton" => MaterialType.paper,
      "metal" || "métal" || "aluminium" || "iron" || "fer" =>
        MaterialType.metal,
      "glass" || "verre" => MaterialType.glass,
      "ewaste" || "e-waste" || "electronic" || "électronique" =>
        MaterialType.ewaste,
      "organic" || "organique" || "food" || "alimentaire" =>
        MaterialType.organic,
      _ => MaterialType.plastic,
    };
  }
}

class MaterialTypeIcon extends StatelessWidget {
  const MaterialTypeIcon({
    required this.material,
    this.size = AppSpacing.giga,
    super.key,
  });

  final MaterialType material;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDarkMode;
    final (icon, fg, bg) = _resolve(material, dark);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, borderRadius: AppSpacing.roundedMd),
      child: Icon(icon, color: fg, size: AppSpacing.iconMd),
    );
  }

  static (IconData, Color, Color) _resolve(MaterialType type, bool dark) =>
      switch (type) {
        MaterialType.plastic => (
          LucideIcons.bottleWine,
          dark ? AppColors.materialPlasticDark : AppColors.materialPlastic,
          dark ? AppColors.materialPlasticBgDark : AppColors.materialPlasticBg,
        ),
        MaterialType.paper => (
          LucideIcons.newspaper,
          dark ? AppColors.materialPaperDark : AppColors.materialPaper,
          dark ? AppColors.materialPaperBgDark : AppColors.materialPaperBg,
        ),
        MaterialType.metal => (
          LucideIcons.wrench,
          dark ? AppColors.materialMetalDark : AppColors.materialMetal,
          dark ? AppColors.materialMetalBgDark : AppColors.materialMetalBg,
        ),
        MaterialType.glass => (
          LucideIcons.wine,
          dark ? AppColors.materialGlassDark : AppColors.materialGlass,
          dark ? AppColors.materialGlassBgDark : AppColors.materialGlassBg,
        ),
        MaterialType.ewaste => (
          LucideIcons.cpu,
          dark ? AppColors.materialEwasteDark : AppColors.materialEwaste,
          dark ? AppColors.materialEwasteBgDark : AppColors.materialEwasteBg,
        ),
        MaterialType.organic => (
          LucideIcons.leaf,
          dark ? AppColors.materialOrganicDark : AppColors.materialOrganic,
          dark ? AppColors.materialOrganicBgDark : AppColors.materialOrganicBg,
        ),
      };
}
