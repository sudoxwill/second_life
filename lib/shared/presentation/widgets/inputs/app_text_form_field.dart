import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../../../core/theme/app_spacing.dart";

class AppTextFormField extends StatelessWidget {
  /// Creates a custom text form field that follows the project design system.
  const AppTextFormField({
    super.key,
    this.labelText = "",
    this.prefixIconData,
    this.prefixIcon,
    this.suffixIconData,
    this.suffixIcon,
    this.onTap,
    this.focusNode,
    this.labelColor,
    this.borderSideColor,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.hintText,
    this.inputFormatters,
    this.controller,
    this.textFontSize,
    this.style,
    this.readOnly = false,
    this.validatorFunction,
    this.contentPadding,
    this.padding = EdgeInsets.zero,
    this.autoFocus = false,
    this.shouldValidate = true,
    this.filled,
    this.bold = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.onFieldSubmitted,
    this.prefixIconOnClick,
    this.prefixWidget,
    this.suffixWidget,
    this.suffixIconOnClick,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.isRequired = false,
    this.visible = true,
    this.textAlign = TextAlign.left,
    this.onEditingComplete,
    this.border,
    this.focusBorder,
    this.initialValue,
    this.obscureText = false,
    this.height = AppSpacing.inputHeightLg,
    this.fillColor,
    this.floatingLabelBehavior,
  });

  final void Function()? onEditingComplete;
  final IconData? prefixIconData;
  final Widget? prefixIcon;
  final IconData? suffixIconData;
  final Widget? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final bool? filled;
  final Color? fillColor;
  final bool shouldValidate;
  final bool bold;
  final String labelText;
  final String? hintText;
  final String? prefixText;
  final Color? labelColor;
  final Color? borderSideColor;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? style;
  final double? textFontSize;
  final bool autoFocus;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;

  /// Optional minimum height for the field.
  /// If null, it will be determined by content.
  final double? height;
  final String? initialValue;
  final void Function()? prefixIconOnClick;
  final void Function()? suffixIconOnClick;
  final String? Function(String?)? validatorFunction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final void Function(String?)? onChanged;
  final InputBorder? border;
  final InputBorder? focusBorder;
  final bool isRequired;
  final bool visible;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!visible) return const SizedBox.shrink();

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height ?? 0),
        child: TextFormField(
          obscureText: obscureText,
          initialValue: initialValue,
          enabled: enabled,
          autofocus: autoFocus,
          maxLines: maxLines,
          readOnly: readOnly,
          cursorColor: colorScheme.primary,
          validator: (value) {
            if (!shouldValidate) return null;
            if (isRequired && (value ?? "").trim().isEmpty) {
              return "L'attribut $labelText est requis.";
            }
            return validatorFunction?.call(value);
          },
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          textAlign: textAlign,
          style:
              style ??
              theme.textTheme.bodyLarge?.copyWith(
                fontWeight: bold ? FontWeight.bold : null,
                fontSize: textFontSize,
                color: enabled ? null : theme.disabledColor,
              ),
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          onTap: onTap,
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: const InputDecoration()
              .applyDefaults(theme.inputDecorationTheme)
              .copyWith(
                contentPadding: contentPadding,
                prefixIcon:
                    prefixIcon ??
                    (prefixIconData == null
                        ? null
                        : IconButton(
                            onPressed: prefixIconOnClick,
                            icon: Icon(prefixIconData, size: AppSpacing.iconMd),
                          )),
                suffixIcon:
                    suffixIcon ??
                    (suffixIconData != null
                        ? IconButton(
                            onPressed: suffixIconOnClick,
                            icon: Icon(suffixIconData, size: AppSpacing.iconMd),
                          )
                        : null),
                filled: filled,
                fillColor: fillColor,
                hintText: hintText,
                labelStyle: theme.textTheme.labelLarge!.copyWith(
                  color:
                      labelColor ??
                      (enabled
                          ? theme.inputDecorationTheme.labelStyle?.color!
                                .withValues(alpha: 0.75)
                          : theme.disabledColor),
                ),
                alignLabelWithHint: maxLines != null && maxLines! > 1,
                isCollapsed: false, // Better alignment with custom themes
                labelText: labelText.isNotEmpty
                    ? "$labelText${isRequired ? " *" : ""}"
                    : null,
                suffix: suffixWidget,
                prefixText: prefixText,
                prefix: prefixWidget,
                floatingLabelBehavior: floatingLabelBehavior,
                enabledBorder: border,
                border: border,
                focusedBorder: focusBorder,
              ),
        ),
      ),
    );
  }
}
