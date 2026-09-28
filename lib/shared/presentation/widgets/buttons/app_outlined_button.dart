import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

/// A customizable outlined button widget.
///
/// This widget provides a flexible way to create outlined buttons with various
/// properties such as text, style, background color, size, margin, loading
/// indicator, and enabled/disabled states.
class AppOutlinedButton extends StatelessWidget {
  /// Creates a [AppOutlinedButton].
  ///
  /// The [onPressed] callback must not be null.
  ///
  /// The [margin] property defaults to `EdgeInsets.symmetric(vertical: 5,
  /// horizontal: 5)`.
  /// The [isLoading] property defaults to `false`.
  /// The [enabled] property defaults to `true`.
  /// The [elevation] property defaults to `0`.
  ///
  /// The [text] and [child] properties are mutually exclusive. If both are
  /// provided, [child] takes precedence. If neither is provided, an empty
  /// text widget is rendered.
  ///
  /// The [style] and [textColor] properties allow customization of the text
  /// within the button. If not provided, the default text style is used
  /// from the theme.
  ///
  const AppOutlinedButton({
    required this.onPressed,
    super.key,
    this.text,
    this.style,
    this.backgroundColor = Colors.transparent,
    this.borderColor,
    this.borderWidth = AppSpacing.borderWidthBase,
    this.border,
    this.textColor,
    this.buttonSize,
    this.buttonMaxSize,
    this.buttonMinSize,
    this.child,
    this.iconAlignment,
    this.margin = AppSpacing.insetVXs,
    this.isLoading = false,
    this.enabled = true,
    this.elevation = AppSpacing.elevationNone,
    this.borderRadius = AppSpacing.radiusXl,
    this.icon,
    this.textAlign = .center,
  });

  /// The callback that is called when the button is tapped.
  final void Function()? onPressed;

  /// The background color of the button.
  final Color backgroundColor;

  /// The icon alignment of the button.
  final IconAlignment? iconAlignment;

  /// The border color of the button.
  final Color? borderColor;

  /// The border width of the button.
  final double borderWidth;

  /// A fully-formed [BorderSide]. Takes precedence over [borderColor] and
  /// [borderWidth] when provided.
  final BorderSide? border;

  /// The size of the button.
  final Size? buttonSize;

  /// The max size of the button.
  final Size? buttonMaxSize;

  /// The min size of the button.
  final Size? buttonMinSize;

  /// The child widget to display inside the button.
  final Widget? child;

  /// An optional icon to display alongside the text.
  final Widget? icon;

  /// The elevation of the button.
  final double? elevation;

  /// Whether the button is enabled.
  final bool enabled;

  /// Whether to show a loading indicator.
  final bool isLoading;

  /// The margin around the button.
  final EdgeInsetsGeometry? margin;

  /// The text style of the button's text.
  final TextStyle? style;

  /// The button text
  final String? text;

  /// The button text color
  final Color? textColor;

  /// The text alignment
  final TextAlign textAlign;

  /// The border radius of the button.
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isInteractive = enabled && !isLoading;

    final effectiveContentColor = enabled
        ? (textColor ?? colorScheme.primary)
        : theme.disabledColor;
    final effectiveBorderSide =
        border ??
        BorderSide(
          color: enabled
              ? (borderColor ?? colorScheme.primary)
              : theme.disabledColor,
          width: borderWidth,
        );

    final buttonChild =
        child ??
        Text(
          text ?? "",
          key: text != null ? ValueKey(text) : null,
          textAlign: textAlign,
          style:
              style ??
              textTheme.titleMedium!.copyWith(
                color: effectiveContentColor,
                fontWeight: FontWeight.bold,
              ),
        );
    final buttonStyle = OutlinedButton.styleFrom(
      elevation: elevation,
      backgroundColor: backgroundColor,
      disabledBackgroundColor: backgroundColor,
      foregroundColor: effectiveContentColor,
      disabledForegroundColor: effectiveContentColor,
      side: effectiveBorderSide,
      padding: AppSpacing.buttonPaddingSm,
      fixedSize:
          buttonSize ??
          Size(
            MediaQuery.sizeOf(context).width * 0.95,
            AppSpacing.buttonHeightLg,
          ),
      maximumSize: buttonMaxSize,
      minimumSize: buttonMinSize,
      // textStyle: AppTextStyles.buttonText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
    final onPressAction = isInteractive ? onPressed : null;
    final finalChild = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isLoading
          ? SizedBox(
              key: const ValueKey("loading"),
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: effectiveContentColor,
                strokeWidth: 2.5,
              ),
            )
          : KeyedSubtree(
              key: ValueKey(text ?? child.hashCode),
              child: buttonChild,
            ),
    );
    return Container(
      margin: margin,
      child: icon == null
          ? OutlinedButton(
              style: buttonStyle,
              onPressed: onPressAction,
              child: finalChild,
            )
          : OutlinedButton.icon(
              style: buttonStyle,
              onPressed: onPressAction,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? const SizedBox.shrink(key: ValueKey("icon_loading"))
                    : KeyedSubtree(key: ValueKey(icon.hashCode), child: icon!),
              ),
              label: finalChild,
              iconAlignment: iconAlignment,
            ),
    );
  }
}
