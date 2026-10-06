import "dart:math" show Random;

import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";

enum SkeletonDirection { ltr, rtl, ttb, btt }

enum SkeletonShape { rectangle, circle }

class _SkeletonScope extends InheritedWidget {
  const _SkeletonScope({
    required this.animation,
    required this.baseColor,
    required this.highlightColor,
    required this.direction,
    required super.child,
  });
  final Animation<double> animation;
  final Color baseColor;
  final Color highlightColor;
  final SkeletonDirection direction;

  static _SkeletonScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SkeletonScope>();

  @override
  bool updateShouldNotify(_SkeletonScope oldWidget) {
    return animation != oldWidget.animation ||
        baseColor != oldWidget.baseColor ||
        highlightColor != oldWidget.highlightColor ||
        direction != oldWidget.direction;
  }
}

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    required this.child,
    this.isLoading = true,
    this.period = const Duration(milliseconds: 1200),
    this.baseColor,
    this.highlightColor,
    this.direction = SkeletonDirection.ltr,
    super.key,
  });
  final Widget child;
  final bool isLoading;
  final Duration period;
  final Color? baseColor;
  final Color? highlightColor;
  final SkeletonDirection direction;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  Color _defaultBase(BuildContext context) =>
      widget.baseColor ??
      (Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade300);

  Color _defaultHighlight(BuildContext context) =>
      widget.highlightColor ??
      (Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade700
          : Colors.grey.shade100);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..repeat();
    // value range: -1 -> 2 (so gradient runs fully across)
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant SkeletonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      _controller.duration = widget.period;
      _controller.repeat();
    }
    if (!widget.isLoading) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return _SkeletonScope(
      animation: _animation,
      baseColor: _defaultBase(context),
      highlightColor: _defaultHighlight(context),
      direction: widget.direction,
      child: widget.child,
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    this.width,
    this.height,
    this.borderRadius,
    this.shape = SkeletonShape.rectangle,
    this.margin,
    this.padding,
    super.key,
  });
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final SkeletonShape shape;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  Alignment _beginForDirection(SkeletonDirection dir) {
    switch (dir) {
      case SkeletonDirection.ltr:
        return Alignment.centerLeft;
      case SkeletonDirection.rtl:
        return Alignment.centerRight;
      case SkeletonDirection.ttb:
        return Alignment.topCenter;
      case SkeletonDirection.btt:
        return Alignment.bottomCenter;
    }
  }

  Alignment _endForDirection(SkeletonDirection dir) {
    switch (dir) {
      case SkeletonDirection.ltr:
        return Alignment.centerRight;
      case SkeletonDirection.rtl:
        return Alignment.centerLeft;
      case SkeletonDirection.ttb:
        return Alignment.bottomCenter;
      case SkeletonDirection.btt:
        return Alignment.topCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = _SkeletonScope.of(context);
    final base = scope?.baseColor ?? Colors.grey.shade300;
    final highlight = scope?.highlightColor ?? Colors.grey.shade100;
    final direction = scope?.direction ?? SkeletonDirection.ltr;
    final animation = scope?.animation;

    final Widget box = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      constraints: BoxConstraints(maxWidth: context.screenWidth),
      decoration: BoxDecoration(
        color: base,
        borderRadius: shape == SkeletonShape.circle
            ? null
            : (borderRadius ?? BorderRadius.circular(8.0)),
        shape: shape == SkeletonShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
      ),
    );

    if (animation == null) {
      // Pas d'animation fournie -> rendre un simple placeholder statique
      return box;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return RepaintBoundary(
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              final animValue = animation.value; // -1 -> 2
              final begin = _beginForDirection(direction);
              final end = _endForDirection(direction);

              final gradient = LinearGradient(
                begin: begin,
                end: end,
                colors: [base, highlight, base],
                stops: const [0.1, 0.5, 0.9],
              );

              final dx = (bounds.width) * animValue;
              final dy = (bounds.height) * animValue;
              // Choose translation by major axis (horizontal for ltr/rtl, vertical for ttb/btt)
              Rect shaderRect;
              if (direction == SkeletonDirection.ltr ||
                  direction == SkeletonDirection.rtl) {
                shaderRect = Rect.fromLTWH(dx, 0, bounds.width, bounds.height);
              } else {
                shaderRect = Rect.fromLTWH(0, dy, bounds.width, bounds.height);
              }
              return gradient.createShader(shaderRect);
            },
            child: box,
          ),
        );
      },
    );
  }
}

