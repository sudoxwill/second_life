import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/theme/index.dart";
import "../../../../l10n/app_localizations.dart";
import "../../domain/entities/reward_entity.dart";

extension RewardCategoryStyle on RewardCategory {
  IconData get icon => switch (this) {
    RewardCategory.food => LucideIcons.shoppingBasket,
    RewardCategory.education => LucideIcons.graduationCap,
    RewardCategory.health => LucideIcons.heart,
  };

  Color foregroundColor(BuildContext context) => switch (this) {
    RewardCategory.food => context.warning,
    RewardCategory.education => context.info,
    RewardCategory.health => context.danger,
  };

  Color backgroundColor(BuildContext context) => switch (this) {
    RewardCategory.food => context.warningSoft,
    RewardCategory.education => context.infoSoft,
    RewardCategory.health => context.dangerSoft,
  };

  String label(AppLocalizations l10n) => switch (this) {
    RewardCategory.food => l10n.rewardsCategoryFood,
    RewardCategory.education => l10n.rewardsCategoryEducation,
    RewardCategory.health => l10n.rewardsCategoryHealth,
  };
}
