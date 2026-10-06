import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "app_colors.dart";
import "app_spacing.dart";
import "app_text_styles.dart";

/// Thème global SecondLife, clair et sombre, avec police OpenDyslexic
/// activable via `useDyslexicFont`.
class AppTheme {
  const AppTheme._();

  static const String fontFamily = AppTextStyles.fontFamily;

  // ─────────────────────────────────────────────
  // SHAPES
  // ─────────────────────────────────────────────

  static const shapeLarge = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedXxl,
  );
  static const shapeMedium = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedMd,
  );
  static const shapeSmall = RoundedRectangleBorder(
    borderRadius: AppSpacing.roundedSm,
  );

  // ─────────────────────────────────────────────
  // COLORSCHEME — clair
  // ─────────────────────────────────────────────

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primarySubtle,
    onPrimaryContainer: AppColors.onPrimarySubtle,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    secondaryContainer: AppColors.accentSubtle,
    onSecondaryContainer: AppColors.onAccentSubtle,
    tertiary: AppColors.semanticInfo,
    onTertiary: AppColors.onPrimary,
    error: AppColors.semanticError,
    onError: AppColors.onPrimary,
    errorContainer: AppColors.semanticErrorBg,
    onErrorContainer: AppColors.semanticError,
    surface: AppColors.surfacePage,
    onSurface: AppColors.textPrimary,
    surfaceContainer: AppColors.surfaceCard,
    surfaceContainerHighest: AppColors.surfaceSunken,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.borderStrong,
    outlineVariant: AppColors.borderDefault,
    inverseSurface: AppColors.surfaceInverse,
    onInverseSurface: AppColors.textInverse,
    inversePrimary: AppColors.primaryDark,
    surfaceTint: Colors.transparent,
  );

  // ─────────────────────────────────────────────
  // COLORSCHEME — sombre
  // ─────────────────────────────────────────────

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark,
    onPrimary: AppColors.onPrimaryDark,
    primaryContainer: AppColors.primarySubtleDark,
    onPrimaryContainer: AppColors.onPrimarySubtleDark,
    secondary: AppColors.accent,
    onSecondary: AppColors.onAccent,
    secondaryContainer: AppColors.accentSubtleDark,
    onSecondaryContainer: AppColors.onAccentSubtleDark,
    tertiary: AppColors.semanticInfoDark,
    onTertiary: AppColors.surfacePageDark,
    error: AppColors.semanticErrorDark,
    onError: AppColors.surfacePageDark,
    errorContainer: AppColors.semanticErrorBgDark,
    onErrorContainer: AppColors.semanticErrorDark,
    surface: AppColors.surfacePageDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainer: AppColors.surfaceCardDark,
    surfaceContainerHighest: AppColors.surfaceSunkenDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: AppColors.borderStrongDark,
    outlineVariant: AppColors.borderDefaultDark,
    inverseSurface: AppColors.surfaceInverseDark,
    onInverseSurface: AppColors.textInverseDark,
    inversePrimary: AppColors.primary,
    surfaceTint: Colors.transparent,
  );

  // ─────────────────────────────────────────────
  // THÈMES PAR DÉFAUT
  // ─────────────────────────────────────────────

  static final ThemeData lightTheme = light();
  static final ThemeData darkTheme = dark();

  // ─────────────────────────────────────────────
  // POLICE
  // ─────────────────────────────────────────────

  static TextTheme _textTheme(TextTheme base, bool useDyslexicFont) {
    if (useDyslexicFont) {
      return AppTextStyles.toDyslexicTheme(base);
    }
    return base;
  }

  static TextStyle _style(TextStyle base, bool useDyslexicFont) {
    if (useDyslexicFont) {
      return AppTextStyles.toDyslexic(base);
    }
    return base;
  }

  static String _fontFamily(bool useDyslexicFont) {
    if (useDyslexicFont) {
      return AppTextStyles.fontFamilyDyslexic;
    }
    return fontFamily;
  }

  // ─────────────────────────────────────────────
  // LIGHT THEME
  // ─────────────────────────────────────────────

  static ThemeData light({bool useDyslexicFont = false}) {
    final textTheme = _textTheme(
      AppTextStyles.lightTextTheme,
      useDyslexicFont,
    );
    final buttonText = _style(
      AppTextStyles.buttonText,
      useDyslexicFont,
    );
    final inputText = _style(
      AppTextStyles.inputText,
      useDyslexicFont,
    );
    final inputLabel = _style(
      AppTextStyles.inputLabel,
      useDyslexicFont,
    );
    final appBarTitle = _style(
      AppTextStyles.appBarTitle,
      useDyslexicFont,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily(useDyslexicFont),
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.surface,
      canvasColor: lightColorScheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,

      textTheme: textTheme,

      // ─── AppBar ─────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: AppSpacing.elevationNone,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight: AppSpacing.appBarHeight,
        titleTextStyle: appBarTitle.copyWith(color: lightColorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // ─── Buttons ────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          disabledBackgroundColor: AppColors.surfaceSunken,
          disabledForegroundColor: AppColors.textSecondary,
          elevation: AppSpacing.elevationNone,
          minimumSize: const Size(
            AppSpacing.tapTargetMin,
            AppSpacing.buttonHeightLg,
          ),
          shape: shapeMedium,
          padding: AppSpacing.buttonPaddingLg,
          textStyle: buttonText,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          side: BorderSide(
            color: lightColorScheme.primary,
            width: AppSpacing.borderWidthThick,
          ),
          minimumSize: const Size(
            AppSpacing.tapTargetMin,
            AppSpacing.buttonHeightLg,
          ),
          shape: shapeMedium,
          padding: AppSpacing.buttonPaddingLg,
          textStyle: buttonText,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          minimumSize: const Size(
            AppSpacing.tapTargetMin,
            AppSpacing.tapTargetMin,
          ),
          shape: shapeMedium,
          textStyle: buttonText,
        ),
      ),

      // ─── Input Decoration (TextField) ───────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSunken,
        contentPadding: AppSpacing.inputPadding,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: lightColorScheme.outline,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: lightColorScheme.outline,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: lightColorScheme.primary,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: lightColorScheme.error,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: lightColorScheme.error,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        labelStyle: inputLabel.copyWith(color: lightColorScheme.onSurface),
        floatingLabelStyle: inputLabel.copyWith(
          color: lightColorScheme.onSurface,
        ),
        hintStyle: inputText.copyWith(color: AppColors.textTertiary),
        errorMaxLines: 3,
        helperMaxLines: 3,
      ),

      // ─── Card ───────────────────────────────────────
      cardTheme: CardThemeData(
        color: lightColorScheme.surfaceContainer,
        elevation: AppSpacing.elevationNone,
        shape: shapeMedium,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shadowColor: AppColors.shadowFloating,
        surfaceTintColor: Colors.transparent,
      ),

      // ─── FloatingActionButton ───────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: AppSpacing.elevationMd,
        shape: const CircleBorder(),
      ),

      // ─── Bottom Navigation Bar ──────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceNav,
        elevation: AppSpacing.elevationLg,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: lightColorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
      ),

      // ─── Dialog ─────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: lightColorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: shapeLarge,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // ─── Bottom sheet ───────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceCard,
        surfaceTintColor: Colors.transparent,
        elevation: AppSpacing.elevationNone,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedTopXl),
      ),

      // ─── SnackBar ───────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightColorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: lightColorScheme.onInverseSurface,
        ),
        actionTextColor: lightColorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: shapeSmall,
      ),

      // ─── Chip ───────────────────────────────────────
      chipTheme: ChipThemeData(
        selectedColor: lightColorScheme.primaryContainer,
        checkmarkColor: lightColorScheme.onPrimaryContainer,
        labelStyle: textTheme.labelMedium,
        shape: const StadiumBorder(),
        side: BorderSide(color: lightColorScheme.outline),
      ),

      // ─── Icon ───────────────────────────────────────
      iconTheme: IconThemeData(
        color: lightColorScheme.onSurfaceVariant,
        size: AppSpacing.iconLg,
      ),

      // ─── Progress ───────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: lightColorScheme.primary,
        linearTrackColor: lightColorScheme.primaryContainer,
        circularTrackColor: lightColorScheme.primaryContainer,
      ),

      // ─── Divider ────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: lightColorScheme.outlineVariant,
        thickness: AppSpacing.dividerThickness,
        space: AppSpacing.dividerThickness,
      ),

      // ─── Switch ─────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.onPrimary;
          }
          return lightColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return Colors.transparent;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return lightColorScheme.outline;
        }),
      ),

      // ─── Checkbox ───────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(lightColorScheme.onPrimary),
        side: BorderSide(
          color: lightColorScheme.outline,
          width: AppSpacing.borderWidthThick,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedXs,
        ),
      ),

      // ─── Radio ──────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return lightColorScheme.primary;
          }
          return lightColorScheme.outline;
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DARK THEME
  // ─────────────────────────────────────────────

  static ThemeData dark({bool useDyslexicFont = false}) {
    final textTheme = _textTheme(
      AppTextStyles.darkTextTheme,
      useDyslexicFont,
    );
    final buttonText = _style(
      AppTextStyles.buttonText,
      useDyslexicFont,
    );
    final inputText = _style(
      AppTextStyles.inputText,
      useDyslexicFont,
    );
    final inputLabel = _style(
      AppTextStyles.inputLabel,
      useDyslexicFont,
    );
    final appBarTitle = _style(
      AppTextStyles.appBarTitle,
      useDyslexicFont,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily(useDyslexicFont),
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.surface,
      canvasColor: darkColorScheme.surface,
      materialTapTargetSize: MaterialTapTargetSize.padded,

      textTheme: textTheme,

      // ─── AppBar ─────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: AppSpacing.elevationNone,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight: AppSpacing.appBarHeight,
        titleTextStyle: appBarTitle.copyWith(color: darkColorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ─── Buttons ────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          disabledBackgroundColor: AppColors.surfaceSunkenDark,
          disabledForegroundColor: AppColors.textSecondaryDark,
          elevation: AppSpacing.elevationNone,
          minimumSize: const Size(
            AppSpacing.tapTargetMin,
            AppSpacing.buttonHeightLg,
          ),
          shape: shapeMedium,
          padding: AppSpacing.buttonPaddingLg,
          textStyle: buttonText,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          side: BorderSide(
            color: darkColorScheme.primary,
            width: AppSpacing.borderWidthThick,
          ),
          minimumSize: const Size(
            AppSpacing.tapTargetMin,
            AppSpacing.buttonHeightLg,
          ),
          shape: shapeMedium,
          padding: AppSpacing.buttonPaddingLg,
          textStyle: buttonText,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          minimumSize: const Size(
            AppSpacing.tapTargetMin,
            AppSpacing.tapTargetMin,
          ),
          shape: shapeMedium,
          textStyle: buttonText,
        ),
      ),

      // ─── Input Decoration (TextField) ───────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceSunkenDark,
        contentPadding: AppSpacing.inputPadding,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: darkColorScheme.outline,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: darkColorScheme.outline,
            width: AppSpacing.borderWidthMedium,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: darkColorScheme.primary,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: darkColorScheme.error,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.roundedSm,
          borderSide: BorderSide(
            color: darkColorScheme.error,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        labelStyle: inputLabel.copyWith(color: darkColorScheme.onSurface),
        floatingLabelStyle: inputLabel.copyWith(
          color: darkColorScheme.onSurface,
        ),
        hintStyle: inputText.copyWith(color: AppColors.textTertiaryDark),
        errorMaxLines: 3,
        helperMaxLines: 3,
      ),

      // ─── Card ───────────────────────────────────────
      cardTheme: CardThemeData(
        color: darkColorScheme.surfaceContainer,
        elevation: AppSpacing.elevationNone,
        shape: shapeMedium,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        shadowColor: AppColors.shadowFloatingDark,
        surfaceTintColor: Colors.transparent,
      ),

      // ─── FloatingActionButton ───────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: AppSpacing.elevationMd,
        shape: const CircleBorder(),
      ),

      // ─── Bottom Navigation Bar ──────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceNavDark,
        elevation: AppSpacing.elevationLg,
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: darkColorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelMedium,
        unselectedLabelStyle: textTheme.labelSmall,
        showUnselectedLabels: true,
      ),

      // ─── Dialog ─────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: darkColorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: shapeLarge,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // ─── Bottom sheet ───────────────────────────────
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceSheetDark,
        surfaceTintColor: Colors.transparent,
        elevation: AppSpacing.elevationNone,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.roundedTopXl),
      ),

      // ─── SnackBar ───────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkColorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: darkColorScheme.onInverseSurface,
        ),
        actionTextColor: darkColorScheme.inversePrimary,
        behavior: SnackBarBehavior.floating,
        shape: shapeSmall,
      ),

      // ─── Chip ───────────────────────────────────────
      chipTheme: ChipThemeData(
        selectedColor: darkColorScheme.primaryContainer,
        checkmarkColor: darkColorScheme.onPrimaryContainer,
        labelStyle: textTheme.labelMedium,
        shape: const StadiumBorder(),
        side: BorderSide(color: darkColorScheme.outline),
      ),

      // ─── Icon ───────────────────────────────────────
      iconTheme: IconThemeData(
        color: darkColorScheme.onSurfaceVariant,
        size: AppSpacing.iconLg,
      ),

      // ─── Progress ───────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: darkColorScheme.primary,
        linearTrackColor: darkColorScheme.primaryContainer,
        circularTrackColor: darkColorScheme.primaryContainer,
      ),

      // ─── Divider ────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: darkColorScheme.outlineVariant,
        thickness: AppSpacing.dividerThickness,
        space: AppSpacing.dividerThickness,
      ),

      // ─── Switch ─────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.onPrimary;
          }
          return darkColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primary;
          }
          return Colors.transparent;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primary;
          }
          return darkColorScheme.outline;
        }),
      ),

      // ─── Checkbox ───────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(darkColorScheme.onPrimary),
        side: BorderSide(
          color: darkColorScheme.outline,
          width: AppSpacing.borderWidthThick,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedXs,
        ),
      ),

      // ─── Radio ──────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkColorScheme.primary;
          }
          return darkColorScheme.outline;
        }),
      ),
    );
  }
}