class SkeletonText extends StatelessWidget {
  const SkeletonText({
    this.lines = 3,
    this.lineHeight = 12.0,
    this.spacing = 8.0,
    this.widths,
    this.borderRadius,
    super.key,
  });
  final int lines;
  final double lineHeight;
  final double spacing;
  final List<double>? widths; // fractions between 0 and 1
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final defaultWidths = List<double>.generate(lines, (i) {
      // make last line shorter
      if (i == lines - 1) return 0.6;
      if (lines == 1) return 0.9;
      return 0.9 - (i * 0.08);
    });
    final used = widths != null && widths!.length >= lines
        ? widths!
        : defaultWidths;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i == lines - 1 ? 0 : spacing),
          child: FractionallySizedBox(
            widthFactor: used[i],
            child: Skeleton(
              height: lineHeight,
              borderRadius: borderRadius ?? BorderRadius.circular(6),
            ),
          ),
        );
      }),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({this.size = 48.0, this.borderRadius, super.key});
  final double size;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: size,
      height: size,
      shape: SkeletonShape.circle,
      borderRadius: borderRadius,
    );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({
    required this.itemCount,
    required this.itemBuilder,
    this.separated = false,
    this.separator,
    super.key,
  });
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool separated;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    if (!separated) {
      return Column(
        children: List.generate(
          itemCount,
          (index) => itemBuilder(context, index),
        ),
      );
    }
    return Column(
      children: List.generate(itemCount * 2 - 1, (i) {
        if (i.isEven) return itemBuilder(context, i ~/ 2);
        return separator ?? const SizedBox(height: 12);
      }),
    );
  }
}

class SkeletonTile extends StatelessWidget {
  const SkeletonTile({
    super.key,
    this.showLeading = true,
    this.showTrailing = false,
    this.lines = 2,
  });

  final bool showLeading;

  final bool showTrailing;

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showLeading) ...[
          const SkeletonAvatar(size: AppSpacing.avatarLg),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(child: SkeletonText(lines: lines)),
        if (showTrailing) ...[
          const SizedBox(width: AppSpacing.md),
          const Skeleton(width: 48, height: 12),
        ],
      ],
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height,
    this.showAvatar = false,
    this.lines = 3,
  });

  final double? height;

  final bool showAvatar;

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showAvatar) ...[
            const SkeletonAvatar(size: AppSpacing.avatarMd),
            const SizedBox(height: AppSpacing.md),
          ],
          SkeletonText(lines: lines),
        ],
      ),
    );
  }
}

class SkeletonParagraph extends StatelessWidget {
  const SkeletonParagraph({
    super.key,
    this.lines = 4,
    this.lineHeight = 12.0,
    this.spacing = 8.0,
  });

  final int lines;

  final double lineHeight;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final rng = Random(42); // fixed seed for stable widths
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (i) {
        final isLast = i == lines - 1;
        final w = 0.45 + rng.nextDouble() * 0.5;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
          child: FractionallySizedBox(
            widthFactor: isLast ? w * 0.7 : w,
            child: Skeleton(height: lineHeight),
          ),
        );
      }),
    );
  }
}

class SkeletonButton extends StatelessWidget {
  const SkeletonButton({
    super.key,
    this.width,
    this.height = AppSpacing.buttonHeightMd,
    this.borderRadius,
  });

  final double? width;

  final double height;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Skeleton(
        width: width ?? double.infinity,
        height: height,
        borderRadius: borderRadius ?? AppSpacing.roundedMd,
      ),
    );
  }
}

class SkeletonFormField extends StatelessWidget {
  const SkeletonFormField({
    super.key,
    this.showLabel = true,
    this.labelWidth = 0.3,
    this.fieldHeight = AppSpacing.inputHeightMd,
  });

  final bool showLabel;

  final double labelWidth;

  final double fieldHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          const FractionallySizedBox(
            widthFactor: 0.3,
            child: Skeleton(height: 10),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Skeleton(height: fieldHeight),
      ],
    );
  }
}

class SkeletonChip extends StatelessWidget {
  const SkeletonChip({
    super.key,
    this.width = 64.0,
    this.height = 28.0,
    this.shape = SkeletonShape.rectangle,
  });

  final double width;

  final double height;

  final SkeletonShape shape;

  @override
  Widget build(BuildContext context) {
    return Skeleton(width: width, height: height, shape: shape);
  }
}

class SkeletonImage extends StatelessWidget {
  const SkeletonImage({
    super.key,
    this.height,
    this.aspectRatio,
    this.width,
    this.borderRadius,
  });

  final double? height;

  final double? aspectRatio;

  final double? width;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (height != null) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: Skeleton(
          width: width ?? double.infinity,
          height: height,
          borderRadius: borderRadius ?? AppSpacing.roundedLg,
        ),
      );
    }
    return AspectRatio(
      aspectRatio: aspectRatio ?? 16 / 9,
      child: Skeleton(
        width: double.infinity,
        height: double.infinity,
        borderRadius: borderRadius ?? AppSpacing.roundedLg,
      ),
    );
  }
}

