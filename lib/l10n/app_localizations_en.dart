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

  @override
  String get authLoginTitle => 'Sign in';

  @override
  String get authLoginButton => 'Sign in';

  @override
  String get authSignupTitle => 'Create an account';

  @override
  String get authSignupButton => 'Sign up';

  @override
  String get authEmailLabel => 'Email address';

  @override
  String get authEmailHint => 'you@email.com';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authUsernameHint => 'Ama Kwatcha';

  @override
  String get authAlreadyHaveAccount => 'Already have an account?';

  @override
  String get authNoAccount => 'No account yet?';

  @override
  String get authLoginLink => 'Sign in';

  @override
  String get authSignupLink => 'Create an account';

  @override
  String get authOAuthGoogle => 'Continue with Google';

  @override
  String authSignupSuccess(String username) {
    return 'Account created! Welcome $username!';
  }

  @override
  String get authLogout => 'Sign out';

  @override
  String get authLogoutButton => 'Sign out';

  @override
  String get authLogoutConfirmTitle => 'Sign out?';

  @override
  String get authLogoutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get authLogoutSuccess => 'Signed out successfully.';

  @override
  String authLoginSuccess(String username) {
    return 'Welcome back, $username!';
  }

  @override
  String get authLoginError => 'Failed to sign in. Check your credentials.';

  @override
  String get authSignupError => 'Failed to create account. Try again.';

  @override
  String get authLogoutError => 'Failed to sign out. Try again.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationInvalidEmail => 'Invalid email address.';

  @override
  String get validationEmailIncorrect => 'Incorrect email address.';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters.';

  @override
  String get validationPasswordsDoNotMatch => 'Passwords do not match.';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'At least $minLength characters.';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '$maxLength characters max.';
  }

  @override
  String get validationUsernameInvalid => 'Letters, numbers and _ only.';

  @override
  String get routerErrorTitle => 'This screen does not exist yet.';

  @override
  String get routerErrorSubtitle => 'Come back later, or return to home.';

  @override
  String routerSoon(String title) {
    return '$title — coming soon.';
  }

  @override
  String get errorNetwork => 'Network error. Check your internet connection.';

  @override
  String get errorServer => 'Server error. Try again later.';

  @override
  String get errorValidation => 'Invalid data. Check the fields.';

  @override
  String get errorUnknown => 'An unknown error occurred.';

  @override
  String get navHome => 'Home';

  @override
  String get navPlaces => 'Places';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get navAnalyzeCta => 'Analyse';
}
