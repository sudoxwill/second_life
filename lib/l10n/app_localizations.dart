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

  /// Assemblage d'une date et d'une heure déjà formatées (ex: carte d'historique)
  ///
  /// In fr, this message translates to:
  /// **'{date} à {time}'**
  String commonDateTime(String date, String time);

  /// Séparateur DIVIDER entre formulaire email/password et boutons OAuth multiples (Google/GitHub/Apple)
  ///
  /// In fr, this message translates to:
  /// **'Ou continuer avec'**
  String get authOrContinueWith;

  /// Séparateur DIVIDER entre formulaire email/password et boutons OAuth multiples (Google/GitHub/Apple)
  ///
  /// In fr, this message translates to:
  /// **'Ou'**
  String get authOr;

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

  /// Erreur quand l'email ou le mot de passe est incorrect (code Firebase : invalid-credential, wrong-password, user-not-found)
  ///
  /// In fr, this message translates to:
  /// **'Email ou mot de passe incorrect.'**
  String get authErrorInvalidCredential;

  /// Erreur à l'inscription quand l'email est déjà utilisé
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet email.'**
  String get authErrorEmailAlreadyInUse;

  /// Erreur quand Firebase bloque les tentatives de connexion
  ///
  /// In fr, this message translates to:
  /// **'Trop de tentatives. Réessaie dans quelques minutes.'**
  String get authErrorTooManyRequests;

  /// Erreur quand le compte est désactivé dans Firebase
  ///
  /// In fr, this message translates to:
  /// **'Ce compte a été désactivé.'**
  String get authErrorUserDisabled;

  /// Label du champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get authPasswordLabel;

  /// Placeholder du champ mot de passe
  ///
  /// In fr, this message translates to:
  /// **'••••••••'**
  String get authPasswordHint;

  /// Label du champ de confirmation du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get authConfirmPasswordLabel;

  /// Sous-titre de l'écran de connexion
  ///
  /// In fr, this message translates to:
  /// **'Content de te revoir ! Connecte-toi pour suivre tes points.'**
  String get authLoginSubtitle;

  /// Sous-titre de l'écran d'inscription
  ///
  /// In fr, this message translates to:
  /// **'Crée ton compte et transforme tes déchets en récompenses.'**
  String get authSignupSubtitle;

  /// Robustesse du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get authPasswordStrengthWeak;

  /// Robustesse du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get authPasswordStrengthMedium;

  /// Robustesse du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Robuste'**
  String get authPasswordStrengthStrong;

  /// Lien vers la page de réinitialisation du mot de passe
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get authForgotPassword;

  /// Titre de la page de choix du nom d'utilisateur (après OAuth)
  ///
  /// In fr, this message translates to:
  /// **'Choisis ton nom'**
  String get authUsernameSetupTitle;

  /// Sous-titre explicatif de la page de choix du nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Ce nom sera ton identifiant unique sur Second Life.'**
  String get authUsernameSetupSubtitle;

  /// Bouton de validation du nom d'utilisateur
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get authUsernameSetupButton;

  /// Erreur affichée quand le nom d'utilisateur est déjà pris
  ///
  /// In fr, this message translates to:
  /// **'Ce nom est déjà pris'**
  String get authUsernameTaken;

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

  /// Salutation au-dessus du nom, en tête des accueils
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get homeGreetingHello;

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

  /// Bouton d'accès à la boutique de récompenses depuis la carte de solde
  ///
  /// In fr, this message translates to:
  /// **'Boutique'**
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

  /// État vide de la liste des dépôts en attente
  ///
  /// In fr, this message translates to:
  /// **'Aucun dépôt en attente'**
  String get homePendingDepositsEmpty;

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

  /// Message d'information du dashboard agent sur l'enlèvement du lot en cours
  ///
  /// In fr, this message translates to:
  /// **'Lot bientôt prêt pour l\'enlèvement par le camion municipal.'**
  String get agentInfoMessage;

  /// Titre de la barre d'application des écrans de profil
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get profileTitle;

  /// Valeur des points disponibles affichée dans les statistiques du profil
  ///
  /// In fr, this message translates to:
  /// **'{value} pts'**
  String profileStatAvailableValue(int value);

  /// Libellé de la statistique points disponibles
  ///
  /// In fr, this message translates to:
  /// **'Disponibles'**
  String get profileStatAvailableLabel;

  /// Valeur des points en attente de validation affichée dans les statistiques du profil
  ///
  /// In fr, this message translates to:
  /// **'+{value} pts'**
  String profileStatPendingValue(int value);

  /// Libellé de la statistique points en attente de validation
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get profileStatPendingLabel;

  /// Poids des déchets recyclés affiché dans les statistiques du profil
  ///
  /// In fr, this message translates to:
  /// **'{value} kg'**
  String profileStatRecycledValue(double value);

  /// Libellé de la statistique poids recyclé
  ///
  /// In fr, this message translates to:
  /// **'Recyclés'**
  String get profileStatRecycledLabel;

  /// Rôle affiché sous le nom de l'agent sur son profil
  ///
  /// In fr, this message translates to:
  /// **'Agent de collecte'**
  String get profileAgentRole;

  /// Horaires d'ouverture du centre de dépôt affichés sur le profil agent
  ///
  /// In fr, this message translates to:
  /// **'Lun – Sam, 8h – 18h'**
  String get profileCenterHours;

  /// Pastille indiquant que le centre de dépôt est ouvert
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get profileStatusOpen;

  /// Pastille indiquant que le centre de dépôt est fermé
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get profileStatusClosed;

  /// Titre de la section réglages sur les pages de profil
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get profileSettingsTitle;

  /// Réglage d'activation des notifications
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get profileSettingsNotifications;

  /// Réglage du thème clair/sombre/système
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get profileSettingsTheme;

  /// Réglage de la langue de l'application
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get profileSettingsLanguage;

  /// Réglage d'activation de la police adaptée à la dyslexie
  ///
  /// In fr, this message translates to:
  /// **'Police dyslexique'**
  String get profileSettingsDyslexicFont;

  /// Option de thème clair dans le sélecteur de thème
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get profileThemeLight;

  /// Option de thème sombre dans le sélecteur de thème
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get profileThemeDark;

  /// Option de thème suivant le système dans le sélecteur de thème
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get profileThemeSystem;

  /// Titre de la barre d'application de l'écran d'historique
  ///
  /// In fr, this message translates to:
  /// **'Historique de vos activités'**
  String get historyTitle;

  /// Titre de la barre d'application de l'historique de l'agent
  ///
  /// In fr, this message translates to:
  /// **'Mes validations'**
  String get historyAgentTitle;

  /// État vide de la liste des validations de l'agent
  ///
  /// In fr, this message translates to:
  /// **'Aucune validation ici'**
  String get historyAgentEmpty;

  /// Premier filtre de l'historique agent : afficher tous les dépôts
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get historyFilterAll;

  /// Filtre de l'historique agent : afficher les dépôts validés
  ///
  /// In fr, this message translates to:
  /// **'Validés'**
  String get historyFilterValidated;

  /// Filtre de l'historique agent : afficher les dépôts refusés
  ///
  /// In fr, this message translates to:
  /// **'Refusés'**
  String get historyFilterRejected;

  /// Libellé du compteur total du résumé statistique de l'agent
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get historyStatTotal;

  /// Premier onglet de l'historique : dépôts en attente de validation
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get historyTabWaiting;

  /// Deuxième onglet de l'historique : dépôts déjà traités par un agent
  ///
  /// In fr, this message translates to:
  /// **'Traités'**
  String get historyTabProcessed;

  /// Troisième onglet de l'historique : bons et récompenses obtenus
  ///
  /// In fr, this message translates to:
  /// **'Récompenses'**
  String get historyTabGift;

  /// Badge d'état d'un dépôt encore non validé
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get historyStatusWaiting;

  /// Badge d'état d'un dépôt validé par un agent
  ///
  /// In fr, this message translates to:
  /// **'Validé'**
  String get historyStatusValidated;

  /// Badge d'état d'un dépôt refusé par un agent
  ///
  /// In fr, this message translates to:
  /// **'Refusé'**
  String get historyStatusRejected;

  /// Badge d'état d'un bon encore utilisable
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get historyVoucherStatusActive;

  /// Badge d'état d'un bon déjà utilisé
  ///
  /// In fr, this message translates to:
  /// **'Utilisé'**
  String get historyVoucherStatusUsed;

  /// Badge d'état d'un bon expiré
  ///
  /// In fr, this message translates to:
  /// **'Expiré'**
  String get historyVoucherStatusExpired;

  /// Titre de l'état vide d'un onglet de dépôts
  ///
  /// In fr, this message translates to:
  /// **'Aucun dépôt pour le moment'**
  String get historyEmptyDepositTitle;

  /// Titre de l'état vide de l'onglet récompenses
  ///
  /// In fr, this message translates to:
  /// **'Aucun bon pour l\'instant'**
  String get historyEmptyGiftTitle;

  /// Message d'accompagnement de l'état vide de l'onglet récompenses
  ///
  /// In fr, this message translates to:
  /// **'Échangez vos points contre des bons chez nos partenaires.'**
  String get historyEmptyGiftMessage;

  /// Titre du bloc d'informations d'une fiche de dépôt détaillée
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get historyInfoTitle;

  /// Consigne sous le QR code d'un dépôt en attente
  ///
  /// In fr, this message translates to:
  /// **'Présentez ce code à l\'agent du point relais'**
  String get historyQrHint;

  /// Chip de points gagnés mais pas encore validés sur une carte de dépôt
  ///
  /// In fr, this message translates to:
  /// **'+{amount} pts en attente'**
  String historyPointsPending(int amount);

  /// Chip de points définitivement acquis sur une carte de dépôt validé
  ///
  /// In fr, this message translates to:
  /// **'+{amount} pts certifiés'**
  String historyPointsCertified(int amount);

  /// Sous-titre indiquant les points déjà versés sur une fiche de dépôt validé
  ///
  /// In fr, this message translates to:
  /// **'+{amount} pts crédités'**
  String historyPointsCredited(int amount);

  /// Nombre de points utilisés pour obtenir un bon
  ///
  /// In fr, this message translates to:
  /// **'{amount} pts dépensés'**
  String historyPointsSpent(int amount);

  /// Poids constaté par l'agent sur une carte ou une fiche de dépôt
  ///
  /// In fr, this message translates to:
  /// **'Poids réel : {weight} kg'**
  String historyWeightReal(double weight);

  /// Poids avant pesée réelle sur une carte ou une fiche de dépôt
  ///
  /// In fr, this message translates to:
  /// **'Poids estimé : ~{weight} kg'**
  String historyWeightEstimated(double weight);

  /// Poids estimé affiché dans une puce de détail de dépôt
  ///
  /// In fr, this message translates to:
  /// **'~{weight} kg'**
  String historyWeightApprox(double weight);

  /// Comparaison du poids estimé et du poids réel quand ils diffèrent
  ///
  /// In fr, this message translates to:
  /// **'Estimé {estimated} kg → Réel {real} kg'**
  String historyWeightComparison(double estimated, double real);

  /// Encart d'attente rappelant les points qui seront versés après validation
  ///
  /// In fr, this message translates to:
  /// **'{points} pts seront crédités après validation'**
  String historyPendingCredit(int points);

  /// Référence du code d'un bon sous son QR code
  ///
  /// In fr, this message translates to:
  /// **'Réf. {code}'**
  String historyVoucherRef(String code);

  /// Code d'un bon affiché en clair sur sa carte
  ///
  /// In fr, this message translates to:
  /// **'Code : {code}'**
  String historyVoucherCode(String code);

  /// Date d'expiration d'un bon actif
  ///
  /// In fr, this message translates to:
  /// **'Expire le {date}'**
  String historyVoucherExpiry(String date);

  /// Date d'expiration d'un bon déjà expiré, affichée sur le QR code barré
  ///
  /// In fr, this message translates to:
  /// **'Expiré le {date}'**
  String historyVoucherExpiryPast(String date);

  /// Date d'utilisation d'un bon déjà utilisé, affichée sur le QR code barré
  ///
  /// In fr, this message translates to:
  /// **'Utilisé le {date}'**
  String historyVoucherUsedDate(String date);

  /// Date d'obtention d'un bon en format compact sur sa carte
  ///
  /// In fr, this message translates to:
  /// **'Du {date}'**
  String historyVoucherFrom(String date);

  /// Date d'expiration en format compact sur la carte d'un bon
  ///
  /// In fr, this message translates to:
  /// **'Exp. {date}'**
  String historyVoucherUntil(String date);

  /// Titre du bloc des conditions d'un bon
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get historyVoucherConditionsTitle;

  /// Conditions d'utilisation détaillées d'un bon
  ///
  /// In fr, this message translates to:
  /// **'Ce bon est valable une seule fois auprès du partenaire indiqué. Présentez le QR code à la caisse. Non cumulable avec d\'autres offres.'**
  String get historyVoucherConditionsBody;

  /// Avertissement : un bon ne peut pas être échangé contre du cash
  ///
  /// In fr, this message translates to:
  /// **'Aucun retrait en espèces possible'**
  String get historyVoucherNoCash;

  /// Libellé du matériau plastique
  ///
  /// In fr, this message translates to:
  /// **'Plastique'**
  String get materialPlastic;

  /// Libellé du matériau papier et carton
  ///
  /// In fr, this message translates to:
  /// **'Papier / Carton'**
  String get materialPaper;

  /// Libellé du matériau métal
  ///
  /// In fr, this message translates to:
  /// **'Métal'**
  String get materialMetal;

  /// Libellé du matériau verre
  ///
  /// In fr, this message translates to:
  /// **'Verre'**
  String get materialGlass;

  /// Libellé du matériau déchets électroniques
  ///
  /// In fr, this message translates to:
  /// **'Déchets électroniques'**
  String get materialEwaste;

  /// Libellé du matériau déchets organiques
  ///
  /// In fr, this message translates to:
  /// **'Organique'**
  String get materialOrganic;

  /// Titre de la page résultat d'analyse
  ///
  /// In fr, this message translates to:
  /// **'Résultat de l\'analyse IA'**
  String get analysisResultTitle;

  /// Titre affiché pendant l'analyse
  ///
  /// In fr, this message translates to:
  /// **'Analyse par l\'IA en cours…'**
  String get analysisAnalyzingTitle;

  /// Sous-titre affiché pendant l'analyse
  ///
  /// In fr, this message translates to:
  /// **'Identification de la matière et estimation du poids'**
  String get analysisAnalyzingSubtitle;

  /// Libellé overlay photo : objet détecté par l'IA
  ///
  /// In fr, this message translates to:
  /// **'Détecté : {item}'**
  String analysisDetected(String item);

  /// Score de confiance de l'IA affiché sur la photo et dans la carte
  ///
  /// In fr, this message translates to:
  /// **'Confiance {percent}'**
  String analysisConfidenceScore(String percent);

  /// Titre de la carte des conseils de tri
  ///
  /// In fr, this message translates to:
  /// **'Conseils de tri'**
  String get analysisTipsTitle;

  /// Lien pour afficher tous les conseils de tri
  ///
  /// In fr, this message translates to:
  /// **'Lire plus'**
  String get analysisTipsSeeMore;

  /// Avis affiché si le déchet n'est pas recyclable
  ///
  /// In fr, this message translates to:
  /// **'Ce déchet n\'est pas accepté en point relais.'**
  String get analysisNonRecyclable;

  /// Préfixe en gras dans la notice points
  ///
  /// In fr, this message translates to:
  /// **'Important : '**
  String get analysisImportantLabel;

  /// Corps de la notice rappelant que les points sont basés sur le poids réel
  ///
  /// In fr, this message translates to:
  /// **'les points seront crédités après la pesée réelle par un agent relais. Le calcul final s\'effectue sur le poids réel.'**
  String get analysisImportantBody;

  /// Bouton pour enregistrer le dépôt
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le dépôt'**
  String get analysisSaveDeposit;

  /// Confirmation d'enregistrement du dépôt
  ///
  /// In fr, this message translates to:
  /// **'Dépôt {code} enregistré dans votre historique'**
  String analysisDepositSaved(String code);

  /// Bouton pour relancer une analyse
  ///
  /// In fr, this message translates to:
  /// **'Scanner un autre déchet'**
  String get analysisScanAgain;

  /// Libellé sous le montant de points estimés
  ///
  /// In fr, this message translates to:
  /// **'pts estimés'**
  String get analysisEstimatedPoints;

  /// Poids estimé par l'IA affiché dans la carte résultat
  ///
  /// In fr, this message translates to:
  /// **'Poids estimé par l\'IA : ~{weight} kg'**
  String analysisEstimatedWeight(String weight);

  /// Libellé au-dessus de la barre de progression du score de confiance
  ///
  /// In fr, this message translates to:
  /// **'Indice de reconnaissance IA'**
  String get analysisConfidenceIndex;

  /// Titre de la section QR dans la page résultat
  ///
  /// In fr, this message translates to:
  /// **'QR Code du dépôt à présenter à l\'agent'**
  String get analysisQrTitle;

  /// Caption du QR avant l'enregistrement du ticket
  ///
  /// In fr, this message translates to:
  /// **'ID : GÉNÉRATION AU DÉPÔT'**
  String get analysisQrPlaceholder;

  /// Caption du QR après enregistrement du ticket
  ///
  /// In fr, this message translates to:
  /// **'ID : {code}'**
  String analysisQrId(String code);

  /// Instruction sous le QR code du dépôt
  ///
  /// In fr, this message translates to:
  /// **'Présentez ce QR code à l\'agent d\'un point relais pour procéder à la pesée certifiée.'**
  String get analysisQrCaption;

  /// Label du chip IA dans le viseur de la caméra
  ///
  /// In fr, this message translates to:
  /// **'IA SecondLife Vision'**
  String get scanAiBranding;

  /// Tooltip du bouton d'import galerie dans le scan
  ///
  /// In fr, this message translates to:
  /// **'Importer une photo'**
  String get scanTooltipImport;

  /// Tooltip du bouton flash dans le scan
  ///
  /// In fr, this message translates to:
  /// **'Lampe'**
  String get scanTooltipFlash;

  /// Tooltip du bouton déclencheur
  ///
  /// In fr, this message translates to:
  /// **'Prendre la photo'**
  String get scanTooltipCapture;

  /// Instruction affichée quand la caméra est indisponible
  ///
  /// In fr, this message translates to:
  /// **'Importez une photo du déchet'**
  String get scanHintImport;

  /// Instruction affichée quand la caméra est active
  ///
  /// In fr, this message translates to:
  /// **'Positionnez le déchet dans le cadre'**
  String get scanHintFrame;

  /// Message d'erreur si la prise de vue échoue
  ///
  /// In fr, this message translates to:
  /// **'La photo n\'a pas pu être prise.'**
  String get scanCaptureError;

  /// Message d'erreur si l'import galerie échoue
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir l\'image.'**
  String get scanGalleryError;

  /// Texte du placeholder quand la caméra est refusée
  ///
  /// In fr, this message translates to:
  /// **'Caméra indisponible. Autorisez l\'accès à la caméra ou importez une photo.'**
  String get scanCameraUnavailable;

  /// Texte du placeholder pendant l'initialisation de la caméra
  ///
  /// In fr, this message translates to:
  /// **'Ouverture de la caméra…'**
  String get scanCameraOpening;

  /// Titre de la page catalogue de récompenses
  ///
  /// In fr, this message translates to:
  /// **'Boutique'**
  String get rewardsCatalogTitle;

  /// Libellé au-dessus du solde de points dans l'en-tête du catalogue
  ///
  /// In fr, this message translates to:
  /// **'Votre solde'**
  String get rewardsBalanceLabel;

  /// Pastille des points en attente de validation dans l'en-tête du catalogue
  ///
  /// In fr, this message translates to:
  /// **'+{pts} pts en attente'**
  String rewardsPendingPts(int pts);

  /// Filtre 'toutes les catégories' dans le catalogue
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get rewardsCategoryAll;

  /// Catégorie de récompenses : alimentation
  ///
  /// In fr, this message translates to:
  /// **'Alimentation'**
  String get rewardsCategoryFood;

  /// Catégorie de récompenses : scolarité
  ///
  /// In fr, this message translates to:
  /// **'Scolarité'**
  String get rewardsCategoryEducation;

  /// Catégorie de récompenses : santé
  ///
  /// In fr, this message translates to:
  /// **'Santé'**
  String get rewardsCategoryHealth;

  /// Badge indiquant qu'une récompense n'est pas encore échangeable
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get rewardsSoon;

  /// Coût d'une récompense en points
  ///
  /// In fr, this message translates to:
  /// **'{cost} pts'**
  String rewardsCostPts(int cost);

  /// Message affiché sur une tuile quand le solde est insuffisant
  ///
  /// In fr, this message translates to:
  /// **'Il vous manque {missing} pts'**
  String rewardsMissingPts(int missing);

  /// Titre de l'état vide du catalogue pour une catégorie sans résultat
  ///
  /// In fr, this message translates to:
  /// **'Aucun article'**
  String get rewardsEmptyTitle;

  /// Message de l'état vide du catalogue
  ///
  /// In fr, this message translates to:
  /// **'Aucun article dans cette catégorie pour le moment.'**
  String get rewardsEmptyMessage;

  /// Titre du bloc des conditions d'utilisation sur la page détail d'une récompense
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get rewardsDetailConditionsTitle;

  /// Avertissement en bas de la page détail : les récompenses ne sont pas convertibles en cash
  ///
  /// In fr, this message translates to:
  /// **'Aucun retrait en espèces possible'**
  String get rewardsDetailNoCash;
  /// Libellé du premier onglet de la carte (points relais SecondLife)
  ///
  /// In fr, this message translates to:
  /// **'Points de dépôt'**
  String get placesCategoryRelay;

  /// Libellé du second onglet de la carte (lieux de recyclage informatifs)
  ///
  /// In fr, this message translates to:
  /// **'Points de recyclage'**
  String get placesCategoryRecycling;

  /// Titre de la liste des points proches dans la feuille inférieure, avec le nombre
  ///
  /// In fr, this message translates to:
  /// **'Points proches ({count})'**
  String placesNearbyCount(int count);

  /// Pastille du type de points dans la feuille inférieure : points relais
  ///
  /// In fr, this message translates to:
  /// **'Points relais pesée'**
  String get placesPillRelay;

  /// Pastille du type de points dans la feuille inférieure : centres de recyclage
  ///
  /// In fr, this message translates to:
  /// **'Centres recyclage'**
  String get placesPillRecycling;

  /// Bouton pour replier la feuille inférieure
  ///
  /// In fr, this message translates to:
  /// **'Réduire'**
  String get placesCollapse;

  /// Bouton pour déplier la feuille inférieure au maximum
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get placesSeeAll;

  /// Titre de l'état vide de la liste des points
  ///
  /// In fr, this message translates to:
  /// **'Aucun point trouvé'**
  String get placesEmptyTitle;

  /// Message de l'état vide quand la catégorie active est Points relais
  ///
  /// In fr, this message translates to:
  /// **'Aucun point relais ne correspond à votre recherche.'**
  String get placesEmptyRelay;

  /// Message de l'état vide quand la catégorie active est Recyclage
  ///
  /// In fr, this message translates to:
  /// **'Aucun lieu de recyclage ne correspond à votre recherche.'**
  String get placesEmptyRecycling;

  /// Tooltip du bouton de localisation sur la carte
  ///
  /// In fr, this message translates to:
  /// **'Ma position'**
  String get placesLocateTooltip;

  /// Message d'erreur affiché en snackbar quand la localisation est refusée
  ///
  /// In fr, this message translates to:
  /// **'Activez la localisation pour voir les points autour de vous.'**
  String get placesLocateError;

  /// Légende de la couleur verte sur la carte (points relais)
  ///
  /// In fr, this message translates to:
  /// **'Points relais (dépôt & pesée)'**
  String get placesLegendRelay;

  /// Légende de la couleur bleue sur la carte (lieux de recyclage)
  ///
  /// In fr, this message translates to:
  /// **'Recyclage (information)'**
  String get placesLegendRecycling;

  /// Placeholder par défaut du champ de recherche sur la carte
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une ville, un quartier ou un point'**
  String get placesSearchHintDefault;

  /// Placeholder du champ de recherche quand l'usager est dans une ville sans quartiers proches connus
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un point à {city}'**
  String placesSearchHintCity(String city);

  /// Placeholder du champ de recherche avec ville et quartiers
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un point à {city} ({districts}…)'**
  String placesSearchHintCityDistricts(String city, String districts);

  /// Placeholder du champ de recherche avec les villes les plus représentées
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une ville ou un quartier ({cities}…)'**
  String placesSearchHintCities(String cities);

  /// Statut d'ouverture d'un point : ouvert
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get placesOpen;

  /// Statut d'ouverture d'un point : fermé
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get placesClosed;

  /// Bouton de la carte d'un point pour voir le détail
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get placesDetails;

  /// Info courte sur la carte d'un point : agent présent
  ///
  /// In fr, this message translates to:
  /// **'Agent présent aujourd\'hui'**
  String get placesAgentPresent;

  /// Bouton court de la carte d'un point pour lancer l'itinéraire
  ///
  /// In fr, this message translates to:
  /// **'Itinéraire'**
  String get placesRoute;

  /// Point ouvert : heure de fermeture
  ///
  /// In fr, this message translates to:
  /// **'Ferme à {time}'**
  String placesClosesAt(String time);

  /// Point fermé : réouverture plus tard aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Ouvre à {time}'**
  String placesOpensAt(String time);

  /// Point fermé : prochaine ouverture un autre jour
  ///
  /// In fr, this message translates to:
  /// **'Ouvre {day} à {time}'**
  String placesOpensDayAt(String day, String time);

  /// Titre de l'état vide de la page détail d'un point qui n'existe plus
  ///
  /// In fr, this message translates to:
  /// **'Point introuvable'**
  String get placeDetailNotFound;

  /// Message de l'état vide quand le point n'est pas trouvé
  ///
  /// In fr, this message translates to:
  /// **'Ce point n\'existe plus ou n\'est plus actif.'**
  String get placeDetailNotFoundMessage;

  /// Bouton principal de la page détail pour ouvrir Google Maps avec l'itinéraire
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir dans Maps (Itinéraire)'**
  String get placeDetailRoute;

  /// Bandeau vert affiché sur la fiche détail si un agent est présent ce jour
  ///
  /// In fr, this message translates to:
  /// **'Agent présent aujourd\'hui (pesée certifiée immédiate)'**
  String get placeDetailAgentPresent;

  /// Titre de la card des matériaux acceptés dans la page détail
  ///
  /// In fr, this message translates to:
  /// **'Types de déchets acceptés'**
  String get placeDetailMaterialsTitle;

  /// Titre de la card des horaires d'ouverture dans la page détail
  ///
  /// In fr, this message translates to:
  /// **'Horaires d\'ouverture'**
  String get placeDetailHoursTitle;

  /// Message d'erreur quand l'URL Maps ne peut pas s'ouvrir
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir cette application.'**
  String get placeDetailLaunchError;

  /// Sous-titre de la page dépôts indiquant le nom du point relais de l'agent
  ///
  /// In fr, this message translates to:
  /// **'Point relais : {name}'**
  String depositRelayPoint(String name);

  /// Badge indiquant le nombre de dépôts en attente
  ///
  /// In fr, this message translates to:
  /// **'{count} en attente'**
  String depositPendingCount(int count);

  /// Message de l'état vide des dépôts, invitant à rafraîchir
  ///
  /// In fr, this message translates to:
  /// **'Tirez vers le bas pour actualiser.'**
  String get depositRefreshHint;

  /// Poids estimé par l'IA affiché sur la carte de dépôt en attente
  ///
  /// In fr, this message translates to:
  /// **'Poids IA : ~{weight} kg'**
  String depositAiWeight(String weight);

  /// Bouton principal sur la carte de dépôt en attente pour lancer la pesée
  ///
  /// In fr, this message translates to:
  /// **'Passer à la pesée'**
  String get depositWeighButton;

  /// Légende sous le poids recyclé, accueil usager
  ///
  /// In fr, this message translates to:
  /// **'recyclés'**
  String get homeStatRecycledLabel;

  /// Légende sous le nombre de dépôts validés, accueil usager
  ///
  /// In fr, this message translates to:
  /// **'validés'**
  String get homeStatValidatedLabel;

  /// Légende sous le nombre de dépôts en attente, accueil usager
  ///
  /// In fr, this message translates to:
  /// **'en attente'**
  String get homeStatPendingLabel;

  /// Raccourci d'accueil vers le scan
  ///
  /// In fr, this message translates to:
  /// **'Analyser un déchet'**
  String get homeQuickScanTitle;

  /// Sous-titre du raccourci de scan
  ///
  /// In fr, this message translates to:
  /// **'Prenez-le en photo : l\'IA estime sa valeur en points.'**
  String get homeQuickScanSubtitle;

  /// Raccourci d'accueil vers la carte
  ///
  /// In fr, this message translates to:
  /// **'Trouver un point relais'**
  String get homeQuickPlacesTitle;

  /// Sous-titre du raccourci vers la carte
  ///
  /// In fr, this message translates to:
  /// **'Déposez vos déchets près de chez vous.'**
  String get homeQuickPlacesSubtitle;

  /// Message sous l'état vide des dépôts en attente
  ///
  /// In fr, this message translates to:
  /// **'Analysez un déchet puis déposez-le dans un point relais pour gagner des points.'**
  String get homePendingDepositsEmptyHint;

  /// Titre de la feuille des notifications
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// État vide de la feuille des notifications
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get notificationsEmptyTitle;

  /// Message de l'état vide des notifications
  ///
  /// In fr, this message translates to:
  /// **'Vous serez prévenu ici dès qu\'un dépôt est traité.'**
  String get notificationsEmptyMessage;

  /// Raccourci de l'accueil agent vers le scanner
  ///
  /// In fr, this message translates to:
  /// **'Scanner un QR de dépôt'**
  String get agentQuickScanTitle;

  /// Sous-titre du raccourci de scan agent
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez le dépôt d\'un usager et passez à la pesée.'**
  String get agentQuickScanSubtitle;

  /// État vide des dépôts en attente, accueil agent
  ///
  /// In fr, this message translates to:
  /// **'Les dépôts des usagers apparaîtront ici.'**
  String get agentPendingEmptyMessage;

  /// Titre de l'onglet historique de l'agent
  ///
  /// In fr, this message translates to:
  /// **'Historique des validations'**
  String get agentHistoryTitle;

  /// Sous-titre de l'historique agent avec le nom du point relais
  ///
  /// In fr, this message translates to:
  /// **'Dépôts certifiés à : {name}'**
  String agentHistorySubtitle(String name);

  /// Onglet des dépôts traités aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui ({count})'**
  String agentHistoryTabToday(int count);

  /// Onglet de tous les dépôts traités
  ///
  /// In fr, this message translates to:
  /// **'Dépôts traités ({count})'**
  String agentHistoryTabAll(int count);

  /// État vide de l'onglet Aujourd'hui
  ///
  /// In fr, this message translates to:
  /// **'Aucun dépôt traité aujourd\'hui'**
  String get agentHistoryEmptyToday;

  /// État vide de l'onglet Dépôts traités
  ///
  /// In fr, this message translates to:
  /// **'Aucun dépôt traité'**
  String get agentHistoryEmptyAll;

  /// Message de l'état vide de l'historique agent
  ///
  /// In fr, this message translates to:
  /// **'Scannez le QR code d\'un usager pour commencer.'**
  String get agentHistoryEmptyMessage;

  /// Préfixe devant l'identifiant du déposant
  ///
  /// In fr, this message translates to:
  /// **'Déposant : '**
  String get agentHistoryDepositor;

  /// Préfixe devant le poids pesé
  ///
  /// In fr, this message translates to:
  /// **'Poids réel : '**
  String get agentHistoryRealWeight;

  /// Identifiant court d'un usager anonyme
  ///
  /// In fr, this message translates to:
  /// **'Usager {id}'**
  String commonUserLabel(String id);

  /// Libellé d'un champ commentaire facultatif
  ///
  /// In fr, this message translates to:
  /// **'Commentaire (facultatif)'**
  String get commentOptional;

  /// Session expirée
  ///
  /// In fr, this message translates to:
  /// **'Session expirée. Relancez l\'application.'**
  String get errorUnauthenticated;

  /// Le compte n'est pas agent
  ///
  /// In fr, this message translates to:
  /// **'Ce compte n\'est pas un agent relais actif.'**
  String get errorNotRelayAgent;

  /// Ticket introuvable
  ///
  /// In fr, this message translates to:
  /// **'Dépôt introuvable.'**
  String get errorTicketNotFound;

  /// Ticket déjà traité
  ///
  /// In fr, this message translates to:
  /// **'Ce dépôt a déjà été traité.'**
  String get errorTicketAlreadyProcessed;

  /// Ticket expiré
  ///
  /// In fr, this message translates to:
  /// **'Ce dépôt a expiré (plus de 48 h).'**
  String get errorTicketExpired;

  /// QR code qui n'est pas un ticket
  ///
  /// In fr, this message translates to:
  /// **'Ce QR code n\'est pas un dépôt.'**
  String get errorInvalidTicketCode;

  /// Poids saisi invalide
  ///
  /// In fr, this message translates to:
  /// **'Poids invalide (entre 0 et 50 kg).'**
  String get errorInvalidWeight;

  /// Commentaire manquant
  ///
  /// In fr, this message translates to:
  /// **'Un commentaire est obligatoire.'**
  String get errorCommentRequired;

  /// Commentaire trop long
  ///
  /// In fr, this message translates to:
  /// **'Commentaire trop long (500 caractères max).'**
  String get errorCommentTooLong;

  /// Erreur inconnue
  ///
  /// In fr, this message translates to:
  /// **'Une erreur inattendue est survenue.'**
  String get errorUnexpected;

  /// Motif de refus
  ///
  /// In fr, this message translates to:
  /// **'Objet différent de celui analysé'**
  String get rejectionItemMismatch;

  /// Motif de refus
  ///
  /// In fr, this message translates to:
  /// **'Matière non acceptée ou non recyclable'**
  String get rejectionNotRecyclable;

  /// Motif de refus
  ///
  /// In fr, this message translates to:
  /// **'Objet absent lors du dépôt'**
  String get rejectionItemMissing;

  /// Motif de refus
  ///
  /// In fr, this message translates to:
  /// **'Autre motif'**
  String get rejectionOther;

  /// Erreur caméra du scanner agent
  ///
  /// In fr, this message translates to:
  /// **'Caméra indisponible ({code}).\nAutorisez l\'accès à la caméra dans les réglages.'**
  String agentScanCameraUnavailable(String code);

  /// Consigne du scanner agent
  ///
  /// In fr, this message translates to:
  /// **'Pointez l\'objectif sur le QR code généré sur l\'écran du déposant'**
  String get scanAgentHint;

  /// Titre du scanner agent
  ///
  /// In fr, this message translates to:
  /// **'Scanner QR Déposant'**
  String get scanAgentChip;

  /// Bouton lampe torche
  ///
  /// In fr, this message translates to:
  /// **'Lampe'**
  String get scanTorch;

  /// Chargement après scan
  ///
  /// In fr, this message translates to:
  /// **'Chargement du dépôt…'**
  String get scanLoadingDeposit;

  /// Relancer le scan
  ///
  /// In fr, this message translates to:
  /// **'Scanner un autre QR'**
  String get scanAnother;

  /// Badge après un scan réussi
  ///
  /// In fr, this message translates to:
  /// **'QR DÉTECTÉ AVEC SUCCÈS'**
  String get scanDetected;

  /// Bouton vers la pesée
  ///
  /// In fr, this message translates to:
  /// **'Voir la fiche du dépôt & peser'**
  String get scanOpenWeighing;

  /// Titre d'un dépôt
  ///
  /// In fr, this message translates to:
  /// **'Dépôt {code}'**
  String depositTitle(String code);

  /// Libellé matériau
  ///
  /// In fr, this message translates to:
  /// **'Matériau'**
  String get depositMaterial;

  /// Libellé déposant
  ///
  /// In fr, this message translates to:
  /// **'Déposant'**
  String get depositDepositor;

  /// Préfixe du poids estimé
  ///
  /// In fr, this message translates to:
  /// **'Poids estimé : '**
  String get depositEstimatedWeight;

  /// Points estimés
  ///
  /// In fr, this message translates to:
  /// **'~{points} pts estimés'**
  String depositEstimatedPoints(String points);

  /// Titre de l'écran de pesée
  ///
  /// In fr, this message translates to:
  /// **'Validation de la pesée'**
  String get weighingTitle;

  /// Colonne poids IA
  ///
  /// In fr, this message translates to:
  /// **'Poids estimé (IA)'**
  String get weighingEstimatedTitle;

  /// Colonne poids pesé
  ///
  /// In fr, this message translates to:
  /// **'Poids réel (Balance)'**
  String get weighingRealTitle;

  /// Points estimés
  ///
  /// In fr, this message translates to:
  /// **'≈ {points} pts estimés'**
  String weighingEstimatedCaption(String points);

  /// Invite de saisie du poids
  ///
  /// In fr, this message translates to:
  /// **'Saisir le poids pesé'**
  String get weighingEnterWeight;

  /// Points certifiés
  ///
  /// In fr, this message translates to:
  /// **'= {points} pts certifiés'**
  String weighingCertifiedCaption(String points);

  /// Commentaire obligatoire si écart
  ///
  /// In fr, this message translates to:
  /// **'Commentaire (obligatoire : écart important)'**
  String get weighingCommentRequired;

  /// Bouton de validation
  ///
  /// In fr, this message translates to:
  /// **'Valider le dépôt'**
  String get weighingValidate;

  /// Bouton de validation avec points
  ///
  /// In fr, this message translates to:
  /// **'Valider le dépôt ({points} pts)'**
  String weighingValidateWithPoints(String points);

  /// Bouton de refus
  ///
  /// In fr, this message translates to:
  /// **'Refuser le dépôt'**
  String get weighingReject;

  /// Identifiant du dépôt
  ///
  /// In fr, this message translates to:
  /// **'Dépôt ID : {code}'**
  String weighingDepositId(String code);

  /// Confiance de l'IA
  ///
  /// In fr, this message translates to:
  /// **'IA {percent}'**
  String weighingAiConfidence(String percent);

  /// Écart acceptable
  ///
  /// In fr, this message translates to:
  /// **'Écart : {diff} kg (OK, ≤ {limit})'**
  String weighingDeviationOk(String diff, String limit);

  /// Écart important
  ///
  /// In fr, this message translates to:
  /// **'Écart : {diff} kg (> {limit}, à justifier)'**
  String weighingDeviationHigh(String diff, String limit);

  /// Badge de validation
  ///
  /// In fr, this message translates to:
  /// **'PESÉE CERTIFIÉE'**
  String get resultCertifiedPill;

  /// Badge de refus
  ///
  /// In fr, this message translates to:
  /// **'DÉPÔT REFUSÉ'**
  String get resultRejectedPill;

  /// Titre après validation
  ///
  /// In fr, this message translates to:
  /// **'Dépôt validé !'**
  String get resultValidatedTitle;

  /// Titre après refus
  ///
  /// In fr, this message translates to:
  /// **'Dépôt refusé'**
  String get resultRejectedTitle;

  /// Points crédités
  ///
  /// In fr, this message translates to:
  /// **'{points} pts crédités à {user}'**
  String resultPointsCredited(String points, String user);

  /// Usager notifié du refus
  ///
  /// In fr, this message translates to:
  /// **'{user} a été notifié du motif.'**
  String resultUserNotified(String user);

  /// Retour à l'accueil agent
  ///
  /// In fr, this message translates to:
  /// **'Retour au tableau de bord'**
  String get resultBackToDashboard;

  /// Titre du dialogue de refus
  ///
  /// In fr, this message translates to:
  /// **'Motif de refus du dépôt'**
  String get rejectTitle;

  /// Consigne du dialogue de refus
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez le motif : il sera affiché à l\'usager.'**
  String get rejectSubtitle;

  /// Commentaire obligatoire pour Autre motif
  ///
  /// In fr, this message translates to:
  /// **'Précisez le motif (obligatoire)'**
  String get rejectCommentRequired;

  /// Confirmer le refus
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le refus'**
  String get rejectConfirm;

  /// Titre de la fiche d'un dépôt
  ///
  /// In fr, this message translates to:
  /// **'Fiche du dépôt'**
  String get detailSheetTitle;

  /// Identifiant du dépôt
  ///
  /// In fr, this message translates to:
  /// **'ID : {code}'**
  String detailId(String code);

  /// Ligne statut
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get detailStatus;

  /// Ligne poids réel
  ///
  /// In fr, this message translates to:
  /// **'Poids réel'**
  String get detailRealWeight;

  /// Ligne poids certifié
  ///
  /// In fr, this message translates to:
  /// **'Poids réel certifié'**
  String get detailCertifiedWeight;

  /// Ligne points attribués
  ///
  /// In fr, this message translates to:
  /// **'Points attribués'**
  String get detailPointsAwarded;

  /// Ligne points estimés
  ///
  /// In fr, this message translates to:
  /// **'Points estimés'**
  String get detailPointsEstimated;

  /// Ligne motif
  ///
  /// In fr, this message translates to:
  /// **'Motif du refus'**
  String get detailReason;

  /// Ligne commentaire
  ///
  /// In fr, this message translates to:
  /// **'Commentaire de l\'agent'**
  String get detailComment;

  /// Ligne agent ayant refusé
  ///
  /// In fr, this message translates to:
  /// **'Refusé par'**
  String get detailRejectedBy;

  /// Ligne agent ayant validé
  ///
  /// In fr, this message translates to:
  /// **'Validé par'**
  String get detailValidatedBy;

  /// Date de traitement
  ///
  /// In fr, this message translates to:
  /// **'Traité le'**
  String get detailProcessedAt;

  /// Date de dépôt
  ///
  /// In fr, this message translates to:
  /// **'Déposé le'**
  String get detailDepositedAt;

  /// Titre du bloc QR
  ///
  /// In fr, this message translates to:
  /// **'QR Code à présenter à l\'agent'**
  String get detailQrTitle;

  /// Consigne du QR
  ///
  /// In fr, this message translates to:
  /// **'L\'agent scannera ce code pour charger votre pesée. Valable jusqu\'au {date}.'**
  String detailQrHint(String date);

  /// Type de lieu
  ///
  /// In fr, this message translates to:
  /// **'Centre de recyclage'**
  String get placesKindRecyclingCenter;

  /// Type de lieu
  ///
  /// In fr, this message translates to:
  /// **'Centre de tri'**
  String get placesKindSortingCenter;

  /// Type de lieu
  ///
  /// In fr, this message translates to:
  /// **'Dépotoir'**
  String get placesKindDump;

  /// Type de lieu
  ///
  /// In fr, this message translates to:
  /// **'Ferrailleur'**
  String get placesKindScrapDealer;

  /// Type d'un point relais
  ///
  /// In fr, this message translates to:
  /// **'Point relais SecondLife'**
  String get placesTypeRelay;

  /// Type d'un lieu de recyclage sans genre précis
  ///
  /// In fr, this message translates to:
  /// **'Lieu de recyclage'**
  String get placesTypeRecycling;

  /// Poids restant avant enlèvement
  ///
  /// In fr, this message translates to:
  /// **'Encore {amount} kg avant l\'enlèvement du lot.'**
  String agentInfoRemaining(int amount);

  /// Consigne de l'écran mot de passe oublié
  ///
  /// In fr, this message translates to:
  /// **'Saisis ton email : nous t\'enverrons un lien pour choisir un nouveau mot de passe.'**
  String get authForgotSubtitle;

  /// Bouton d'envoi du lien de réinitialisation
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get authForgotButton;

  /// Confirmation d'envoi
  ///
  /// In fr, this message translates to:
  /// **'Email envoyé ! Vérifie ta boîte de réception (et les spams).'**
  String get authForgotSent;

  /// Échec d'envoi
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'envoyer l\'email. Réessaie.'**
  String get authForgotError;

  /// Email mal formé
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide.'**
  String get authErrorInvalidEmail;

  /// Échec d'enregistrement de la préférence de notifications
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'enregistrer la préférence. Réessaie.'**
  String get profileNotificationsError;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Notifications générales'**
  String get notifChannelGeneralName;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Informations générales et mises à jour'**
  String get notifChannelGeneralDescription;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Rappels'**
  String get notifChannelRemindersName;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Rappels personnalisés et planifiés'**
  String get notifChannelRemindersDescription;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Alertes importantes'**
  String get notifChannelAlertsName;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Alertes critiques nécessitant une attention immédiate'**
  String get notifChannelAlertsDescription;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Traitements'**
  String get notifChannelProcessingName;

  /// Canal Android
  ///
  /// In fr, this message translates to:
  /// **'Fin des analyses de déchets'**
  String get notifChannelProcessingDescription;

  /// Titre du catalogue de récompenses
  ///
  /// In fr, this message translates to:
  /// **'Récompenses'**
  String get rewardsTitle;

  /// Libellé du solde en haut du catalogue
  ///
  /// In fr, this message translates to:
  /// **'Solde disponible'**
  String get rewardsBalanceLabel;

  /// Coût d'une récompense
  ///
  /// In fr, this message translates to:
  /// **'{points} pts'**
  String rewardsCost(int points);

  /// Bouton d'échange d'une récompense
  ///
  /// In fr, this message translates to:
  /// **'Échanger'**
  String get rewardsRedeem;

  /// Points manquants pour une récompense
  ///
  /// In fr, this message translates to:
  /// **'Encore {points} pts'**
  String rewardsMissing(int points);

  /// Récompense épuisée
  ///
  /// In fr, this message translates to:
  /// **'Épuisé'**
  String get rewardsOutOfStock;

  /// Stock restant
  ///
  /// In fr, this message translates to:
  /// **'Plus que {count}'**
  String rewardsStockLeft(int count);

  /// Durée de validité du bon
  ///
  /// In fr, this message translates to:
  /// **'Valable {days} jours après l\'échange'**
  String rewardsValidity(int days);

  /// Titre de confirmation d'échange
  ///
  /// In fr, this message translates to:
  /// **'Échanger {points} pts ?'**
  String rewardsConfirmTitle(int points);

  /// Message de confirmation d'échange
  ///
  /// In fr, this message translates to:
  /// **'Vous recevrez « {name} ». Il vous restera {balance} pts.'**
  String rewardsConfirmMessage(String name, int balance);

  /// Titre après un échange réussi
  ///
  /// In fr, this message translates to:
  /// **'Bon obtenu !'**
  String get rewardsSuccessTitle;

  /// Consigne après un échange réussi
  ///
  /// In fr, this message translates to:
  /// **'Présentez ce code chez {partner}.'**
  String rewardsSuccessMessage(String partner);

  /// Lien vers les bons obtenus
  ///
  /// In fr, this message translates to:
  /// **'Voir mes bons'**
  String get rewardsSeeVouchers;

  /// Échec : pas assez de points
  ///
  /// In fr, this message translates to:
  /// **'Solde insuffisant pour cette récompense.'**
  String get rewardsErrorInsufficient;

  /// Échec : stock épuisé
  ///
  /// In fr, this message translates to:
  /// **'Cette récompense est épuisée.'**
  String get rewardsErrorOutOfStock;

  /// Échec générique d'échange
  ///
  /// In fr, this message translates to:
  /// **'L\'échange n\'a pas abouti. Réessayez.'**
  String get rewardsErrorGeneric;

  /// Catalogue vide
  ///
  /// In fr, this message translates to:
  /// **'Aucune récompense disponible pour le moment.'**
  String get rewardsEmpty;

  /// Objectif de la prochaine récompense
  ///
  /// In fr, this message translates to:
  /// **'Encore {points} pts pour « {name} »'**
  String homeNextReward(int points, String name);

  /// Le solde couvre toutes les récompenses
  ///
  /// In fr, this message translates to:
  /// **'Toutes les récompenses sont à votre portée !'**
  String get homeAllRewardsUnlocked;

  /// Bouton vers le catalogue depuis l'onglet Récompenses vide
  ///
  /// In fr, this message translates to:
  /// **'Voir les récompenses'**
  String get historyEmptyGiftCta;

  /// Notification de bienvenue
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur SecondLife !'**
  String get notifWelcomeTitle;

  /// Notification de bienvenue
  ///
  /// In fr, this message translates to:
  /// **'{points} pts de bienvenue ont été crédités sur votre compte.'**
  String notifWelcomeBody(int points);

  /// Notification de dépôt validé
  ///
  /// In fr, this message translates to:
  /// **'Dépôt validé'**
  String get notifValidatedTitle;

  /// Notification de dépôt validé
  ///
  /// In fr, this message translates to:
  /// **'+{points} pts pour « {item} ».'**
  String notifValidatedBody(int points, String item);

  /// Notification de dépôt refusé
  ///
  /// In fr, this message translates to:
  /// **'Dépôt refusé'**
  String get notifRejectedTitle;

  /// Notification de dépôt refusé
  ///
  /// In fr, this message translates to:
  /// **'« {item} » : {reason}'**
  String notifRejectedBody(String item, String reason);

  /// Notification de bon obtenu
  ///
  /// In fr, this message translates to:
  /// **'Bon obtenu'**
  String get notifVoucherTitle;

  /// Notification de bon obtenu
  ///
  /// In fr, this message translates to:
  /// **'« {name} » vous attend dans vos récompenses.'**
  String notifVoucherBody(String name);

  /// Notification d'un type inconnu
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle notification'**
  String get notifUnknown;

  /// Action de la feuille des notifications
  ///
  /// In fr, this message translates to:
  /// **'Tout marquer comme lu'**
  String get notificationsMarkAllRead;

  /// Date relative
  ///
  /// In fr, this message translates to:
  /// **'À l\'instant'**
  String get timeJustNow;

  /// Date relative
  ///
  /// In fr, this message translates to:
  /// **'Il y a {count} min'**
  String timeMinutesAgo(int count);

  /// Date relative
  ///
  /// In fr, this message translates to:
  /// **'Il y a {count} h'**
  String timeHoursAgo(int count);

  /// Bouton : le camion a enlevé le lot
  ///
  /// In fr, this message translates to:
  /// **'Lot enlevé'**
  String get agentBatchCollect;

  /// Titre de confirmation d'enlèvement
  ///
  /// In fr, this message translates to:
  /// **'Confirmer l\'enlèvement ?'**
  String get agentBatchCollectConfirmTitle;

  /// Message de confirmation d'enlèvement
  ///
  /// In fr, this message translates to:
  /// **'Le compteur du lot ({amount} kg) repartira de zéro.'**
  String agentBatchCollectConfirmMessage(int amount);

  /// Confirmation d'enlèvement
  ///
  /// In fr, this message translates to:
  /// **'Lot enregistré comme enlevé.'**
  String get agentBatchCollected;

  /// Échec d'enlèvement
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'enregistrer l\'enlèvement.'**
  String get agentBatchError;

  /// Date du dernier enlèvement
  ///
  /// In fr, this message translates to:
  /// **'Dernier enlèvement : {date}'**
  String agentBatchLastPickup(String date);
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
