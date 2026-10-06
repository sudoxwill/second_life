import "package:flutter/material.dart";

import "app_colors.dart";

/// Couleurs sémantiques qui suivent le mode clair / sombre.
extension AppSemanticColors on BuildContext {
  bool get _dark => Theme.of(this).brightness == Brightness.dark;

  /// Vert de marque lisible sur la surface courante.
  Color get primaryText => Theme.of(this).colorScheme.primary;

  /// Fond vert pâle (tuiles, pastilles).
  Color get primarySoft => Theme.of(this).colorScheme.primaryContainer;

  Color get danger => Theme.of(this).colorScheme.error;
  Color get dangerSoft => Theme.of(this).colorScheme.errorContainer;

  Color get warning =>
      _dark ? AppColors.semanticWarningDark : AppColors.semanticWarning;
  Color get warningSoft =>
      _dark ? AppColors.semanticWarningBgDark : AppColors.semanticWarningBg;

  /// Texte posé sur un fond [warning] (badges de compteur).
  Color get onWarning => _dark ? AppColors.onAccent : AppColors.onPrimary;
}
