import "package:flutter/material.dart";

import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";

/// Séparateur horizontal, optionnellement traversé par un label ou un widget.
///
/// Par défaut : hairline neutre — la couleur peut être surchargée via [color].
class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.color,
    this.thickness = AppSpacing.dividerThickness,
    this.height = AppSpacing.dividerThickness,
    this.label = "",
    this.textColor,
    this.indent = AppSpacing.sm,
    this.endIndent = AppSpacing.sm,
    this.margin = AppSpacing.insetVSm,
    this.style,
    this.child,
    this.textPosition = 50,
  });

  final Color? textColor;
  final Widget? child;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;
  final double height;
  final String? label;
  final TextStyle? style;
  final EdgeInsetsGeometry margin;
  final double textPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedColor =
        color ??
            (theme.brightness == Brightness.dark
                ? AppColors.neutral700
                : AppColors.neutral200);

    final adjusted = textPosition.clamp(0, 100);
    final leftFlex = adjusted.round();
    final rightFlex = (100 - adjusted).round();

    final hasLabel = child != null || (label != null && label!.isNotEmpty);

    return Container(
      margin: margin,
      child: hasLabel
          ? Row(
        children: [
          Expanded(
            flex: leftFlex,
            child: Divider(
              thickness: thickness,
              color: resolvedColor,
              indent: indent,
              endIndent: 0,
              height: height,
            ),
          ),
          Padding(
            padding: AppSpacing.insetHSm,
            child:
            child ??
                Text(
                  label!,
                  style:
                  style ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: textColor ?? resolvedColor,
                      ),
                ),
          ),
          Expanded(
            flex: rightFlex,
            child: Divider(
              thickness: thickness,
              color: resolvedColor,
              indent: 0,
              endIndent: endIndent,
              height: height,
            ),
          ),
        ],
      )
          : Divider(
        thickness: thickness,
        color: resolvedColor,
        indent: indent,
        endIndent: endIndent,
        height: height,
      ),
    );
  }
}
