import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../providers/onboarding_provider.dart";

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      // En cas d'erreur de lecture, on repasse par l'onboarding plutôt que de
      // rester bloqué sur la splash.
      bool onboardingDone;
      try {
        onboardingDone = await ref.read(onboardingControllerProvider.future);
      } catch (_) {
        onboardingDone = false;
      }
      if (!mounted) return;

      if (onboardingDone) {
        context.goAuthLogin();
      } else {
        context.goOnboarding();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, -0.075),
                end: const Offset(0, 0.075),
              ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
          child: Card(
            elevation: AppSpacing.elevationSm,
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedXxl,
            ),
            child: Container(
              height: AppSpacing.exa * 1.25,
              width: AppSpacing.exa * 1.25,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurface,
                borderRadius: AppSpacing.roundedXxl,
              ),
              child: Image.asset(AppAssets.logo),
            ),
          ),
        ),
      ),
    );
  }
}
