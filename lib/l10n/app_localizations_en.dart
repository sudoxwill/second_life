// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SecondLife';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonSave => 'Save';

  @override
  String get commonClose => 'Close';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonNetworkError => 'No connection. Check your internet.';

  @override
  String get commonOfflineBanner => 'Offline — showing cached data';

  @override
  String get commonOr => 'Or';

  @override
  String get authOrContinueWith => 'Or continue with';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingSkipTooltip => 'Skip the introduction';

  @override
  String get onboardingNextTooltip => 'Go to next step';

  @override
  String get onboardingFinishTooltip => 'Finish and get started';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingTitle1 => 'Your waste has value';

  @override
  String get onboardingDescription1 =>
      'Scan it, drop it off at a relay point. After weighing, you earn points.';

  @override
  String get onboardingTitle2 => 'Spot the trouble spots';

  @override
  String get onboardingDescription2 =>
      'See waste blocking a drain? Take a photo. Your neighbours are alerted, and your report is rewarded once the area is cleaned.';

  @override
  String get onboardingTitle3 => 'Points for what matters';

  @override
  String get onboardingDescription3 =>
      'Your points can\'t be withdrawn as cash. They\'ll soon be used for food, education and healthcare.';

  @override
  String onboardingProgressLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String onboardingNotificationTitle(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get onboardingNotificationBody =>
      'Your first drop-off awaits — scan a waste item now.';
}
