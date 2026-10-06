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

  /// Bouton générique affichant la liste complète (ex: tous les dépôts en attente)
  ///
  /// In fr, this message translates to:
  /// **'Voir plus'**
  String get commonSeeMore;

  /// Titre générique d'une carte d'information ou de rappel
  ///
  /// In fr, this message translates to:
  /// **'Info'**
  String get commonInfo;

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

  /// Titre de la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get authLoginTitle;

  /// Libellé du bouton de connexion
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginButton;

  /// Titre de la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get authSignupTitle;

  /// Libellé du bouton d'inscription
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get authSignupButton;

  /// Label du champ e-mail
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// Placeholder du champ e-mail
  ///
  /// In fr, this message translates to:
  /// **'ton@email.com'**
  String get authEmailHint;

  /// Label du champ nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Nom d\'utilisateur'**
  String get authUsernameLabel;

  /// Placeholder du champ de nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Ama Kwatcha'**
  String get authUsernameHint;

  /// Texte précédant le lien vers la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get authAlreadyHaveAccount;

  /// Texte précédant le lien vers la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Pas de compte ?'**
  String get authNoAccount;

  /// Lien vers la page de connexion
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get authLoginLink;

  /// Lien vers la page d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get authSignupLink;

  /// Bouton OAuth — continuer avec Google
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get authOAuthGoogle;

  /// Message de succès après inscription avec pseudo
  ///
  /// In fr, this message translates to:
  /// **'Compte créé ! Bienvenue {username} !'**
  String authSignupSuccess(String username);

  /// Libellé générique de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get authLogout;

  /// Bouton de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get authLogoutButton;

  /// Titre du dialogue de confirmation de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter ?'**
  String get authLogoutConfirmTitle;

  /// Message du dialogue de confirmation de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Es-tu sûr de vouloir te déconnecter ?'**
  String get authLogoutConfirmMessage;

  /// Message de succès après déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Déconnecté avec succès.'**
  String get authLogoutSuccess;

  /// Message de succès après connexion
  ///
  /// In fr, this message translates to:
  /// **'Connexion réussie ! Ravie de te revoir, {username} !'**
  String authLoginSuccess(String username);

  /// Message d'erreur générique après échec de connexion
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion. Vérifie tes identifiants.'**
  String get authLoginError;

  /// Message d'erreur générique après échec d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'inscription. Réessaie.'**
  String get authSignupError;

  /// Message d'erreur après échec de déconnexion
  ///
  /// In fr, this message translates to:
  /// **'Échec de la déconnexion. Réessaie.'**
  String get authLogoutError;

  /// Message d'erreur pour un champ obligatoire vide
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire.'**
  String get validationRequired;

  /// Message d'erreur d'un champ obligatoire, citant son libellé
  ///
  /// In fr, this message translates to:
  /// **'L\'attribut {field} est requis.'**
  String validationFieldRequired(String field);

  /// Message d'erreur pour un e-mail mal formaté
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide.'**
  String get validationInvalidEmail;

  /// Message d'erreur pour un e-mail ne correspondant à aucun compte / incorrect lors de la connexion
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail incorrecte.'**
  String get validationEmailIncorrect;

  /// Message d'erreur pour un mot de passe trop court
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères.'**
  String get validationPasswordTooShort;

  /// Message d'erreur quand les deux mots de passe diffèrent
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas.'**
  String get validationPasswordsDoNotMatch;

  /// Message d'erreur quand le nom d'utilisateur est trop court
  ///
  /// In fr, this message translates to:
  /// **'Au moins {minLength} caractères.'**
  String validationUsernameTooShort(int minLength);

  /// Message d'erreur quand le nom d'utilisateur est trop long
  ///
  /// In fr, this message translates to:
  /// **'{maxLength} caractères maximum.'**
  String validationUsernameTooLong(int maxLength);

  /// Message d'erreur quand le nom d'utilisateur contient des caractères invalides
  ///
  /// In fr, this message translates to:
  /// **'Lettres, chiffres et _ uniquement.'**
  String get validationUsernameInvalid;

  /// Titre de la page d'erreur de routing
  ///
  /// In fr, this message translates to:
  /// **'Cet écran n\'existe pas encore.'**
  String get routerErrorTitle;

  /// Sous-titre de la page d'erreur de routing
  ///
  /// In fr, this message translates to:
  /// **'Reviens plus tard, ou reprends depuis l\'accueil.'**
  String get routerErrorSubtitle;

  /// Placeholder générique pour écran bientôt disponible
  ///
  /// In fr, this message translates to:
  /// **'{title} — bientôt.'**
  String routerSoon(String title);

  /// Titre de l'écran placeholder de réinitialisation par e-mail
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get routerScreenForgotPassword;

  /// Titre de l'écran placeholder de choix d'un nouveau mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get routerScreenResetPassword;

  /// Titre de l'écran placeholder de scan d'un déchet
  ///
  /// In fr, this message translates to:
  /// **'Analyse en cours…'**
  String get routerScreenScanning;

  /// Titre de l'écran placeholder de la carte des points de recyclage
  ///
  /// In fr, this message translates to:
  /// **'Points de recyclage'**
  String get routerScreenPlaces;

  /// Titre de l'écran placeholder de l'historique utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get routerScreenHistory;

  /// Titre de l'écran placeholder du profil utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get routerScreenProfile;

  /// Titre de l'écran placeholder de la liste des dépôts à traiter
  ///
  /// In fr, this message translates to:
  /// **'Dépôts'**
  String get routerScreenAgentDeposits;

  /// Titre de l'écran placeholder de l'historique agent
  ///
  /// In fr, this message translates to:
  /// **'Historique agent'**
  String get routerScreenAgentHistory;

  /// Titre de l'écran placeholder du profil agent
  ///
  /// In fr, this message translates to:
  /// **'Profil agent'**
  String get routerScreenAgentProfile;

  /// Titre de l'écran placeholder du détail d'un point de recyclage
  ///
  /// In fr, this message translates to:
  /// **'Point de recyclage {id}'**
  String routerScreenPlaceDetail(String id);

  /// Titre de l'écran placeholder des paramètres
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get routerScreenSettings;

  /// Erreur réseau générique (NetworkFailure)
  ///
  /// In fr, this message translates to:
  /// **'Erreur réseau. Vérifie ta connexion internet.'**
  String get errorNetwork;

  /// Erreur serveur générique (ServerFailure)
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur. Réessaie plus tard.'**
  String get errorServer;

  /// Erreur de validation générique (ValidationFailure)
  ///
  /// In fr, this message translates to:
  /// **'Données invalides. Vérifie les champs.'**
  String get errorValidation;

  /// Erreur inconnue (fallback Failure)
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inconnue est survenue.'**
  String get errorUnknown;

  /// Label de la destination Accueil dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Label de la destination Map dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get navPlaces;

  /// Label de la destination History dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get navHistory;

  /// Label de la destination Profile dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// Label de l'onglet Dépôts dans le shell agent
  ///
  /// In fr, this message translates to:
  /// **'Dépôts'**
  String get navAgentDeposits;

  /// Label de la destination Analyse du FAB dans la barre de navigation
  ///
  /// In fr, this message translates to:
  /// **'Analyser'**
  String get navAnalyzeCta;

  /// Titre de la page d'accueil, personnalisé avec le prénom de l'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String homeGreeting(String name);

  /// Rôle de l'utilisateur connecté, utilisé à la place du prénom dans le titre de l'accueil agent
  ///
  /// In fr, this message translates to:
  /// **'Agent'**
  String get homeAgentRoleLabel;

  /// Titre de la carte de solde de points sur l'accueil
  ///
  /// In fr, this message translates to:
  /// **'Mes points'**
  String get homePointsTitle;

  /// Bouton d'échange des points contre des bons chez le partenaire
  ///
  /// In fr, this message translates to:
  /// **'Échanger'**
  String get homePointsRedeemCta;

  /// Solde de points affiché sur la carte principale de l'accueil
  ///
  /// In fr, this message translates to:
  /// **'{amount} pts'**
  String homePointsBalance(int amount);

  /// Pastille indiquant les points gagnés mais pas encore validés
  ///
  /// In fr, this message translates to:
  /// **'+{amount} pts en attente de validation'**
  String homePointsPendingValidation(int amount);

  /// Explication sous le solde de points : les points ne sont pas convertis en espèces
  ///
  /// In fr, this message translates to:
  /// **'Non convertie en argent liquide. Échangeable contre des bons chez le partenaire.'**
  String get homePointsNotCash;

  /// Titre de la carte listant les dépôts en attente de validation
  ///
  /// In fr, this message translates to:
  /// **'Dépôts en attente'**
  String get homePendingDepositsTitle;

  /// Type de déchet déposé : bouteille
  ///
  /// In fr, this message translates to:
  /// **'Bouteille'**
  String get homeDepositItemBottle;

  /// Type de déchet déposé : fer
  ///
  /// In fr, this message translates to:
  /// **'Fer'**
  String get homeDepositItemIron;

  /// Points gagnés par un dépôt, affichés dans la liste des dépôts en attente
  ///
  /// In fr, this message translates to:
  /// **'+{amount} pts'**
  String homeDepositPointsGain(int amount);

  /// Titre de la carte d'impact environnemental sur l'accueil
  ///
  /// In fr, this message translates to:
  /// **'Chaque geste compte pour la planète.'**
  String get homeEcoImpactTitle;

  /// Sous-titre de la carte d'impact environnemental : explication du recyclage contre des bons
  ///
  /// In fr, this message translates to:
  /// **'Recyclez vos déchets plastiques et métalliques et récupérez des bons avec vos points de recyclage'**
  String get homeEcoImpactSubtitle;

  /// Label de la stat card Dépôts traités sur le dashboard agent
  ///
  /// In fr, this message translates to:
  /// **'Dépôts traités'**
  String get agentStatsTreatedDeposits;

  /// Label de la stat card Points validés sur le dashboard agent
  ///
  /// In fr, this message translates to:
  /// **'Points validés'**
  String get agentStatsValidatedPoints;

  /// Titre de la card stock sur le dashboard agent
  ///
  /// In fr, this message translates to:
  /// **'Stock du point de dépôt'**
  String get agentStockTitle;

  /// Kilogrammes récoltés affichés dans la card stock
  ///
  /// In fr, this message translates to:
  /// **'{amount} kg récoltés'**
  String agentStockKgCollected(int amount);

  /// Objectif en kilogrammes affiché dans la card stock
  ///
  /// In fr, this message translates to:
  /// **'Objectif : {amount} kg'**
  String agentStockKgGoal(int amount);

  /// Nom du point de dépôt affiché sous le titre de la card stock
  ///
  /// In fr, this message translates to:
  /// **'EcoCentre de Bè'**
  String get agentStockSiteName;

  /// Message d'information du dashboard agent sur l'enlèvement du lot en cours
  ///
  /// In fr, this message translates to:
  /// **'LOT bientôt prêt pour l\'enlèvement par le camion municipal.'**
  String get agentInfoMessage;
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
