import "dart:ui" show FontFeature;

import "package:flutter/material.dart" show TextTheme, FontWeight, TextStyle;

import "app_colors.dart";

/// Typographie SecondLife : Bricolage Grotesque (titres, montants), Figtree
/// (texte) et OpenDyslexic (mode dyslexie activable dans les paramètres).
class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = "Figtree";
  static const String fontFamilyDisplay = "BricolageGrotesque";
  static const String fontFamilyDyslexic = "OpenDyslexic";

  static const double _dyslexicMinHeight = 1.5;
  static const double _dyslexicLetterSpacing = 0.4;
  static const double _dyslexicWordSpacing = 1.5;
  static const double _dyslexicLargeTextScale = 0.85;

  // ─────────────────────────────────────────────
  // ÉCHELLE DE TYPE
  // ─────────────────────────────────────────────

  static const TextStyle display = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.96,
    height: 1.08,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.36,
    height: 1.11,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0,
    height: 1.23,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.37,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.41,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.41,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.47,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
    height: 1.38,
  );

  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.33,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
    height: 1.38,
  );

  // ─────────────────────────────────────────────
  // LIGHT MODE — Text theme
  // ─────────────────────────────────────────────

  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.96,
      height: 1.08,
      fontFeatures: [FontFeature.tabularFigures()],
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.36,
      height: 1.11,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      height: 1.23,
      color: AppColors.textPrimary,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.36,
      height: 1.11,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      height: 1.23,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.37,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.37,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.41,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.33,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: 1.41,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: 1.47,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0,
      height: 1.38,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.33,
      color: AppColors.textSecondary,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.38,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0,
      height: 1.38,
      color: AppColors.textTertiary,
    ),
  );

  // ─────────────────────────────────────────────
  // DARK MODE — Text theme
  // ─────────────────────────────────────────────

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.96,
      height: 1.08,
      fontFeatures: [FontFeature.tabularFigures()],
      color: AppColors.textPrimaryDark,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.36,
      height: 1.11,
      color: AppColors.textPrimaryDark,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      height: 1.23,
      color: AppColors.textPrimaryDark,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.36,
      height: 1.11,
      color: AppColors.textPrimaryDark,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamilyDisplay,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.0,
      height: 1.23,
      color: AppColors.textPrimaryDark,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.37,
      color: AppColors.textPrimaryDark,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 19,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.37,
      color: AppColors.textPrimaryDark,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.41,
      color: AppColors.textPrimaryDark,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.33,
      color: AppColors.textPrimaryDark,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: 1.41,
      color: AppColors.textPrimaryDark,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.0,
      height: 1.47,
      color: AppColors.textPrimaryDark,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0,
      height: 1.38,
      color: AppColors.textSecondaryDark,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.33,
      color: AppColors.textSecondaryDark,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.0,
      height: 1.38,
      color: AppColors.textSecondaryDark,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0,
      height: 1.38,
      color: AppColors.textTertiaryDark,
    ),
  );

  // ─────────────────────────────────────────────
  // STYLES STANDALONE
  // ─────────────────────────────────────────────

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.33,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    height: 1.47,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.33,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.37,
  );

  // ─────────────────────────────────────────────
  // MODE DYSLEXIE
  // ─────────────────────────────────────────────

  static TextStyle toDyslexic(TextStyle style) {
    final fontSize = style.fontSize ?? 15;
    final height = style.height ?? _dyslexicMinHeight;

    var adjustedFontSize = fontSize;
    if (fontSize >= 36) {
      adjustedFontSize = fontSize * _dyslexicLargeTextScale;
    }

    var adjustedHeight = height;
    if (height < _dyslexicMinHeight) {
      adjustedHeight = _dyslexicMinHeight;
    }

    return style.copyWith(
      fontFamily: fontFamilyDyslexic,
      fontSize: adjustedFontSize,
      height: adjustedHeight,
      letterSpacing: _dyslexicLetterSpacing,
      wordSpacing: _dyslexicWordSpacing,
    );
  }

  static TextTheme toDyslexicTheme(TextTheme theme) {
    return TextTheme(

      displayLarge: _toDyslexicOrNull(theme.displayLarge),

      displayMedium: _toDyslexicOrNull(theme.displayMedium),

      displaySmall: _toDyslexicOrNull(theme.displaySmall),

      headlineLarge: _toDyslexicOrNull(theme.headlineLarge),

      headlineMedium: _toDyslexicOrNull(theme.headlineMedium),

      headlineSmall: _toDyslexicOrNull(theme.headlineSmall),

      titleLarge: _toDyslexicOrNull(theme.titleLarge),

      titleMedium: _toDyslexicOrNull(theme.titleMedium),

      titleSmall: _toDyslexicOrNull(theme.titleSmall),

      bodyLarge: _toDyslexicOrNull(theme.bodyLarge),

      bodyMedium: _toDyslexicOrNull(theme.bodyMedium),

      bodySmall: _toDyslexicOrNull(theme.bodySmall),

      labelLarge: _toDyslexicOrNull(theme.labelLarge),

      labelMedium: _toDyslexicOrNull(theme.labelMedium),

      labelSmall: _toDyslexicOrNull(theme.labelSmall),

    );
  }

  static TextStyle? _toDyslexicOrNull(TextStyle? style) {
    if (style == null) {
      return null;
    }
    return toDyslexic(style);
  }
}
