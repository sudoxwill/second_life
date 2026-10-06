import "package:flutter/material.dart";
import "package:flutter/services.dart" show SystemUiOverlayStyle;
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    super.key,
    this.onPopInvokedWithResult,
    this.canPop = true,
    this.bottomNavigationBar,
    this.body,
    this.padding = AppSpacing.screenPadding,
    this.appBar,
    this.color,
    this.statusBarColor,
    this.bottomSafeArea = true,
    this.extendBody = false,
    this.resizeToAvoidBottomInset = false,
    this.scrollable = false,
    this.scrollReverse = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundBuilder,
    this.onRefresh,
    this.showOfflineBanner = false,
  });

  // Retour arrière

  final void Function(bool, Object?)? onPopInvokedWithResult;
  final bool canPop;

  // Mise en page

  final Widget? body;
  final Widget? bottomNavigationBar;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final Color? color;
  final Color? statusBarColor;
  final bool bottomSafeArea;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final bool scrollable;
  final bool scrollReverse;

  // Bouton flottant

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  // Arrière-plan

  final Widget Function(Widget child)? backgroundBuilder;

  // Tirer pour rafraîchir

  /// Active aussi [scrollable].
  final Future<void> Function()? onRefresh;
  final bool showOfflineBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = context.isDarkMode;

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? theme.scaffoldBackgroundColor,
      statusBarIconBrightness: isDarkMode
          ? Brightness.light
          : Brightness.dark, // Android
      statusBarBrightness: isDarkMode
          ? Brightness.dark
          : Brightness.light, // iOS
    );

    final isScrollable = scrollable || onRefresh != null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: Scaffold(
          appBar: appBar,
          extendBody: extendBody,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          backgroundColor: color ?? theme.scaffoldBackgroundColor,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,

          body: SafeArea(
            bottom: bottomSafeArea && !extendBody,
            child: Builder(
              builder: (context) {
                final resolvedPadding = padding.resolve(
                  Directionality.of(context),
                );

                // La SafeArea gère déjà les barres système : on n'ajoute que
                // la marge voulue par l'appelant. Sous une barre du bas
                // (extendBody), on retire la marge du bas.
                final effectivePadding = extendBody
                    ? resolvedPadding.copyWith(bottom: 0)
                    : resolvedPadding;

                Widget content;

                if (isScrollable) {
                  // AlwaysScrollable : le rafraîchissement reste possible
                  // même quand le contenu est plus court que l'écran.
                  content = SingleChildScrollView(
                    physics: onRefresh != null
                        ? const AlwaysScrollableScrollPhysics()
                        : null,
                    reverse: scrollReverse,
                    child: Padding(
                      padding: effectivePadding,
                      child: body,
                    ),
                  );

                  if (onRefresh != null) {
                    content = RefreshIndicator(
                      onRefresh: onRefresh!,
                      child: content,
                    );
                  }
                } else {
                  // Sans défilement
                  content = Container(
                    constraints: const BoxConstraints.expand(),
                    color: color,
                    padding: effectivePadding,
                    child: body,
                  );
                }

                if (backgroundBuilder != null && body != null) {
                  content = backgroundBuilder!(content);
                }

                return content;
              },
            ),
          ),
        ),
      ),
    );
  }
}
