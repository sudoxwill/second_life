// lib/widgets/skeletons.dart
//
// ─────────────────────────────────────────────────────────────────────────────
//  Squelettes (Shimmer Loading)
// ─────────────────────────────────────────────────────────────────────────────
//
//  Ce fichier fournit un système complet de placeholders de chargement avec
//  effet shimmer. L'animation est partagée entre tous les squelettes d'une
//  même page via [_SkeletonScope] pour éviter de multiplier les
//  AnimationController.
//
// ─── Utilisation rapide ─────────────────────────────────────────────────────
//
//  Le plus simple : envelopper votre contenu normal et passer isLoading :
//
//    SkeletonLoader(
//      isLoading: state.isLoading,
//      child: MaPage(),       // ← vos vrais widgets
//    )
//
//  Les squelettes s'affichent automatiquement quand isLoading = true :
//
//    SkeletonLoader(
//      isLoading: state.isLoading,
//      child: const Column(children: [
//        SkeletonTile(),
//        SkeletonTile(),
//        SkeletonCard(lines: 4, showAvatar: true),
//      ]),
//    )
//
// ─── Patterns courants ──────────────────────────────────────────────────────
//
//  1 - Liste de tiles (page liste)
//     SkeletonLoader(
//       isLoading: state.isLoading,
//       child: SkeletonList(
//         itemCount: 6,
//         separated: true,
//         itemBuilder: (_, __) => const SkeletonTile(),
//       ),
//     )
//
//  2 - Cartes empilées
//     SkeletonLoader(
//       isLoading: isLoading,
//       child: SkeletonList(
//         itemCount: 3,
//         separated: true,
//         itemBuilder: (_, __) => const SkeletonCard(showAvatar: true),
//         separator: SizedBox(height: 12),
//       ),
//     )
//
//  3 - Page complète avec AppBar
//     SkeletonLoader(
//       isLoading: isLoading,
//       child: SkeletonPage(
//         appBarTitle: "Profil",
//         children: [
//           SkeletonProfileHeader(),
//           SkeletonCard(lines: 3),
//           SkeletonCard(lines: 2),
//         ],
//       ),
//     )
//
//  4 - Grille de produits
//     SkeletonLoader(
//       isLoading: isLoading,
//       child: SkeletonGrid(
//         crossAxisCount: 2,
//         itemCount: 6,
//         itemBuilder: (_, __) => const SkeletonProductCard(),
//       ),
//     )
//
//  5 - Détail d'article / blog
//     SkeletonLoader(
//       isLoading: isLoading,
//       child: SingleChildScrollView(
//         padding: AppSpacing.screenPadding,
//         child: Column(children: [
//           const SkeletonImage(height: 200),
//           AppSpacing.gapVLg,
//           const SkeletonArticle(),
//         ]),
//       ),
//     )
//
// ─── Personnalisation ────────────────────────────────────────────────────────
//
//  Couleurs, durée et direction :
//
//    SkeletonLoader(
//      isLoading: isLoading,
//      period: const Duration(milliseconds: 800),
//      baseColor: Colors.grey.shade400,
//      highlightColor: Colors.grey.shade200,
//      direction: SkeletonDirection.ttb,
//      child: ...,
//    )
//
// ─────────────────────────────────────────────────────────────────────────────
import "dart:math" show Random;

import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";

enum SkeletonDirection { ltr, rtl, ttb, btt }

enum SkeletonShape { rectangle, circle }

/// Scope qui expose une animation partagée pour éviter de créer
/// plusieurs AnimationControllers dans une même page.
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

/// Widget qui fournit (ou pas) l'animation aux Skeletons enfants.
/// Si isLoading == false -> rend `child` tel quel (pas d'animation).
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

