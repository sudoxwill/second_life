import "package:flutter/material.dart";

import "app_colors.dart";

/// Espacements, rayons, tailles, durées et ombres SecondLife (grille de 4px).
class AppSpacing {
  AppSpacing._();

  // ─────────────────────────────────────────────
  // BASE UNIT
  // ─────────────────────────────────────────────

  static const double unit = 4.0;

  // ─────────────────────────────────────────────
  // SPACING SCALE
  // ─────────────────────────────────────────────

  static const double xs = unit * 1;
  static const double sm = unit * 2;
  static const double md = unit * 3;
  static const double lg = unit * 4;
  static const double xl = unit * 5;
  static const double xxl = unit * 6;
  static const double xxxl = unit * 8;
  static const double huge = unit * 10;
  static const double mega = unit * 12;
  static const double giga = unit * 14;
  static const double tera = unit * 16;
  static const double peta = unit * 18;
  static const double exa = unit * 20;
  static const double zetta = unit * 22;
  static const double yotta = unit * 24;

  static const double bottomScrollablePadding = 96.0;

  static const double sectionLabelGap = sm;

  // ─────────────────────────────────────────────
  // BORDER WIDTH
  // ─────────────────────────────────────────────

  static const double borderWidthThin = 0.5;
  static const double borderWidthBase = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;

  // ─────────────────────────────────────────────
  // BORDER RADIUS — doubles
  // ─────────────────────────────────────────────

  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 14.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusXxxl = 30.0;
  static const double radiusFull = 999.0;

  // ─────────────────────────────────────────────
  // BORDER RADIUS — objets prêts à l'emploi
  // ─────────────────────────────────────────────

  static const BorderRadius roundedXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius roundedSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius roundedMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius roundedLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius roundedXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius roundedXxl = BorderRadius.all(
    Radius.circular(radiusXxl),
  );
  static const BorderRadius roundedXxxl = BorderRadius.all(
    Radius.circular(radiusXxxl),
  );
  static const BorderRadius roundedFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  static const BorderRadius roundedTopLg = BorderRadius.only(
    topLeft: Radius.circular(radiusLg),
    topRight: Radius.circular(radiusLg),
  );
  static const BorderRadius roundedTopXl = BorderRadius.only(
    topLeft: Radius.circular(radiusXl),
    topRight: Radius.circular(radiusXl),
  );
  static const BorderRadius roundedBottomLg = BorderRadius.only(
    bottomLeft: Radius.circular(radiusLg),
    bottomRight: Radius.circular(radiusLg),
  );
  static const BorderRadius roundedBottomXl = BorderRadius.only(
    bottomLeft: Radius.circular(radiusXl),
    bottomRight: Radius.circular(radiusXl),
  );

  // ─────────────────────────────────────────────
  // EDGE INSETS — all sides
  // ─────────────────────────────────────────────

  static const EdgeInsets insetZero = EdgeInsets.zero;
  static const EdgeInsets insetXs = EdgeInsets.all(xs);
  static const EdgeInsets insetSm = EdgeInsets.all(sm);
  static const EdgeInsets insetMd = EdgeInsets.all(md);
  static const EdgeInsets insetLg = EdgeInsets.all(lg);
  static const EdgeInsets insetXl = EdgeInsets.all(xl);
  static const EdgeInsets insetXxl = EdgeInsets.all(xxl);
  static const EdgeInsets insetXxxl = EdgeInsets.all(xxxl);
  static EdgeInsets insetX(double x) => EdgeInsets.all(x);

  // ─────────────────────────────────────────────
  // EDGE INSETS — horizontal
  // ─────────────────────────────────────────────

  static const EdgeInsets insetHXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets insetHSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets insetHMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets insetHLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets insetHXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets insetHXxl = EdgeInsets.symmetric(horizontal: xxl);
  static EdgeInsets insetHX(double x) => EdgeInsets.symmetric(horizontal: x);

  // ─────────────────────────────────────────────
  // EDGE INSETS — vertical
  // ─────────────────────────────────────────────

  static const EdgeInsets insetVXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets insetVSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets insetVMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets insetVLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets insetVXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets insetVXxl = EdgeInsets.symmetric(vertical: xxl);
  static EdgeInsets insetVX(double x) => EdgeInsets.symmetric(vertical: x);

