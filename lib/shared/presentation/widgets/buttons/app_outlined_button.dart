import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

class AppOutlinedButton extends StatelessWidget {
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
    this.borderRadius = AppSpacing.radiusMd,
    this.icon,
    this.textAlign = .center,
  });

  final void Function()? onPressed;

  final Color backgroundColor;

  final IconAlignment? iconAlignment;

  final Color? borderColor;

  final double borderWidth;

  final BorderSide? border;

  final Size? buttonSize;

  final Size? buttonMaxSize;

  final Size? buttonMinSize;

  final Widget? child;

  final Widget? icon;

  final double? elevation;

  final bool enabled;

  final bool isLoading;

  final EdgeInsetsGeometry? margin;

  final TextStyle? style;

  final String? text;

  final Color? textColor;

  final TextAlign textAlign;

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