class SkeletonDivider extends StatelessWidget {
  const SkeletonDivider({
    super.key,
    this.height = 1.0,
    this.width,
    this.margin,
  });

  final double height;

  final double? width;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Skeleton(width: width ?? double.infinity, height: height),
    );
  }
}

class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = AppSpacing.md,
    this.crossAxisSpacing = AppSpacing.md,
    this.childAspectRatio = 0.75,
    this.padding,
    this.scrollable = false,
    super.key,
  });

  final int itemCount;

  final IndexedWidgetBuilder itemBuilder;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final EdgeInsetsGeometry? padding;

  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final grid = SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
    );

    if (scrollable) {
      return CustomScrollView(slivers: [grid]);
    }

    return SizedBox(
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}

class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({
    super.key,
    this.showRating = true,
    this.borderRadius,
  });

  final bool showRating;

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: borderRadius ?? AppSpacing.roundedLg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Expanded(
            child: Skeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
          ),
          Padding(
            padding: AppSpacing.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Skeleton(height: 10),
                const SizedBox(height: AppSpacing.sm),
                const FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Skeleton(height: 12),
                ),
                if (showRating) ...[
                  const SizedBox(height: AppSpacing.xs),
                  const Row(
                    children: [
                      Skeleton(width: 60, height: 8),
                      SizedBox(width: AppSpacing.sm),
                      Skeleton(width: 24, height: 8),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({
    super.key,
    this.showStats = true,
    this.showSubtitle = true,
  });

  final bool showStats;

  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SkeletonAvatar(size: AppSpacing.avatarXl),
        const SizedBox(height: AppSpacing.md),
        const FractionallySizedBox(
          widthFactor: 0.4,
          child: Skeleton(height: 16),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: AppSpacing.xs),
          const FractionallySizedBox(
            widthFactor: 0.25,
            child: Skeleton(height: 12),
          ),
        ],
        if (showStats) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (_) => const Column(
                children: [
                  Skeleton(width: 32, height: 16),
                  SizedBox(height: AppSpacing.xs),
                  Skeleton(width: 48, height: 10),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class SkeletonComment extends StatelessWidget {
  const SkeletonComment({
    super.key,
    this.lines = 2,
    this.avatarSize = AppSpacing.avatarSm,
  });

  final int lines;

  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonAvatar(size: avatarSize),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const FractionallySizedBox(
                widthFactor: 0.25,
                child: Skeleton(height: 10),
              ),
              const SizedBox(height: AppSpacing.sm),
              SkeletonText(lines: lines, lineHeight: 10, spacing: 4),
            ],
          ),
        ),
      ],
    );
  }
}

class SkeletonChart extends StatelessWidget {
  const SkeletonChart({
    super.key,
    this.barCount = 5,
    this.height = 150.0,
    this.barWidth = 24.0,
    this.spacing = 8.0,
  });

  final int barCount;

  final double height;

  final double barWidth;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    final rng = Random(42);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(barCount, (i) {
          final barHeightFactor = 0.3 + rng.nextDouble() * 0.7;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing / 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bar (rendered as a Skeleton with the computed height)
                Skeleton(width: barWidth, height: height * barHeightFactor),
                if (barCount <= 7) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Skeleton(width: barWidth * 0.6, height: 6),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SkeletonArticle extends StatelessWidget {
  const SkeletonArticle({super.key, this.paragraphs = 3, this.titleLines = 2});

  final int paragraphs;

  final int titleLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonText(lines: titleLines, lineHeight: 20, spacing: 6),
        const SizedBox(height: AppSpacing.sm),
        const Row(
          children: [
            Skeleton(width: 80, height: 10),
            SizedBox(width: AppSpacing.md),
            Skeleton(width: 60, height: 10),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ...List.generate(paragraphs, (i) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < paragraphs - 1 ? AppSpacing.md : 0,
            ),
            child: SkeletonParagraph(lines: 4 + i % 2),
          );
        }),
      ],
    );
  }
}

class SkeletonTableRow extends StatelessWidget {
  const SkeletonTableRow({
    super.key,
    this.cellCount = 4,
    this.cellWidths,
    this.height = 48.0,
    this.cellHeight = 12.0,
    this.cellSpacing = AppSpacing.md,
    this.showDivider = true,
  });

  final int cellCount;

  final List<double>? cellWidths;

  final double height;

  final double cellHeight;