  // ─────────────────────────────────────────────
  // EDGE INSETS — combinaisons communes
  // ─────────────────────────────────────────────

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets screenPaddingLg = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: xl,
  );
  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(
    horizontal: lg,
  );
  static const EdgeInsets screenPaddingV = EdgeInsets.symmetric(vertical: md);

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
  static const EdgeInsets cardPaddingUltraCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets buttonPaddingMd = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );
  static const EdgeInsets buttonPaddingSm = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const EdgeInsets buttonPaddingLg = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: lg,
  );

  static const EdgeInsets dialogPadding = EdgeInsets.all(xxl);

  static const EdgeInsets bottomSheetPadding = EdgeInsets.fromLTRB(
    lg,
    xxl,
    lg,
    lg,
  );

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: 14,
  );

  static const EdgeInsets inputPaddingSm = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: sm - 2,
  );

  static const EdgeInsets listPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsets listItemPaddingSm = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets listItemPaddingXs = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );

  // ─────────────────────────────────────────────
  // GAPS (SizedBox)
  // ─────────────────────────────────────────────

  // Horizontaux
  static const Widget gapHXs = SizedBox(width: xs);
  static const Widget gapHSm = SizedBox(width: sm);
  static const Widget gapHMd = SizedBox(width: md);
  static const Widget gapHLg = SizedBox(width: lg);
  static const Widget gapHXl = SizedBox(width: xl);
  static const Widget gapHXxl = SizedBox(width: xxl);
  static const Widget gapHXxxl = SizedBox(width: xxxl);

  // Verticaux
  static const Widget gapVXs = SizedBox(height: xs);
  static const Widget gapVSm = SizedBox(height: sm);
  static const Widget gapVMd = SizedBox(height: md);
  static const Widget gapVLg = SizedBox(height: lg);
  static const Widget gapVXl = SizedBox(height: xl);
  static const Widget gapVXxl = SizedBox(height: xxl);
  static const Widget gapVXxxl = SizedBox(height: xxxl);
  static const Widget gapVHuge = SizedBox(height: huge);
  static const Widget gapVMega = SizedBox(height: mega);

  // ─────────────────────────────────────────────
  // ICÔNES
  // ─────────────────────────────────────────────

  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconMxl = 28.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;
  static const double iconXxxl = 64.0;
  static const double iconNav = 22.0;

  // ─────────────────────────────────────────────
  // AVATARS
  // ─────────────────────────────────────────────

  static const double avatarXs = 24.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 40.0;
  static const double avatarLg = 56.0;
  static const double avatarXl = 80.0;

  // ─────────────────────────────────────────────
  // COMPOSANTS
  // ─────────────────────────────────────────────

  static const double tapTargetMin = 48.0;

  // Boutons
  static const double buttonHeightSm = 40.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 52.0;

  // Inputs
  static const double inputHeightSm = 40.0;
  static const double inputHeightMd = 48.0;
  static const double inputHeightLg = 56.0;
  static const double inputHeight = 52.0;

  // Chip
  static const double chipHeight = 36.0;

  // App bar
  static const double appBarHeight = 56.0;
  static const double toolbarHeight = 56.0;

  // Bottom navigation
  static const double bottomNavHeight = 72.0;
  static const double bottomNavIconSize = iconLg;

  // FAB
  static const double fabSize = 56.0;

  // Divider
  static const double dividerThickness = 1.0;
  static const double dividerIndent = sm;

  // Sections
  static const double sectionSpacing = xxl;
  static const double sectionSpacingLg = xxxl;

  // ─────────────────────────────────────────────
  // CONTRAINTES DE CONTENU
  // ─────────────────────────────────────────────

  static const double maxContentWidth = 1200.0;
  static const double maxFormWidth = 480.0;
  static const double maxDialogWidth = 560.0;

  static const BoxConstraints constraintsForm = BoxConstraints(
    maxWidth: maxFormWidth,
  );
  static const BoxConstraints constraintsDialog = BoxConstraints(
    maxWidth: maxDialogWidth,
  );
  static const BoxConstraints constraintsContent = BoxConstraints(
    maxWidth: maxContentWidth,
  );

  // ─────────────────────────────────────────────
  // ANIMATIONS — DURÉES
  // ─────────────────────────────────────────────

  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationBase = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 450);
  static const Duration durationXSlow = Duration(milliseconds: 600);
  static const Duration durationXXSlow = Duration(milliseconds: 800);
  static const Duration durationMegaSlow = Duration(milliseconds: 1000);
  static const Duration durationGigaSlow = Duration(milliseconds: 1200);
  static const Duration durationTeraSlow = Duration(milliseconds: 1400);

  // ─────────────────────────────────────────────
  // ANIMATIONS — COURBES
  // ─────────────────────────────────────────────

  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveEnter = Curves.easeOutCubic;
  static const Curve curveExit = Curves.easeIn;
  static const Curve curveBounce = Curves.easeOutBack;

  // ─────────────────────────────────────────────
  // ÉLÉVATIONS / OMBRES
  // ─────────────────────────────────────────────

  static const double elevationNone = 0.0;
  static const double elevationXs = 1.0;
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;
  static const double elevationXl = 16.0;

  static const List<BoxShadow> shadowFloating = [
    BoxShadow(
      color: AppColors.shadowFloating,
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowFloatingDark = [
    BoxShadow(
      color: AppColors.shadowFloatingDark,
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevationShadowSm = [
    BoxShadow(
      color: Color(0x0D13322B),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0A13322B),
      blurRadius: 6,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevationShadowSmDark = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> elevationShadowMd = [
    BoxShadow(
      color: Color(0x1213322B),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0D13322B),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevationShadowMdDark = [
    BoxShadow(
      color: Color(0x59000000),
      blurRadius: 14,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> elevationShadowLg = [
    BoxShadow(
      color: Color(0x1713322B),
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x1213322B),
      blurRadius: 36,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> elevationShadowLgDark = [
    BoxShadow(
      color: Color(0x6B000000),
      blurRadius: 28,
      offset: Offset(0, 8),
    ),
  ];
}