/// Widget de base — rectangle ou cercle — avec shimmer animé
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

    // Animated ShaderMask with gradient sliding using the shared animation.
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return RepaintBoundary(
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              // gradient that will be shifted horizontally/vertically according to animation value
              final animValue = animation.value; // -1 -> 2
              final begin = _beginForDirection(direction);
              final end = _endForDirection(direction);

              final gradient = LinearGradient(
                begin: begin,
                end: end,
                colors: [base, highlight, base],
                stops: const [0.1, 0.5, 0.9],
              );

              // Create shader; shift it by animValue across bounds
              // We compute a rect that starts at offset depending on animValue
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

/// Helper: skeleton lines for text-like skeleton.
/// `lines` lines with variable widths
/// (you can pass a list of fractions or use defaults).
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

/// Avatar skeleton
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

/// Convenience builder for lists of skeletons
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

/// Pre-built skeleton that mimics a [ListTile]:
/// optional leading avatar, text lines, and optional trailing block.
class SkeletonTile extends StatelessWidget {
  const SkeletonTile({
    super.key,
    this.showLeading = true,
    this.showTrailing = false,
    this.lines = 2,
  });

  /// Show a circular avatar placeholder on the left.
  final bool showLeading;

  /// Show a small rectangular placeholder on the right (e.g. date or badge).
  final bool showTrailing;

  /// Number of text skeleton lines (title counts as line 1).
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

/// Pre-built skeleton card: a rounded container with configurable content.
///
/// If [height] is null, the card sizes itself to its content.
/// Avoid pairing a small [height] with many [lines] as content will overflow.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height,
    this.showAvatar = false,
    this.lines = 3,
  });

  /// Fixed card height. If null, height is driven by the content.
  final double? height;

  /// Show an avatar placeholder at the top of the card.
  final bool showAvatar;

  /// Number of text skeleton lines inside the card.
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

// ═════════════════════════════════════════════════════════════════════════════
//  NEW UTILITY CLASSES
// ═════════════════════════════════════════════════════════════════════════════

/// A paragraph skeleton with naturally varying line widths.
///
/// Each line gets a random-ish width for a more realistic text placeholder.
/// Unlike [SkeletonText] which repeats similar patterns, this creates
/// a more natural "wall of text" appearance.
///
/// Usage:
/// ```dart
/// const SkeletonParagraph(lines: 5, lineHeight: 14, spacing: 8)
/// ```
class SkeletonParagraph extends StatelessWidget {
  const SkeletonParagraph({
    super.key,
    this.lines = 4,
    this.lineHeight = 12.0,
    this.spacing = 8.0,
  });

  /// Number of text lines (default 4).
  final int lines;

  /// Height of each line in pixels (default 12).
  final double lineHeight;

