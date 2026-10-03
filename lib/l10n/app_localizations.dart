import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'SecondLife'**
  String get appName;

  /// Libellé du bouton de validation générique
  ///
  /// In fr, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Libellé du bouton d'annulation
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// Libellé du bouton de confirmation
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// Libellé du bouton de nouvelle tentative
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// Libellé du bouton de sauvegarde
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// Libellé du bouton de fermeture
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// Libellé du bouton de navigation vers l'étape suivante
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get commonNext;

  /// Libellé du bouton de retour
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get commonBack;

  /// Message affiché pendant le chargement
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get commonLoading;

  /// Message d'erreur générique
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get commonError;

  /// Message d'erreur réseau
  ///
  /// In fr, this message translates to:
  /// **'Connexion indisponible. Vérifie ta connexion internet.'**
  String get commonNetworkError;

  /// Bandeau affiché en haut d'un écran quand l'appareil est hors-ligne
  ///
  /// In fr, this message translates to:
  /// **'Hors-ligne — affichage des données en cache'**
  String get commonOfflineBanner;

  /// Séparateur générique entre deux options (ex: entre formulaire et OAuth)
  ///
  /// In fr, this message translates to:
  /// **'Ou'**
  String get commonOr;

  /// Séparateur DIVIDER entre formulaire email/password et boutons OAuth multiples (Google/GitHub/Apple)
  ///
  /// In fr, this message translates to:
  /// **'Ou continuer avec'**
  String get authOrContinueWith;

  /// Bouton pour ignorer l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get onboardingSkip;

  /// Tooltip/label d'accessibilité du bouton Passer
  ///
  /// In fr, this message translates to:
  /// **'Ignorer l\'introduction'**
  String get onboardingSkipTooltip;

  /// Tooltip/label d'accessibilité du bouton Suivant
  ///
  /// In fr, this message translates to:
  /// **'Aller à l\'étape suivante'**
  String get onboardingNextTooltip;

  /// Tooltip/label d'accessibilité du bouton Commencer (dernier slide)
  ///
  /// In fr, this message translates to:
  /// **'Terminer et commencer'**
  String get onboardingFinishTooltip;

  /// Bouton de fin d'onboarding (dernier slide)
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get onboardingGetStarted;

  /// Titre du slide 1 — déposer ses déchets contre des points
  ///
  /// In fr, this message translates to:
  /// **'Vos déchets ont de la valeur'**
  String get onboardingTitle1;

  /// Description du slide 1 — flux scan → dépôt → points
  ///
  /// In fr, this message translates to:
  /// **'Scannez-les, déposez-les dans un point relais. Après la pesée, vous gagnez des points.'**
  String get onboardingDescription1;

  /// Titre du slide 2 — signaler un dépôt sauvage
  ///
  /// In fr, this message translates to:
  /// **'Repérez les points noirs'**
  String get onboardingTitle2;

  /// Description du slide 2 — photo → alerte voisins → récompense après nettoyage
  ///
  /// In fr, this message translates to:
  /// **'Un tas de déchets bouche un caniveau ? Prenez-le en photo. Vos voisins sont alertés, et votre signalement est récompensé une fois le lieu nettoyé.'**
  String get onboardingDescription2;

  /// Titre du slide 3 — usage des points (nourriture, études, santé)
  ///
  /// In fr, this message translates to:
  /// **'Des points pour l\'essentiel'**
  String get onboardingTitle3;

  /// Description du slide 3 — valeur des points en biens essentiels
  ///
  /// In fr, this message translates to:
  /// **'Vos points ne se retirent pas en espèces. Ils serviront bientôt pour manger, étudier et se soigner.'**
  String get onboardingDescription3;

  /// Label d'accessibilité pour l'indicateur de progression de l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String onboardingProgressLabel(int current, int total);

  /// Titre de la notification affichée à la fin de l'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur {appName}'**
  String onboardingNotificationTitle(String appName);

  /// Corps de la notification de fin d'onboarding
  ///
  /// In fr, this message translates to:
  /// **'Votre premier dépôt vous attend — scannez un déchet dès maintenant.'**
  String get onboardingNotificationBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
