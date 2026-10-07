// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'SecondLife';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonError => 'Une erreur est survenue';

  @override
  String get commonNetworkError =>
      'Connexion indisponible. Vérifie ta connexion internet.';

  @override
  String get commonOfflineBanner =>
      'Hors-ligne — affichage des données en cache';

  @override
  String get commonOr => 'Ou';

  @override
  String get commonSeeMore => 'Voir plus';

  @override
  String get commonInfo => 'Info';

  @override
  String commonDateTime(String date, String time) {
    return '$date à $time';
  }

  @override
  String get authOrContinueWith => 'Ou continuer avec';

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingSkipTooltip => 'Ignorer l\'introduction';

  @override
  String get onboardingNextTooltip => 'Aller à l\'étape suivante';

  @override
  String get onboardingFinishTooltip => 'Terminer et commencer';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingTitle1 => 'Vos déchets ont de la valeur';

  @override
  String get onboardingDescription1 =>
      'Scannez-les, déposez-les dans un point relais. Après la pesée, vous gagnez des points.';

  @override
  String get onboardingTitle2 => 'Repérez les points noirs';

  @override
  String get onboardingDescription2 =>
      'Un tas de déchets bouche un caniveau ? Prenez-le en photo. Vos voisins sont alertés, et votre signalement est récompensé une fois le lieu nettoyé.';

  @override
  String get onboardingTitle3 => 'Des points pour l\'essentiel';

  @override
  String get onboardingDescription3 =>
      'Vos points ne se retirent pas en espèces. Ils serviront bientôt pour manger, étudier et se soigner.';

  @override
  String onboardingProgressLabel(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String onboardingNotificationTitle(String appName) {
    return 'Bienvenue sur $appName';
  }

  @override
  String get onboardingNotificationBody =>
      'Votre premier dépôt vous attend — scannez un déchet dès maintenant.';

  @override
  String get authLoginTitle => 'Connexion';

  @override
  String get authLoginButton => 'Se connecter';

  @override
  String get authSignupTitle => 'Inscription';

  @override
  String get authSignupButton => 'S\'inscrire';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'ton@email.com';

  @override
  String get authUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get authUsernameHint => 'Ama Kwatcha';

  @override
  String get authAlreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get authNoAccount => 'Pas de compte ?';

  @override
  String get authLoginLink => 'Se connecter';

  @override
  String get authSignupLink => 'Créer un compte';

  @override
  String get authOAuthGoogle => 'Continuer avec Google';

  @override
  String authSignupSuccess(String username) {
    return 'Compte créé ! Bienvenue $username !';
  }

  @override
  String get authLogout => 'Déconnexion';

  @override
  String get authLogoutButton => 'Se déconnecter';

  @override
  String get authLogoutConfirmTitle => 'Se déconnecter ?';

  @override
  String get authLogoutConfirmMessage =>
      'Es-tu sûr de vouloir te déconnecter ?';

  @override
  String get authLogoutSuccess => 'Déconnecté avec succès.';

  @override
  String authLoginSuccess(String username) {
    return 'Connexion réussie ! Ravie de te revoir, $username !';
  }

  @override
  String get authLoginError =>
      'Échec de la connexion. Vérifie tes identifiants.';

  @override
  String get authSignupError => 'Échec de l\'inscription. Réessaie.';

  @override
  String get authLogoutError => 'Échec de la déconnexion. Réessaie.';

  @override
  String get authErrorInvalidCredential => 'Email ou mot de passe incorrect.';

  @override
  String get authErrorEmailAlreadyInUse =>
      'Un compte existe déjà avec cet email.';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives. Réessaie dans quelques minutes.';

  @override
  String get authErrorUserDisabled => 'Ce compte a été désactivé.';

  @override
  String get authPasswordLabel => 'Mot de passe';

  @override
  String get authPasswordHint => '••••••••';

  @override
  String get authConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get authForgotPassword => 'Mot de passe oublié ?';

  @override
  String get authUsernameSetupTitle => 'Choisis ton nom';

  @override
  String get authUsernameSetupSubtitle =>
      'Ce nom sera ton identifiant unique sur Second Life.';

  @override
  String get authUsernameSetupButton => 'Continuer';

  @override
  String get authUsernameTaken => 'Ce nom est déjà pris';

  @override
  String get validationRequired => 'Ce champ est obligatoire.';

  @override
  String validationFieldRequired(String field) {
    return 'L\'attribut $field est requis.';
  }

  @override
  String get validationInvalidEmail => 'Adresse e-mail invalide.';

  @override
  String get validationEmailIncorrect => 'Adresse e-mail incorrecte.';

  @override
  String get validationPasswordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères.';

  @override
  String get validationPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas.';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'Au moins $minLength caractères.';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '$maxLength caractères maximum.';
  }

  @override
  String get validationUsernameInvalid => 'Lettres, chiffres et _ uniquement.';

  @override
  String get routerErrorTitle => 'Cet écran n\'existe pas encore.';

  @override
  String get routerErrorSubtitle =>
      'Reviens plus tard, ou reprends depuis l\'accueil.';

  @override
  String routerSoon(String title) {
    return '$title — bientôt.';
  }

  @override
  String get routerScreenForgotPassword => 'Mot de passe oublié';

  @override
  String get routerScreenResetPassword => 'Nouveau mot de passe';

  @override
  String get routerScreenScanning => 'Analyse en cours…';

  @override
  String get routerScreenPlaces => 'Points de recyclage';

  @override
  String get routerScreenHistory => 'Historique';

  @override
  String get routerScreenAgentDeposits => 'Dépôts';

  @override
  String get routerScreenAgentHistory => 'Historique agent';

  @override
  String routerScreenPlaceDetail(String id) {
    return 'Point de recyclage $id';
  }

  @override
  String get routerScreenSettings => 'Paramètres';

  @override
  String get errorNetwork => 'Erreur réseau. Vérifie ta connexion internet.';

  @override
  String get errorServer => 'Erreur serveur. Réessaie plus tard.';

  @override
  String get errorValidation => 'Données invalides. Vérifie les champs.';

  @override
  String get errorUnknown => 'Une erreur inconnue est survenue.';

  @override
  String get navHome => 'Accueil';

  @override
  String get navPlaces => 'Carte';

  @override
  String get navHistory => 'Historique';

  @override
  String get navProfile => 'Profil';

  @override
  String get navAgentDeposits => 'Dépôts';

  @override
  String get navAnalyzeCta => 'Analyser';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get homeAgentRoleLabel => 'Agent';

  @override
  String get homePointsTitle => 'Mes points';

  @override
  String get homePointsRedeemCta => 'Échanger';

  @override
  String homePointsBalance(int amount) {
    return '$amount pts';
  }

  @override
  String homePointsPendingValidation(int amount) {
    return '+$amount pts en attente de validation';
  }

  @override
  String get homePointsNotCash =>
      'Non convertie en argent liquide. Échangeable contre des bons chez le partenaire.';

  @override
  String get homePendingDepositsTitle => 'Dépôts en attente';

  @override
  String get homeDepositItemBottle => 'Bouteille';

  @override
  String get homeDepositItemIron => 'Fer';

  @override
  String homeDepositPointsGain(int amount) {
    return '+$amount pts';
  }

  @override
  String get homeEcoImpactTitle => 'Chaque geste compte pour la planète.';

  @override
  String get homeEcoImpactSubtitle =>
      'Recyclez vos déchets plastiques et métalliques et récupérez des bons avec vos points de recyclage';

  @override
  String get agentStatsTreatedDeposits => 'Dépôts traités';

  @override
  String get agentStatsValidatedPoints => 'Points validés';

  @override
  String get agentStockTitle => 'Stock du point de dépôt';

  @override
  String agentStockKgCollected(int amount) {
    return '$amount kg récoltés';
  }

  @override
  String agentStockKgGoal(int amount) {
    return 'Objectif : $amount kg';
  }

  @override
  String get agentStockSiteName => 'EcoCentre de Bè';

  @override
  String get agentInfoMessage =>
      'Lot bientôt prêt pour l\'enlèvement par le camion municipal.';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String profileStatAvailableValue(int value) {
    return '$value pts';
  }

  @override
  String get profileStatAvailableLabel => 'Disponibles';

  @override
  String profileStatPendingValue(int value) {
    return '+$value pts';
  }

  @override
  String get profileStatPendingLabel => 'En attente';

  @override
  String profileStatRecycledValue(double value) {
    return '$value kg';
  }

  @override
  String get profileStatRecycledLabel => 'Recyclés';

  @override
  String get profileAgentRole => 'Agent de collecte';

  @override
  String get profileCenterHours => 'Lun – Sam, 8h – 18h';

  @override
  String get profileStatusOpen => 'Ouvert';

  @override
  String get profileStatusClosed => 'Fermé';

  @override
  String get profileSettingsTitle => 'Paramètres';

  @override
  String get profileSettingsNotifications => 'Notifications';

  @override
  String get profileSettingsTheme => 'Thème';

  @override
  String get profileSettingsLanguage => 'Langue';

  @override
  String get profileSettingsDyslexicFont => 'Police dyslexique';

  @override
  String get profileThemeLight => 'Clair';

  @override
  String get profileThemeDark => 'Sombre';

  @override
  String get profileThemeSystem => 'Système';

  @override
  String get historyTitle => 'Historique de vos activités';

  @override
  String get historyAgentTitle => 'Mes validations';

  @override
  String get historyAgentEmpty => 'Aucune validation ici';

  @override
  String get historyFilterAll => 'Tous';

  @override
  String get historyFilterValidated => 'Validés';

  @override
  String get historyFilterRejected => 'Refusés';

  @override
  String get historyStatTotal => 'Total';

  @override
  String get historyTabWaiting => 'En attente';

  @override
  String get historyTabProcessed => 'Traités';

  @override
  String get historyTabGift => 'Récompenses';

  @override
  String get historyStatusWaiting => 'En attente';

  @override
  String get historyStatusValidated => 'Validé';

  @override
  String get historyStatusRejected => 'Refusé';

  @override
  String get historyVoucherStatusActive => 'Actif';

  @override
  String get historyVoucherStatusUsed => 'Utilisé';

  @override
  String get historyVoucherStatusExpired => 'Expiré';

  @override
  String get historyEmptyDepositTitle => 'Aucun dépôt pour le moment';

  @override
  String get historyEmptyGiftTitle => 'Bientôt disponible';

  @override
  String get historyEmptyGiftMessage =>
      'L\'échange de points contre des récompenses arrive très bientôt.';

  @override
  String get historyInfoTitle => 'Informations';

  @override
  String get historyQrHint => 'Présentez ce code à l\'agent du point relais';

  @override
  String historyPointsPending(int amount) {
    return '+$amount pts en attente';
  }

  @override
  String historyPointsCertified(int amount) {
    return '+$amount pts certifiés';
  }

  @override
  String historyPointsCredited(int amount) {
    return '+$amount pts crédités';
  }

  @override
  String historyPointsSpent(int amount) {
    return '$amount pts dépensés';
  }

  @override
  String historyWeightReal(double weight) {
    return 'Poids réel : $weight kg';
  }

  @override
  String historyWeightEstimated(double weight) {
    return 'Poids estimé : ~$weight kg';
  }

  @override
  String historyWeightApprox(double weight) {
    return '~$weight kg';
  }

  @override
  String historyWeightComparison(double estimated, double real) {
    return 'Estimé $estimated kg → Réel $real kg';
  }

  @override
  String historyPendingCredit(int points) {
    return '$points pts seront crédités après validation';
  }

  @override
  String historyVoucherRef(String code) {
    return 'Réf. $code';
  }

  @override
  String historyVoucherCode(String code) {
    return 'Code : $code';
  }

  @override
  String historyVoucherExpiry(String date) {
    return 'Expire le $date';
  }

  @override
  String historyVoucherExpiryPast(String date) {
    return 'Expiré le $date';
  }

  @override
  String historyVoucherUsedDate(String date) {
    return 'Utilisé le $date';
  }

  @override
  String historyVoucherFrom(String date) {
    return 'Du $date';
  }

  @override
  String historyVoucherUntil(String date) {
    return 'Exp. $date';
  }

  @override
  String get historyVoucherConditionsTitle => 'Conditions d\'utilisation';

  @override
  String get historyVoucherConditionsBody =>
      'Ce bon est valable une seule fois auprès du partenaire indiqué. Présentez le QR code à la caisse. Non cumulable avec d\'autres offres.';

  @override
  String get historyVoucherNoCash => 'Aucun retrait en espèces possible';

  @override
  String get materialPlastic => 'Plastique';

  @override
  String get materialPaper => 'Papier / Carton';

  @override
  String get materialMetal => 'Métal';

  @override
  String get materialGlass => 'Verre';

  @override
  String get materialEwaste => 'Déchets électroniques';

  @override
  String get materialOrganic => 'Organique';
}
