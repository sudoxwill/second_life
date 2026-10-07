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
  String get commonSeeMore => 'See more';

  @override
  String get commonInfo => 'Info';

  @override
  String commonDateTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get authOrContinueWith => 'Or continue with';

  @override
  String get authOr => 'Or';

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
  String get authErrorInvalidCredential => 'Incorrect email or password.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'An account already exists with this email.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Try again in a few minutes.';

  @override
  String get authErrorUserDisabled => 'This account has been disabled.';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authUsernameSetupTitle => 'Choose your username';

  @override
  String get authUsernameSetupSubtitle =>
      'This will be your unique identifier on Second Life.';

  @override
  String get authUsernameSetupButton => 'Continue';

  @override
  String get authUsernameTaken => 'This username is already taken';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String validationFieldRequired(String field) {
    return 'The $field field is required.';
  }

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
  String get routerScreenForgotPassword => 'Forgot password';

  @override
  String get routerScreenResetPassword => 'New password';

  @override
  String get routerScreenScanning => 'Analysing…';

  @override
  String get routerScreenPlaces => 'Recycling points';

  @override
  String get routerScreenHistory => 'History';

  @override
  String get routerScreenAgentDeposits => 'Deposits';

  @override
  String get routerScreenAgentHistory => 'Agent history';

  @override
  String routerScreenPlaceDetail(String id) {
    return 'Recycling point $id';
  }

  @override
  String get routerScreenSettings => 'Settings';

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
  String get navAgentDeposits => 'Deposits';

  @override
  String get navAnalyzeCta => 'Analyse';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeAgentRoleLabel => 'Agent';

  @override
  String get homePointsTitle => 'My points';

  @override
  String get homePointsRedeemCta => 'Redeem';

  @override
  String homePointsBalance(int amount) {
    return '$amount pts';
  }

  @override
  String homePointsPendingValidation(int amount) {
    return '+$amount pts awaiting validation';
  }

  @override
  String get homePointsNotCash =>
      'Not convertible into cash. Redeemable for vouchers at our partner.';

  @override
  String get homePendingDepositsEmpty => 'No deposits yet';

  @override
  String get homePendingDepositsTitle => 'Pending deposits';

  @override
  String get homeDepositItemBottle => 'Bottle';

  @override
  String get homeDepositItemIron => 'Iron';

  @override
  String homeDepositPointsGain(int amount) {
    return '+$amount pts';
  }

  @override
  String get homeEcoImpactTitle => 'Every action counts for the planet.';

  @override
  String get homeEcoImpactSubtitle =>
      'Recycle your plastic and metal waste and collect vouchers with your recycling points';

  @override
  String get agentStatsTreatedDeposits => 'Deposits processed';

  @override
  String get agentStatsValidatedPoints => 'Points validated';

  @override
  String get agentStockTitle => 'Deposit point stock';

  @override
  String agentStockKgCollected(int amount) {
    return '$amount kg collected';
  }

  @override
  String agentStockKgGoal(int amount) {
    return 'Goal: $amount kg';
  }

  @override
  String get agentStockSiteName => 'Bè EcoCentre';

  @override
  String get agentInfoMessage =>
      'The batch will soon be ready for collection by the municipal truck.';

  @override
  String get profileTitle => 'My profile';

  @override
  String profileStatAvailableValue(int value) {
    return '$value pts';
  }

  @override
  String get profileStatAvailableLabel => 'Available';

  @override
  String profileStatPendingValue(int value) {
    return '+$value pts';
  }

  @override
  String get profileStatPendingLabel => 'Pending';

  @override
  String profileStatRecycledValue(double value) {
    return '$value kg';
  }

  @override
  String get profileStatRecycledLabel => 'Recycled';

  @override
  String get profileAgentRole => 'Collection agent';

  @override
  String get profileCenterHours => 'Mon – Sat, 8am – 6pm';

  @override
  String get profileStatusOpen => 'Open';

  @override
  String get profileStatusClosed => 'Closed';

  @override
  String get profileSettingsTitle => 'Settings';

  @override
  String get profileSettingsNotifications => 'Notifications';

  @override
  String get profileSettingsTheme => 'Theme';

  @override
  String get profileSettingsLanguage => 'Language';

  @override
  String get profileSettingsDyslexicFont => 'Dyslexic font';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get historyTitle => 'Your activity history';

  @override
  String get historyAgentTitle => 'My validations';

  @override
  String get historyAgentEmpty => 'No validations here';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyFilterValidated => 'Approved';

  @override
  String get historyFilterRejected => 'Rejected';

  @override
  String get historyStatTotal => 'Total';

  @override
  String get historyTabWaiting => 'Pending';

  @override
  String get historyTabProcessed => 'Processed';

  @override
  String get historyTabGift => 'Rewards';

  @override
  String get historyStatusWaiting => 'Pending';

  @override
  String get historyStatusValidated => 'Approved';

  @override
  String get historyStatusRejected => 'Rejected';

  @override
  String get historyVoucherStatusActive => 'Active';

  @override
  String get historyVoucherStatusUsed => 'Used';

  @override
  String get historyVoucherStatusExpired => 'Expired';

  @override
  String get historyEmptyDepositTitle => 'No deposits yet';

  @override
  String get historyEmptyGiftTitle => 'Coming soon';

  @override
  String get historyEmptyGiftMessage =>
      'Exchanging points for rewards is coming very soon.';

  @override
  String get historyInfoTitle => 'Information';

  @override
  String get historyQrHint => 'Show this code to the relay point agent';

  @override
  String historyPointsPending(int amount) {
    return '+$amount pts pending';
  }

  @override
  String historyPointsCertified(int amount) {
    return '+$amount pts certified';
  }

  @override
  String historyPointsCredited(int amount) {
    return '+$amount pts credited';
  }

  @override
  String historyPointsSpent(int amount) {
    return '$amount pts spent';
  }

  @override
  String historyWeightReal(double weight) {
    return 'Actual weight: $weight kg';
  }

  @override
  String historyWeightEstimated(double weight) {
    return 'Estimated weight: ~$weight kg';
  }

  @override
  String historyWeightApprox(double weight) {
    return '~$weight kg';
  }

  @override
  String historyWeightComparison(double estimated, double real) {
    return 'Estimated $estimated kg → Actual $real kg';
  }

  @override
  String historyPendingCredit(int points) {
    return '$points pts will be credited after validation';
  }

  @override
  String historyVoucherRef(String code) {
    return 'Ref. $code';
  }

  @override
  String historyVoucherCode(String code) {
    return 'Code: $code';
  }

  @override
  String historyVoucherExpiry(String date) {
    return 'Expires on $date';
  }

  @override
  String historyVoucherExpiryPast(String date) {
    return 'Expired on $date';
  }

  @override
  String historyVoucherUsedDate(String date) {
    return 'Used on $date';
  }

  @override
  String historyVoucherFrom(String date) {
    return 'From $date';
  }

  @override
  String historyVoucherUntil(String date) {
    return 'Exp. $date';
  }

  @override
  String get historyVoucherConditionsTitle => 'Terms and conditions';

  @override
  String get historyVoucherConditionsBody =>
      'This voucher is valid once with the partner shown. Show the QR code at the checkout. Cannot be combined with other offers.';

  @override
  String get historyVoucherNoCash => 'No cash redemption possible';

  @override
  String get materialPlastic => 'Plastic';

  @override
  String get materialPaper => 'Paper / Cardboard';

  @override
  String get materialMetal => 'Metal';

  @override
  String get materialGlass => 'Glass';

  @override
  String get materialEwaste => 'Electronic waste';

  @override
  String get materialOrganic => 'Organic';

  @override
  String get analysisResultTitle => 'AI Analysis Result';

  @override
  String get analysisAnalyzingTitle => 'AI analysis in progress…';

  @override
  String get analysisAnalyzingSubtitle =>
      'Identifying the material and estimating the weight';

  @override
  String analysisDetected(String item) {
    return 'Detected: $item';
  }

  @override
  String analysisConfidenceScore(String percent) {
    return 'Confidence $percent';
  }

  @override
  String get analysisTipsTitle => 'Sorting tips';

  @override
  String get analysisTipsSeeMore => 'Read more';

  @override
  String get analysisNonRecyclable =>
      'This waste is not accepted at relay points.';

  @override
  String get analysisImportantLabel => 'Important: ';

  @override
  String get analysisImportantBody =>
      'points will be credited after the actual weighing by a relay agent. The final calculation is based on the actual weight.';

  @override
  String get analysisSaveDeposit => 'Save deposit';

  @override
  String analysisDepositSaved(String code) {
    return 'Deposit $code saved to your history';
  }

  @override
  String get analysisScanAgain => 'Scan another item';

  @override
  String get analysisEstimatedPoints => 'estimated pts';

  @override
  String analysisEstimatedWeight(String weight) {
    return 'AI estimated weight: ~$weight kg';
  }

  @override
  String get analysisConfidenceIndex => 'AI recognition index';

  @override
  String get analysisQrTitle => 'Deposit QR Code to present to the agent';

  @override
  String get analysisQrPlaceholder => 'ID: GENERATED AT DEPOSIT';

  @override
  String analysisQrId(String code) {
    return 'ID: $code';
  }

  @override
  String get analysisQrCaption =>
      'Present this QR code to a relay point agent for certified weighing.';

  @override
  String get scanAiBranding => 'SecondLife Vision AI';

  @override
  String get scanTooltipImport => 'Import a photo';

  @override
  String get scanTooltipFlash => 'Flashlight';

  @override
  String get scanTooltipCapture => 'Take photo';

  @override
  String get scanHintImport => 'Import a photo of the waste';

  @override
  String get scanHintFrame => 'Position the waste in the frame';

  @override
  String get scanCaptureError => 'The photo could not be taken.';

  @override
  String get scanGalleryError => 'Unable to open the image.';

  @override
  String get scanCameraUnavailable =>
      'Camera unavailable. Allow camera access or import a photo.';

  @override
  String get scanCameraOpening => 'Opening camera…';

  @override
  String get placesCategoryRelay => 'Drop-off points';

  @override
  String get placesCategoryRecycling => 'Recycling centres';

  @override
  String placesNearbyCount(int count) {
    return 'Nearby points ($count)';
  }

  @override
  String get placesPillRelay => 'Relay weighing points';

  @override
  String get placesPillRecycling => 'Recycling centres';

  @override
  String get placesCollapse => 'Collapse';

  @override
  String get placesSeeAll => 'See all';

  @override
  String get placesEmptyTitle => 'No points found';

  @override
  String get placesEmptyRelay => 'No relay point matches your search.';

  @override
  String get placesEmptyRecycling => 'No recycling site matches your search.';

  @override
  String get placesLocateTooltip => 'My location';

  @override
  String get placesLocateError => 'Enable location to see nearby points.';

  @override
  String get placesLegendRelay => 'Relay points (drop-off & weighing)';

  @override
  String get placesLegendRecycling => 'Recycling (information)';

  @override
  String get placesSearchHintDefault => 'Search a city, district or point';

  @override
  String placesSearchHintCity(String city) {
    return 'Search a point in $city';
  }

  @override
  String placesSearchHintCityDistricts(String city, String districts) {
    return 'Search a point in $city ($districts…)';
  }

  @override
  String placesSearchHintCities(String cities) {
    return 'Search a city or district ($cities…)';
  }

  @override
  String get placesOpen => 'Open';

  @override
  String get placesClosed => 'Closed';

  @override
  String get placesDetails => 'Details';

  @override
  String get placesAgentPresent => 'Agent present today';

  @override
  String get placesRoute => 'Directions';

  @override
  String placesClosesAt(String time) {
    return 'Closes at $time';
  }

  @override
  String placesOpensAt(String time) {
    return 'Opens at $time';
  }

  @override
  String placesOpensDayAt(String day, String time) {
    return 'Opens $day at $time';
  }

  @override
  String get placeDetailNotFound => 'Point not found';

  @override
  String get placeDetailNotFoundMessage =>
      'This point no longer exists or is no longer active.';

  @override
  String get placeDetailRoute => 'Open in Maps (Directions)';

  @override
  String get placeDetailAgentPresent =>
      'Agent present today (immediate certified weighing)';

  @override
  String get placeDetailMaterialsTitle => 'Accepted waste types';

  @override
  String get placeDetailHoursTitle => 'Opening hours';

  @override
  String get placeDetailLaunchError => 'Unable to open this application.';

  @override
  String depositRelayPoint(String name) {
    return 'Relay point: $name';
  }

  @override
  String depositPendingCount(int count) {
    return '$count pending';
  }

  @override
  String get depositRefreshHint => 'Pull down to refresh.';

  @override
  String depositAiWeight(String weight) {
    return 'AI weight: ~$weight kg';
  }

  @override
  String get depositWeighButton => 'Proceed to weighing';
}
