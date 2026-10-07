import "package:flutter/material.dart";

import "../../../../core/theme/app_spacing.dart";

class AppSegmentedButton<T> extends StatefulWidget {
  const AppSegmentedButton({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.indicatorColor,
    this.indicatorBorderRadius,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.padding = AppSpacing.insetXs,
    this.height = AppSpacing.buttonHeightMd,
    this.indicatorBoxShadow,
    this.animationDuration = AppSpacing.durationBase,
    super.key,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T>) onSelectionChanged;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;

  // Style properties
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? indicatorColor;
  final BorderRadiusGeometry? indicatorBorderRadius;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final EdgeInsetsGeometry padding;
  final double height;
  final List<BoxShadow>? indicatorBoxShadow;
  final Duration animationDuration;

  @override
  State<AppSegmentedButton<T>> createState() =>
      _AppSegmentedButtonState<T>();
}

class _AppSegmentedButtonState<T> extends State<AppSegmentedButton<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _selectedIndex = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppSpacing.curveDefault,
      ),
    );
    _updateSelectedIndex();
  }

  @override
  void didUpdateWidget(AppSegmentedButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _previousIndex = _selectedIndex;
      _updateSelectedIndex();
    }
    if (oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
  }

  void _updateSelectedIndex() {
    if (widget.selected.isNotEmpty) {
      final selectedValue = widget.selected.first;
      _selectedIndex = widget.segments.indexWhere(
        (segment) => segment.value == selectedValue,
      );
      if (_selectedIndex == -1) _selectedIndex = 0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    final segment = widget.segments[index];
    final newSelection = <T>{segment.value};

    if (!widget.multiSelectionEnabled) {
      if (widget.selected.contains(segment.value) &&
          !widget.emptySelectionAllowed) {
        return;
      }
    }

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onSelectionChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Default values
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.onSurface.withValues(alpha: 0.05);
    final effectiveBorderColor =
        widget.borderColor ?? colorScheme.outline.withValues(alpha: 0.2);
    final effectiveBorderRadius =
        widget.borderRadius ?? AppSpacing.roundedLg;
    final effectiveIndicatorColor =
        widget.indicatorColor ?? colorScheme.primary;
    final effectiveIndicatorBorderRadius =
        widget.indicatorBorderRadius ?? AppSpacing.roundedMd;
    final effectiveIndicatorBoxShadow =
        widget.indicatorBoxShadow ??
        [
          BoxShadow(
            color: (widget.indicatorColor ?? colorScheme.primary).withValues(
              alpha: 0.3,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];
    final effectiveSelectedIconColor =
        widget.selectedIconColor ?? colorScheme.onPrimary;
    final effectiveUnselectedIconColor =
        widget.unselectedIconColor ??
        colorScheme.onSurface.withValues(alpha: 0.7);

    final effectiveSelectedTextStyle =
        widget.selectedTextStyle ??
        theme.textTheme.titleSmall!.copyWith(
          color: effectiveSelectedIconColor,
          fontWeight: FontWeight.w600,
        );

    final effectiveUnselectedTextStyle =
        widget.unselectedTextStyle ??
        theme.textTheme.titleSmall!.copyWith(
          color: effectiveUnselectedIconColor,
          fontWeight: FontWeight.w500,
        );

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(color: effectiveBorderColor),
      ),
      child: Stack(
        children: [
          TweenAnimationBuilder<double>(
            duration: widget.animationDuration,
            curve: AppSpacing.curveDefault,
            tween: Tween<double>(
              begin: _previousIndex.toDouble(),
              end: _selectedIndex.toDouble(),
            ),
            builder: (context, value, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final calculatedSegmentWidth =
                      availableWidth / widget.segments.length;

                  return AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(value * calculatedSegmentWidth, 0),
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            width: calculatedSegmentWidth,
                            height: widget.height,
                            decoration: BoxDecoration(
                              color: effectiveIndicatorColor,
                              borderRadius: effectiveIndicatorBorderRadius,
                              boxShadow: effectiveIndicatorBoxShadow,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: List.generate(widget.segments.length, (index) {
                  final segment = widget.segments[index];
                  final isSelected = widget.selected.contains(segment.value);
                  return Expanded(
                    child: GestureDetector(
                      onTap: segment.enabled ? () => _handleTap(index) : null,
                      child: AnimatedContainer(
                        duration: widget.animationDuration,
                        curve: AppSpacing.curveDefault,
                        height: widget.height,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: AppSpacing.sm,
                            children: [
                              if (segment.icon != null)
                                AnimatedDefaultTextStyle(
                                  duration: AppSpacing.durationFast,
                                  style: TextStyle(
                                    color: isSelected
                                        ? effectiveSelectedIconColor
                                        : effectiveUnselectedIconColor,
                                  ),
                                  child: segment.icon!,
                                ),
                              if (segment.label != null)
                                AnimatedDefaultTextStyle(
                                  duration: AppSpacing.durationFast,
                                  style: isSelected
                                      ? effectiveSelectedTextStyle
                                      : effectiveUnselectedTextStyle,
                                  child: segment.label!,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ButtonSegment<T> {
  const ButtonSegment({
    required this.value,
    this.icon,
    this.label,
    this.enabled = true,
  });

  final T value;
  final Widget? icon;
  final Widget? label;
  final bool enabled;
}
