import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/configs/app_config.dart";
import "../../../../core/constants/app_assets.dart";
import "../../../../core/constants/notification_channels.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/providers/notification_provider.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../providers/onboarding_provider.dart";

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageViewController;
  var _current = 0;

  static const _slideCount = 3;

  // TODO Find more interesting images to use
  static const _slideImages = [
    AppAssets.step1,
    AppAssets.step2,
    AppAssets.step3,
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: _current);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final image in _slideImages) {
      precacheImage(AssetImage(image), context);
    }
  }

  bool get _isLast => _current == _slideCount - 1;

  Future<void> _finish() async {
    final l10n = context.l10n;
    await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    await ref
        .read(notificationServiceProvider)
        .show(
          id: NotificationId.welcome,
          title: l10n.onboardingNotificationTitle(AppConfig.instance.appName),
          body: l10n.onboardingNotificationBody,
        );
    if (mounted) context.goAuthLogin();
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _pageViewController.nextPage(
        duration: AppSpacing.durationBase,
        curve: Curves.easeInOut,
      );
    }
  }

  /*
  List<OnboardingItem> _onBoardingData(AppLocalizations l10n) => [
    (
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDescription1,
      image: AppAssets.step3,
    ),
    (
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDescription2,
      image: AppAssets.step2,
    ),
    (
      title: l10n.onboardingTitle3,
      description: l10n.onboardingDescription3,
      image: AppAssets.step3,
    ),
  ];
  */

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            ...List.generate(_slideCount, (i) {
              return AnimatedOpacity(
                duration: AppSpacing.durationSlow,
                opacity: i == _current ? 1.0 : 0.0,
                curve: Curves.easeInOut,
                child: Image.asset(
                  _slideImages[i],
                  fit: .cover,
                  gaplessPlayback: true,
                  color: Colors.black.withValues(alpha: 0.5),
                  colorBlendMode: BlendMode.darken,
                ),
              );
            }),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: AppSpacing.insetHMd,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: l10n.onboardingProgressLabel(
                            _current + 1,
                            _slideCount,
                          ),
                          excludeSemantics: true,
                          child: Row(
                            mainAxisSize: .min,
                            children: List.generate(_slideCount, (i) {
                              final isActive = i == _current;
                              return AnimatedContainer(
                                duration: AppSpacing.durationBase,
                                curve: AppSpacing.curveDefault,
                                width: isActive
                                    ? AppSpacing.xl
                                    : AppSpacing.sm + 2,
                                height: AppSpacing.sm + 2,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs / 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.textInverse
                                      : AppColors.textInverse.withAlpha(100),
                                  borderRadius: AppSpacing.roundedFull,
                                ),
                              );
                            }),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _isLast ? 0.0 : 1.0,
                          duration: AppSpacing.durationBase,
                          curve: AppSpacing.curveDefault,
                          child: IgnorePointer(
                            ignoring: _isLast,
                            child: TextButton(
                              onPressed: _finish,
                              child: Text(
                                l10n.onboardingSkip,
                                semanticsLabel: l10n.onboardingSkipTooltip,
                                style: textTheme.titleSmall!.copyWith(
                                  color: AppColors.textInverse,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Slides
                  Expanded(
                    child: PageView(
                      controller: _pageViewController,
                      onPageChanged: (v) => setState(() => _current = v),
                      children: [
                        _OnboardingSlide(
                          title: l10n.onboardingTitle1,
                          description: l10n.onboardingDescription1,
                        ),
                        _OnboardingSlide(
                          title: l10n.onboardingTitle2,
                          description: l10n.onboardingDescription2,
                        ),
                        _OnboardingSlide(
                          title: l10n.onboardingTitle3,
                          description: l10n.onboardingDescription3,
                        ),
                      ],
                    ),
                  ),

                  // Bouton CTA
                  _ButtonSection(isLast: _isLast, onNext: _next),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonSection extends StatelessWidget {
  const _ButtonSection({required this._isLast, this.onNext});

  final bool _isLast;
  final void Function()? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      label: _isLast
          ? l10n.onboardingFinishTooltip
          : l10n.onboardingNextTooltip,
      child: AppElevatedButton(
        onPressed: onNext,
        text: _isLast
            ? l10n.onboardingGetStarted
            : l10n.commonNext,
        margin: AppSpacing.insetVMd,
        icon: const Icon(
          LucideIcons.arrowRight,
          size: AppSpacing.iconLg,
        ),
        iconAlignment: .end,
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Padding(
      padding: AppSpacing.insetMd,
      child: Column(
        spacing: AppSpacing.md,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.screenWidth * .8,
            child: Text(
              title,
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textInverse,
              ),
            ),
          ),
          Text(
            description,
            style: textTheme.bodySmall!.copyWith(
              color: AppColors.textInverse.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}

typedef OnboardingItem = ({String title, String description, String image});
