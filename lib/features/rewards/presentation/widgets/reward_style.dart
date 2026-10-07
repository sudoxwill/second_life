import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/localized_field.dart";
import "../../domain/entities/reward.dart";

extension RewardCategoryStyle on RewardCategory {
  IconData get icon => switch (this) {
    RewardCategory.food => LucideIcons.shoppingBasket,
    RewardCategory.health => LucideIcons.pill,
    RewardCategory.mobile => LucideIcons.smartphone,
    RewardCategory.transport => LucideIcons.bike,
    RewardCategory.school => LucideIcons.backpack,
    RewardCategory.shopping => LucideIcons.shoppingBag,
  };

  // (couleur, fond), reprises des teintes de matériaux pour l'harmonie.
  (Color, Color) colors(BuildContext context) {
    final dark = context.isDarkMode;
    return switch (this) {
      RewardCategory.food => (context.primaryText, context.primarySoft),
      RewardCategory.health => (
        dark ? AppColors.materialEwasteDark : AppColors.materialEwaste,
        dark ? AppColors.materialEwasteBgDark : AppColors.materialEwasteBg,
      ),
      RewardCategory.mobile => (context.info, context.infoSoft),
      RewardCategory.transport => (context.warning, context.warningSoft),
      RewardCategory.school => (
        dark ? AppColors.materialGlassDark : AppColors.materialGlass,
        dark ? AppColors.materialGlassBgDark : AppColors.materialGlassBg,
      ),
      RewardCategory.shopping => (
        dark ? AppColors.materialPaperDark : AppColors.materialPaper,
        dark ? AppColors.materialPaperBgDark : AppColors.materialPaperBg,
      ),
    };
  }
}

extension RewardTexts on Reward {
  String nameIn(BuildContext context) =>
      localizedField(name, context.l10n.localeName);
  String partnerIn(BuildContext context) =>
      localizedField(partnerName, context.l10n.localeName);
  String descriptionIn(BuildContext context) =>
      localizedField(description, context.l10n.localeName);
}
