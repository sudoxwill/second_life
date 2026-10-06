import "package:flutter/material.dart" show Color, MaterialColor;

/// Palette SecondLife — vert pour agir, jaune pour gagner.
/// Constantes sans suffixe = mode clair, suffixe `Dark` = mode sombre.
class AppColors {
  const AppColors._();

  // ───────────────────────────────────────────────
  // BRAND
  // ───────────────────────────────────────────────

  static const Color supernova = Color(0xFFFFCD00);
  static const Color grassCourt = Color(0xFF008C45);
  static const Color jungleGreen = Color(0xFF13322B);
  static const Color springWhite = Color(0xFFF9F6ED);

  static const MaterialColor green = MaterialColor(0xFF007A3D, {
    50: Color(0xFFEEF8F1),
    100: Color(0xFFDDF2E4),
    200: Color(0xFFB4E4C4),
    300: Color(0xFF7BE8B0),
    400: Color(0xFF3DD68C),
    500: Color(0xFF008C45),
    600: Color(0xFF007A3D),
    700: Color(0xFF00622F),
    800: Color(0xFF005C2E),
    900: Color(0xFF123F2B),
  });

  // ───────────────────────────────────────────────
  // PRIMARY — Vert
  // ───────────────────────────────────────────────

  static const Color primary = Color(0xFF007A3D);
  static const Color primaryHover = Color(0xFF006B35);
  static const Color primaryPressed = Color(0xFF00622F);
  static const Color primarySubtle = Color(0xFFDDF2E4);
  static const Color primarySubtleBorder = Color(0xFFB4E4C4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimarySubtle = Color(0xFF005C2E);

  static const Color primaryDark = Color(0xFF3DD68C);
  static const Color primaryHoverDark = Color(0xFF36C47F);
  static const Color primaryPressedDark = Color(0xFF2FB574);
  static const Color primarySubtleDark = Color(0xFF123F2B);
  static const Color primarySubtleBorderDark = Color(0xFF1D5A3E);
  static const Color onPrimaryDark = Color(0xFF0B1F1A);
  static const Color onPrimarySubtleDark = Color(0xFF7BE8B0);

  // ───────────────────────────────────────────────
  // ACCENT — Jaune (crédits, récompenses)
  // ───────────────────────────────────────────────

  static const Color accent = Color(0xFFD4A800);
  static const Color onAccent = jungleGreen;
  static const Color accentSubtle = Color(0xFFFFF3C2);
  static const Color onAccentSubtle = Color(0xFF7A5A00);

  static const Color accentSubtleDark = Color(0xFF3A3000);
  static const Color onAccentSubtleDark = supernova;

  // ───────────────────────────────────────────────
  // TEXTE — Mode clair
  // ───────────────────────────────────────────────

  static const Color textPrimary = jungleGreen;
  static const Color textSecondary = Color(0xFF4E625A);
  static const Color textTertiary = Color(0xFF5B6E66);
  static const Color textDisabled = Color(0xFF9AA59F);
  static const Color textInverse = springWhite;

  // ───────────────────────────────────────────────
  // TEXTE — Mode sombre
  // ───────────────────────────────────────────────

  static const Color textPrimaryDark = springWhite;
  static const Color textSecondaryDark = Color(0xFFAFC2BA);
  static const Color textTertiaryDark = Color(0xFF93A89F);
  static const Color textDisabledDark = Color(0xFF4A6B62);
  static const Color textInverseDark = jungleGreen;

  // ───────────────────────────────────────────────
  // SURFACES — Mode clair
  // ───────────────────────────────────────────────

  static const Color surfacePage = Color(0xFFFCFAF7);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceRaised = Color(0xFFF4F0E4);
  static const Color surfaceSunken = Color(0xFFF0EBDD);
  static const Color surfaceInverse = jungleGreen;
  static const Color surfaceNav = Color(0xFFFFFFFF);

  // ───────────────────────────────────────────────
  // SURFACES — Mode sombre
  // ───────────────────────────────────────────────

  static const Color surfacePageDark = Color(0xFF131A18);
  static const Color surfaceCardDark = jungleGreen;
  static const Color surfaceSheetDark = Color(0xFF1C1C1E);
  static const Color surfaceRaisedDark = Color(0xFF1B4038);
  static const Color surfaceSunkenDark = Color(0xFF071511);
  static const Color surfaceInverseDark = springWhite;
  static const Color surfaceNavDark = jungleGreen;

  // ───────────────────────────────────────────────
  // BORDURES — Mode clair
  // ───────────────────────────────────────────────

  static const Color borderHairline = Color(0xFFEEE9DC);
  static const Color borderDefault = Color(0xFFE3DDCC);
  static const Color borderStrong = Color(0xFF76827C);
  static const Color borderFocus = jungleGreen;

  // ───────────────────────────────────────────────
  // BORDURES — Mode sombre
  // ───────────────────────────────────────────────

  static const Color borderHairlineDark = Color(0xFF1B3A33);
  static const Color borderDefaultDark = Color(0xFF24473E);
  static const Color borderStrongDark = Color(0xFF6B9187);
  static const Color borderFocusDark = supernova;

  // ───────────────────────────────────────────────
  // SÉMANTIQUE — Mode clair
  // ───────────────────────────────────────────────

  static const Color semanticSuccess = Color(0xFF00707A);
  static const Color semanticSuccessBg = Color(0xFFD6EFF1);
  static const Color semanticSuccessBorder = Color(0xFFB5E1E5);

  static const Color semanticWarning = Color(0xFF7A5A00);
  static const Color semanticWarningBg = Color(0xFFFFF3C2);
  static const Color semanticWarningBorder = Color(0xFFFFE58A);

  static const Color semanticError = Color(0xFFB42318);
  static const Color semanticErrorBg = Color(0xFFFBE3DF);
  static const Color semanticErrorBorder = Color(0xFFF5C4BC);

  static const Color semanticInfo = Color(0xFF2A5CA8);
  static const Color semanticInfoBg = Color(0xFFE0EAF8);
  static const Color semanticInfoBorder = Color(0xFFC3D5F0);

  static const Color semanticOffline = Color(0xFF5B6E66);

  // ───────────────────────────────────────────────
  // SÉMANTIQUE — Mode sombre
  // ───────────────────────────────────────────────

  static const Color semanticSuccessDark = Color(0xFF5DD3DD);
  static const Color semanticSuccessBgDark = Color(0xFF0F3A3F);
  static const Color semanticSuccessBorderDark = Color(0xFF1A5058);

  static const Color semanticWarningDark = supernova;
  static const Color semanticWarningBgDark = Color(0xFF3A3000);
  static const Color semanticWarningBorderDark = Color(0xFF574800);

  static const Color semanticErrorDark = Color(0xFFFF9580);
  static const Color semanticErrorBgDark = Color(0xFF4A1A14);
  static const Color semanticErrorBorderDark = Color(0xFF6B2A21);

  static const Color semanticInfoDark = Color(0xFF9CC0FF);
  static const Color semanticInfoBgDark = Color(0xFF1A2E4F);
  static const Color semanticInfoBorderDark = Color(0xFF28436E);

  static const Color semanticOfflineDark = Color(0xFF8FA59C);

  // ───────────────────────────────────────────────
  // MATÉRIAUX — chips de type de déchet
  // ───────────────────────────────────────────────

  static const Color materialPlastic = Color(0xFF1D4F8A);
  static const Color materialPlasticBg = Color(0xFFDCEBFA);
  static const Color materialPlasticDark = Color(0xFFA9CFF7);
  static const Color materialPlasticBgDark = Color(0xFF14304F);

  static const Color materialPaper = Color(0xFF6B4A12);
  static const Color materialPaperBg = Color(0xFFF3E6CC);
  static const Color materialPaperDark = Color(0xFFEBCF98);
  static const Color materialPaperBgDark = Color(0xFF3A2C12);

  static const Color materialGlass = Color(0xFF0D5E57);
  static const Color materialGlassBg = Color(0xFFD5F0EC);
  static const Color materialGlassDark = Color(0xFF8EDDD3);
  static const Color materialGlassBgDark = Color(0xFF0F3A36);

  static const Color materialMetal = Color(0xFF3E4744);
  static const Color materialMetalBg = Color(0xFFE4E7E6);
  static const Color materialMetalDark = Color(0xFFC9D1CE);
  static const Color materialMetalBgDark = Color(0xFF2A3230);

  static const Color materialEwaste = Color(0xFF8A1F47);
  static const Color materialEwasteBg = Color(0xFFF7DDE6);
  static const Color materialEwasteDark = Color(0xFFF4A9C4);
  static const Color materialEwasteBgDark = Color(0xFF45182A);

  static const Color materialOrganic = onPrimarySubtle;
  static const Color materialOrganicBg = primarySubtle;
  static const Color materialOrganicDark = onPrimarySubtleDark;
  static const Color materialOrganicBgDark = primarySubtleDark;

  // ───────────────────────────────────────────────
  // OMBRE FLOTTANTE
  // ───────────────────────────────────────────────

  static const Color shadowFloating = Color(0x1413322B);
  static const Color shadowFloatingDark = Color(0x80000000);

  // ───────────────────────────────────────────────
  // NEUTRES — gris verts
  // ───────────────────────────────────────────────

  static const Color neutral50 = Color(0xFFF9F6ED);
  static const Color neutral100 = Color(0xFFF0EBDD);
  static const Color neutral200 = Color(0xFFE3DDCC);
  static const Color neutral300 = Color(0xFFB9C3BE);
  static const Color neutral400 = Color(0xFF93A39C);
  static const Color neutral500 = Color(0xFF76827C);
  static const Color neutral600 = Color(0xFF4E625A);
  static const Color neutral700 = Color(0xFF3A4F47);
  static const Color neutral800 = Color(0xFF24473E);
  static const Color neutral900 = Color(0xFF13322B);
  static const Color neutral950 = Color(0xFF0B1F1A);
}
