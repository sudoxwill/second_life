import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";

// Mise en page commune des écrans d'authentification : illustration sur un
// halo vert, titre et sous-titre, formulaire dans une carte, puis actions.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    required this.illustration,
    required this.title,
    required this.form,
    super.key,
    this.subtitle,
    this.footer,
    this.showBack = false,
  });

  // Chemin d'image (assets) ou widget déjà construit.
  final Object illustration;
  final String title;
  final String? subtitle;
  final Widget form;
  final Widget? footer;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    var index = 0;
    Widget appear(Widget child) => FadeSlideIn(index: index++, child: child);

    return AppScaffold(
      scrollable: true,
      resizeToAvoidBottomInset: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      appBar: showBack
          ? AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                tooltip: context.l10n.commonBack,
                icon: const Icon(LucideIcons.arrowLeft),
                onPressed: () {
                  final router = GoRouter.of(context);
                  router.canPop() ? router.pop() : context.goAuthLogin();
                },
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!showBack) AppSpacing.gapVXl,
          appear(_Hero(illustration: illustration)),
          AppSpacing.gapVLg,
          appear(
            Column(
              spacing: AppSpacing.xs,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          AppSpacing.gapVXl,
          appear(AppCard(padding: AppSpacing.cardPadding, child: form)),
          if (footer != null) ...[AppSpacing.gapVLg, appear(footer!)],
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.illustration});

  final Object illustration;

  static const _size = 168.0;

  @override
  Widget build(BuildContext context) {
    final image = switch (illustration) {
      final String asset => Image.asset(asset, width: _size, height: _size),
      final Widget widget => widget,
      _ => const SizedBox.shrink(),
    };
    return Center(
      child: Container(
        width: _size + 32,
        height: _size + 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              context.primarySoft,
              context.primarySoft.withValues(alpha: 0),
            ],
          ),
        ),
        child: image,
      ),
    );
  }
}

// Lien "Pas de compte ? Créer un compte" sous les formulaires.
class AuthSwitchLink extends StatelessWidget {
  const AuthSwitchLink({
    required this.question,
    required this.action,
    required this.onTap,
    super.key,
  });

  final String question;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(question, style: context.textTheme.bodyMedium),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: AppSpacing.insetHSm,
            minimumSize: const Size(0, AppSpacing.tapTargetMin),
          ),
          child: Text(
            action,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}
