import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../l10n/app_localizations.dart";

/// Extensions courantes sur `BuildContext`.
///
extension BuildContextExtensions on BuildContext {
  // ═══════════════════════════════════════════════════════════════
  // Localisation
  // ═══════════════════════════════════════════════════════════════

  /// Accès concis aux chaînes traduites. Ex : `context.l10n.commonOk`.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Date et heure selon la locale courante :
  /// `10 sept. 2026 à 14:32` en fr, `Sept 10, 2026 at 2:32 PM` en en.
  String formatDateTime(DateTime date) => l10n.commonDateTime(
        DateFormat.yMMMd(l10n.localeName).format(date),
        DateFormat.jm(l10n.localeName).format(date),
      );

  /// Date selon la locale courante : `10 sept. 2026` / `Sept 10, 2026`.
  String formatDate(DateTime date) =>
      DateFormat.yMMMd(l10n.localeName).format(date);

  // ═══════════════════════════════════════════════════════════════
  // Thème & apparence
  // ═══════════════════════════════════════════════════════════════

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  // ═══════════════════════════════════════════════════════════════
  // Responsive
  // ═══════════════════════════════════════════════════════════════

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;

  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  // ═══════════════════════════════════════════════════════════════
  // Navigation
  // ═══════════════════════════════════════════════════════════════

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop(result);
  }

  bool get canPop => Navigator.of(this).canPop();

  // ═══════════════════════════════════════════════════════════════
  // Retour utilisateur
  // ═══════════════════════════════════════════════════════════════

  /// Affiche une snackbar sobre. Le style de fond vient du thème
  /// (`surfaceInverse`) ; on peut le remplacer via `backgroundColor`.
  void showSnackBar(
      String message, {
        Duration duration = const Duration(seconds: 3),
        Color? backgroundColor,
        SnackBarAction? action,
      }) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          backgroundColor: backgroundColor,
          action: action,
        ),
      );
  }

  /// Dialog de confirmation — tutoiement, phrases courtes.
  ///
  /// Retourne `true` si l'utilisateur confirme, `false` s'il annule.
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String? confirmLabel,
    String? cancelLabel,
    bool destructive = false,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel ?? l10n.commonCancel),
          ),
          // AppSpacing.gapHSm,
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: destructive
                ? ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
            )
                : null,
            child: Text(confirmLabel ?? l10n.commonOk),
          ),
        ],
      ),
    );
  }

  /// Dialog informatif — un seul bouton.
  Future<void> showInfoDialog({
    required String title,
    required String content,
    String? buttonLabel,
  }) {
    return showDialog<void>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonLabel ?? l10n.commonOk),
          ),
        ],
      ),
    );
  }
}
