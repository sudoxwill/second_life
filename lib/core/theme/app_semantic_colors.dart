import "package:flutter/material.dart";

import "app_colors.dart";

/// Couleurs qui changent avec le mode sombre.
extension AppSemanticColors on BuildContext {
  bool get _dark => Theme.of(this).brightness == Brightness.dark;

  Color get primaryText => Theme.of(this).colorScheme.primary;

  Color get primarySoft => Theme.of(this).colorScheme.primaryContainer;

  Color get danger => Theme.of(this).colorScheme.error;
  Color get dangerSoft => Theme.of(this).colorScheme.errorContainer;

  Color get warning =>
      _dark ? AppColors.semanticWarningDark : AppColors.semanticWarning;
  Color get warningSoft =>
      _dark ? AppColors.semanticWarningBgDark : AppColors.semanticWarningBg;

  Color get info => _dark ? AppColors.semanticInfoDark : AppColors.semanticInfo;
  Color get infoSoft =>
      _dark ? AppColors.semanticInfoBgDark : AppColors.semanticInfoBg;

  /// Texte des badges posés sur [warning].
  Color get onWarning => _dark ? AppColors.onAccent : AppColors.onPrimary;
}