  final double cellSpacing;

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final widths =
        cellWidths ?? List.generate(cellCount, (_) => 1.0 / cellCount);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          child: Row(
            children: List.generate(cellCount, (i) {
              final w = widths.length > i ? widths[i] : 1.0 / cellCount;
              return Padding(
                padding: EdgeInsets.only(
                  right: i < cellCount - 1 ? cellSpacing : 0,
                ),
                child: FractionallySizedBox(
                  widthFactor: w,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Skeleton(width: double.infinity, height: cellHeight),
                  ),
                ),
              );
            }),
          ),
        ),
        if (showDivider) const SkeletonDivider(),
      ],
    );
  }
}

class SkeletonAppBar extends StatelessWidget {
  const SkeletonAppBar({
    super.key,
    this.showBack = true,
    this.actionCount = 1,
    this.titleWidth = 0.4,
  });

  final bool showBack;

  final int actionCount;

  final double titleWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.appBarHeight,
      padding: AppSpacing.screenPaddingH,
      child: Row(
        children: [
          if (showBack) ...[
            const Skeleton(width: 24, height: 24, shape: SkeletonShape.circle),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: FractionallySizedBox(
              widthFactor: titleWidth,
              alignment: Alignment.centerLeft,
              child: const Skeleton(height: 16),
            ),
          ),
          ...List.generate(
            actionCount,
            (_) => const Padding(
              padding: EdgeInsets.only(left: AppSpacing.md),
              child: Skeleton(
                width: 24,
                height: 24,
                shape: SkeletonShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonPage extends StatelessWidget {
  const SkeletonPage({
    super.key,
    this.appBarTitle,
    this.body = const [],
    this.padding,
    this.physics,
  });

  final String? appBarTitle;

  final List<Widget> body;

  final EdgeInsetsGeometry? padding;

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonAppBar(titleWidth: appBarTitle != null ? 0.0 : 0.4),
        Expanded(
          child: SingleChildScrollView(
            physics: physics ?? const NeverScrollableScrollPhysics(),
            padding: padding ?? AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: body,
            ),
          ),
        ),
      ],
    );
  }
}

class SkeletonBadge extends StatelessWidget {
  const SkeletonBadge({
    super.key,
    this.size = 8.0,
    this.shape = SkeletonShape.circle,
  });

  final double size;

  final SkeletonShape shape;

  @override
  Widget build(BuildContext context) {
    return Skeleton(width: size, height: size, shape: shape);
  }
}

class SkeletonSection extends StatelessWidget {
  const SkeletonSection({
    super.key,
    this.showHeader = true,
    this.headerWidth = 0.3,
    this.children = const [],
    this.spacing = AppSpacing.md,
  });

  final bool showHeader;

  final double headerWidth;

  final List<Widget> children;

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showHeader) ...[
          FractionallySizedBox(
            widthFactor: headerWidth,
            child: const Skeleton(height: 14),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        ...children.expand((child) => [child, SizedBox(height: spacing)]),
      ],
    );
  }
}

class SkeletonRow extends StatelessWidget {
  const SkeletonRow({
    required this.itemCount,
    this.itemWidth = 72.0,
    this.itemHeight = 72.0,
    this.spacing = AppSpacing.md,
    this.shape = SkeletonShape.rectangle,
    this.scrollable = false,
    super.key,
  });

  final int itemCount;

  final double itemWidth;

  final double itemHeight;

  final double spacing;

  final SkeletonShape shape;

  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final items = List.generate(itemCount, (i) {
      return Padding(
        padding: EdgeInsets.only(left: i == 0 ? 0 : spacing),
        child: Skeleton(width: itemWidth, height: itemHeight, shape: shape),
      );
    });

    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: items),
      );
    }
    return Row(mainAxisSize: MainAxisSize.min, children: items);
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({
    super.key,
    this.showLeading = true,
    this.showSubtitle = true,
    this.showTrailing = false,
    this.leadingSize = AppSpacing.avatarMd,
  });

  final bool showLeading;
  final bool showSubtitle;
  final bool showTrailing;
  final double leadingSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.listItemPadding,
      child: Row(
        children: [
          if (showLeading) ...[
            SkeletonAvatar(size: leadingSize),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Skeleton(height: 14),
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: AppSpacing.xs),
                  const FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Skeleton(height: 10),
                  ),
                ],
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: AppSpacing.md),
            const Skeleton(width: 20, height: 20, shape: SkeletonShape.circle),
          ],
        ],
      ),
    );
  }
}

class SkeletonDashboardCard extends StatelessWidget {
  const SkeletonDashboardCard({super.key, this.showIcon = true});

  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppSpacing.roundedLg,
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            const Skeleton(width: 40, height: 40, shape: SkeletonShape.circle),
            const SizedBox(width: AppSpacing.md),
          ],
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeleton(height: 10),
                SizedBox(height: AppSpacing.sm),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Skeleton(height: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