  /// Vertical space between lines in pixels (default 8).
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final rng = Random(42); // fixed seed for stable widths
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(lines, (i) {
        final isLast = i == lines - 1;
        // Each line gets a pseudo-random width between 0.45 and 0.95
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

/// A skeleton that mimics a rectangular button.
///
/// Usage:
/// ```dart
/// const SkeletonButton(width: 120, height: 48)
/// ```
class SkeletonButton extends StatelessWidget {
  const SkeletonButton({
    super.key,
    this.width,
    this.height = AppSpacing.buttonHeightMd,
    this.borderRadius,
  });

  /// Button width. If null, uses [double.infinity] (fills parent).
  final double? width;

  /// Button height (default 48, matches [AppSpacing.buttonHeightMd]).
  final double height;

  /// Corner radius (defaults to [AppSpacing.radiusMd]).
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

/// A skeleton that mimics an input / text form field.
///
/// Renders a label bar + a field rectangle to simulate a form input.
///
/// Usage:
/// ```dart
/// const SkeletonFormField()
/// ```
class SkeletonFormField extends StatelessWidget {
  const SkeletonFormField({
    super.key,
    this.showLabel = true,
    this.labelWidth = 0.3,
    this.fieldHeight = AppSpacing.inputHeightMd,
  });

  /// Whether to show a small label bar above the field.
  final bool showLabel;

  /// Width fraction of the label relative to parent (default 0.3).
  final double labelWidth;

  /// Height of the field rectangle (default 48, matches
  /// [AppSpacing.inputHeightMd]).
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

/// A small chip / badge skeleton.
///
/// Useful to simulate tags, categories, or status badges while loading.
///
/// Usage:
/// ```dart
/// const SkeletonChip(width: 60)
/// ```
class SkeletonChip extends StatelessWidget {
  const SkeletonChip({
    super.key,
    this.width = 64.0,
    this.height = 28.0,
    this.shape = SkeletonShape.rectangle,
  });

  /// Chip width (default 64).
  final double width;

  /// Chip height (default 28).
  final double height;

  /// Shape of the chip (default rectangle, use circle for icon dots).
  final SkeletonShape shape;

  @override
  Widget build(BuildContext context) {
    return Skeleton(width: width, height: height, shape: shape);
  }
}

/// A skeleton placeholder for an image area.
///
/// Renders a rectangle with optional icon overlay to indicate an image.
/// Use [aspectRatio] instead of [height] for responsive image areas.
///
/// Usage:
/// ```dart
/// const SkeletonImage(height: 200)
/// const SkeletonImage(aspectRatio: 16/9)
/// ```
class SkeletonImage extends StatelessWidget {
  const SkeletonImage({
    super.key,
    this.height,
    this.aspectRatio,
    this.width,
    this.borderRadius,
  });

  /// Fixed height (alternative to [aspectRatio]).
  final double? height;

  /// Aspect ratio (e.g. 16/9, 4/3). Ignored if [height] is set.
  final double? aspectRatio;

  /// Optional fixed width.
  final double? width;

  /// Corner radius.
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

/// A skeleton divider — a simple horizontal / vertical line.
///
/// Usage:
/// ```dart
/// const SkeletonDivider()
/// const SkeletonDivider(height: 2, width: 100)
/// ```
class SkeletonDivider extends StatelessWidget {
  const SkeletonDivider({
    super.key,
    this.height = 1.0,
    this.width,
    this.margin,
  });

  /// Line thickness (default 1).
  final double height;

  /// Line width. If null, fills available width.
  final double? width;

  /// Optional margin around the divider.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Skeleton(width: width ?? double.infinity, height: height),
    );
  }
}

/// A skeleton grid — builds a grid of skeleton items.
///
/// Perfect for product grids, photo galleries, or any card grid layout.
///
/// Usage:
/// ```dart
/// SkeletonLoader(
///   isLoading: isLoading,
///   child: SkeletonGrid(
///     crossAxisCount: 2,
///     itemCount: 6,
///     itemBuilder: (_, __) => const SkeletonProductCard(),
///   ),
/// )
/// ```
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

  /// Number of items to display.
  final int itemCount;

  /// Builder for each skeleton item.
  final IndexedWidgetBuilder itemBuilder;

  /// Number of columns (default 2).
  final int crossAxisCount;

  /// Vertical spacing between rows (default 12).
  final double mainAxisSpacing;

  /// Horizontal spacing between columns (default 12).
  final double crossAxisSpacing;

  /// Aspect ratio of each child (width/height, default 0.75).
  final double childAspectRatio;

  /// Optional padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// If true, the grid is wrapped in a scrollable view.
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

/// An e-commerce style product card skeleton.
///
/// Mimics a typical product card: image area on top, title + price below.
///
/// Usage:
/// ```dart
/// const SkeletonProductCard()
/// ```
class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({
    super.key,
    this.showRating = true,
    this.borderRadius,
  });

  /// Whether to show a rating row below the price.
  final bool showRating;

  /// Corner radius for the card.
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

/// A profile page header skeleton.
///
/// Renders a large avatar, a name line, and optional stats row.
///
/// Usage:
/// ```dart
/// const SkeletonProfileHeader()
/// ```
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({
    super.key,
    this.showStats = true,
    this.showSubtitle = true,
  });

  /// Whether to show a stats row (followers, posts, etc.).
  final bool showStats;

  /// Whether to show a subtitle line below the name.
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

/// A comment / thread skeleton.
///
/// Renders a leading avatar + multi-line text bubble, mimicking
/// a comment in a social feed or discussion thread.
///
/// Usage:
/// ```dart
/// const SkeletonComment()
/// ```
class SkeletonComment extends StatelessWidget {
  const SkeletonComment({
    super.key,
    this.lines = 2,
    this.avatarSize = AppSpacing.avatarSm,
  });

  /// Number of text lines (default 2).
  final int lines;

  /// Avatar size (default 32).
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
              // Author name
              const FractionallySizedBox(
                widthFactor: 0.25,
                child: Skeleton(height: 10),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Comment body
              SkeletonText(lines: lines, lineHeight: 10, spacing: 4),
            ],
          ),
        ),
      ],
    );
  }
}

/// A bar chart skeleton.
///
/// Renders a set of vertical bars of varying heights to simulate a chart.
///
/// Usage:
/// ```dart
/// const SkeletonChart(barCount: 6, height: 160)
/// ```
class SkeletonChart extends StatelessWidget {
  const SkeletonChart({
    super.key,
    this.barCount = 5,
    this.height = 150.0,
    this.barWidth = 24.0,
    this.spacing = 8.0,
  });

  /// Number of bars to display (default 5).
  final int barCount;

  /// Total chart height (default 150).
  final double height;

  /// Width of each bar (default 24).
  final double barWidth;

  /// Space between bars (default 8).
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
          // Generate bar heights between 0.3 and 1.0 of total height
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
                  // Small label below each bar
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

/// A blog / news article skeleton.
///
/// Renders a title, a subtitle, and several paragraphs of text,
/// ideal for detail pages of articles or news.
///
/// Usage:
/// ```dart
/// const SkeletonArticle(paragraphs: 3)
/// ```
class SkeletonArticle extends StatelessWidget {
  const SkeletonArticle({super.key, this.paragraphs = 3, this.titleLines = 2});

  /// Number of content paragraphs (default 3).
  final int paragraphs;

  /// Number of lines for the title (default 2).
  final int titleLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        SkeletonText(lines: titleLines, lineHeight: 20, spacing: 6),
        const SizedBox(height: AppSpacing.sm),
        // Subtitle / metadata row
        const Row(
          children: [
            Skeleton(width: 80, height: 10),
            SizedBox(width: AppSpacing.md),
            Skeleton(width: 60, height: 10),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        // Paragraphs
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

/// A table row skeleton.
///
/// Renders a horizontal row of cells, useful for data tables.
///
/// Usage:
/// ```dart
/// const SkeletonTableRow(cellCount: 4)
/// ```
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

  /// Number of cells in the row (default 4).
  final int cellCount;

  /// Custom widths for each cell. If null, cells are evenly distributed.
  final List<double>? cellWidths;

  /// Row height (default 48).
  final double height;

  /// Height of the skeleton inside each cell (default 12).
  final double cellHeight;

  /// Space between cells (default 12).
  final double cellSpacing;

  /// Whether to show a bottom divider line.
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

/// An AppBar skeleton.
///
/// Renders a typical AppBar: optional back button, a title bar, and
/// optional action buttons.
///
/// Usage:
/// ```dart
/// const SkeletonAppBar()
/// ```
class SkeletonAppBar extends StatelessWidget {
  const SkeletonAppBar({
    super.key,
    this.showBack = true,
    this.actionCount = 1,
    this.titleWidth = 0.4,
  });

  /// Whether to show a back button placeholder.
  final bool showBack;

  /// Number of action icon placeholders on the right (default 1).
  final int actionCount;

  /// Width fraction of the title relative to available space (default 0.4).
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

/// A full-page skeleton with an AppBar and scrollable body sections.
///
/// This is the quickest way to skeletonise an entire screen.
///
/// Usage:
/// ```dart
/// SkeletonPage(
///   appBarTitle: "Profile",
///   body: [
///     SkeletonProfileHeader(),
///     const SizedBox(height: 24),
///     SkeletonCard(lines: 3),
///     SkeletonCard(lines: 2),
///   ],
/// )
/// ```
class SkeletonPage extends StatelessWidget {
  const SkeletonPage({
    super.key,
    this.appBarTitle,
    this.body = const [],
    this.padding,
    this.physics,
  });

  /// Optional title — if null, [SkeletonAppBar] is still
  /// rendered with title placeholder.
  final String? appBarTitle;

  /// The list of skeleton widgets to render in the scrollable body.
  final List<Widget> body;

  /// Optional padding for the body area.
  final EdgeInsetsGeometry? padding;

  /// Scroll physics for the body.
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

/// A badge / indicator skeleton.
///
/// Small rounded rectangle, useful for notification
/// badges or status indicators.
///
/// Usage:
/// ```dart
/// const SkeletonBadge()
/// const SkeletonBadge(size: 16)
/// ```
class SkeletonBadge extends StatelessWidget {
  const SkeletonBadge({
    super.key,
    this.size = 8.0,
    this.shape = SkeletonShape.circle,
  });

  /// Size (diameter for circle, or width/height for rectangle).
  final double size;

  /// Shape (default circle for notification dots).
  final SkeletonShape shape;

  @override
  Widget build(BuildContext context) {
    return Skeleton(width: size, height: size, shape: shape);
  }
}

/// A section skeleton with an optional header row + content children.
///
/// Useful for grouped sections like "Settings", "Account Info", etc.
///
/// Usage:
/// ```dart
/// const SkeletonSection(
///   showHeader: true,
///   headerWidth: 0.35,
///   children: [
///     SkeletonTile(showLeading: true),
///     SkeletonTile(showLeading: true),
///   ],
/// )
/// ```
class SkeletonSection extends StatelessWidget {
  const SkeletonSection({
    super.key,
    this.showHeader = true,
    this.headerWidth = 0.3,
    this.children = const [],
    this.spacing = AppSpacing.md,
  });

  /// Whether to show a header row at the top.
  final bool showHeader;

  /// Width fraction of the header text (default 0.3).
  final double headerWidth;

  /// List of skeleton children.
  final List<Widget> children;

  /// Vertical space between children (default 12).
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

/// A row skeleton — renders a horizontal row of skeleton items.
///
/// Useful for horizontal scrolling lists, stat bars, or any row layout.
///
/// Usage:
/// ```dart
/// SkeletonRow(
///   itemCount: 4,
///   itemWidth: 80,
///   itemHeight: 80,
///   spacing: 12,
/// )
/// ```
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

  /// Number of items in the row.
  final int itemCount;

  /// Width of each item.
  final double itemWidth;

  /// Height of each item.
  final double itemHeight;

  /// Space between items.
  final double spacing;

  /// Shape of each item.
  final SkeletonShape shape;

  /// If true, wraps the row in a horizontal [SingleChildScrollView].
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

/// A list tile skeleton mimicking a Flutter [ListTile].
///
/// Similar to [SkeletonTile] but more closely aligned with Material
/// [ListTile] layout: leading → title → subtitle → trailing.
///
/// Usage:
/// ```dart
/// const SkeletonListTile(showSubtitle: true, showTrailing: true)
/// ```
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

/// A dashboard card skeleton — a card with an icon + title + value row.
///
/// Useful for analytics dashboards, summary cards, or KPI widgets.
///
/// Usage:
/// ```dart
/// const SkeletonDashboardCard()
/// ```
class SkeletonDashboardCard extends StatelessWidget {
  const SkeletonDashboardCard({super.key, this.showIcon = true});

  /// Whether to show an icon placeholder on the left.
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
