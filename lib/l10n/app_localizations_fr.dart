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
  String get authOr => 'Ou';

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
  String get authLoginSubtitle =>
      'Content de te revoir ! Connecte-toi pour suivre tes points.';

  @override
  String get authSignupSubtitle =>
      'Crée ton compte et transforme tes déchets en récompenses.';

  @override
  String get authPasswordStrengthWeak => 'Faible';

  @override
  String get authPasswordStrengthMedium => 'Moyen';

  @override
  String get authPasswordStrengthStrong => 'Robuste';

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
  String get homeGreetingHello => 'Bonjour 👋';

  @override
  String get homeAgentRoleLabel => 'Agent';

  @override
  String get homePointsTitle => 'Mes points';

  @override
  String get homePointsRedeemCta => 'Boutique';

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
  String get homePendingDepositsEmpty => 'Aucun dépôt en attente';

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
  String get historyEmptyGiftTitle => 'Aucun bon pour l\'instant';

  @override
  String get historyEmptyGiftMessage =>
      'Échangez vos points contre des bons chez nos partenaires.';

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

  @override
  String get analysisResultTitle => 'Résultat de l\'analyse IA';

  @override
  String get analysisAnalyzingTitle => 'Analyse par l\'IA en cours…';

  @override
  String get analysisAnalyzingSubtitle =>
      'Identification de la matière et estimation du poids';

  @override
  String analysisDetected(String item) {
    return 'Détecté : $item';
  }

  @override
  String analysisConfidenceScore(String percent) {
    return 'Confiance $percent';
  }

  @override
  String get analysisTipsTitle => 'Conseils de tri';

  @override
  String get analysisTipsSeeMore => 'Lire plus';

  @override
  String get analysisNonRecyclable =>
      'Ce déchet n\'est pas accepté en point relais.';

  @override
  String get analysisImportantLabel => 'Important : ';

  @override
  String get analysisImportantBody =>
      'les points seront crédités après la pesée réelle par un agent relais. Le calcul final s\'effectue sur le poids réel.';

  @override
  String get analysisSaveDeposit => 'Enregistrer le dépôt';

  @override
  String analysisDepositSaved(String code) {
    return 'Dépôt $code enregistré dans votre historique';
  }

  @override
  String get analysisScanAgain => 'Scanner un autre déchet';

  @override
  String get analysisEstimatedPoints => 'pts estimés';

  @override
  String analysisEstimatedWeight(String weight) {
    return 'Poids estimé par l\'IA : ~$weight kg';
  }

  @override
  String get analysisConfidenceIndex => 'Indice de reconnaissance IA';

  @override
  String get analysisQrTitle => 'QR Code du dépôt à présenter à l\'agent';

  @override
  String get analysisQrPlaceholder => 'ID : GÉNÉRATION AU DÉPÔT';

  @override
  String analysisQrId(String code) {
    return 'ID : $code';
  }

  @override
  String get analysisQrCaption =>
      'Présentez ce QR code à l\'agent d\'un point relais pour procéder à la pesée certifiée.';

  @override
  String get scanAiBranding => 'IA SecondLife Vision';

  @override
  String get scanTooltipImport => 'Importer une photo';

  @override
  String get scanTooltipFlash => 'Lampe';

  @override
  String get scanTooltipCapture => 'Prendre la photo';

  @override
  String get scanHintImport => 'Importez une photo du déchet';

  @override
  String get scanHintFrame => 'Positionnez le déchet dans le cadre';

  @override
  String get scanCaptureError => 'La photo n\'a pas pu être prise.';

  @override
  String get scanGalleryError => 'Impossible d\'ouvrir l\'image.';

  @override
  String get scanCameraUnavailable =>
      'Caméra indisponible. Autorisez l\'accès à la caméra ou importez une photo.';

  @override
  String get scanCameraOpening => 'Ouverture de la caméra…';

  @override
  String get rewardsCatalogTitle => 'Boutique';

  @override
  String get rewardsBalanceLabel => 'Votre solde';

  @override
  String rewardsPendingPts(int pts) {
    return '+$pts pts en attente';
  }

  @override
  String get rewardsCategoryAll => 'Toutes';

  @override
  String get rewardsCategoryFood => 'Alimentation';

  @override
  String get rewardsCategoryEducation => 'Scolarité';

  @override
  String get rewardsCategoryHealth => 'Santé';

  @override
  String get rewardsSoon => 'Bientôt';

  @override
  String rewardsCostPts(int cost) {
    return '$cost pts';
  }

  @override
  String rewardsMissingPts(int missing) {
    return 'Il vous manque $missing pts';
  }

  @override
  String get rewardsEmptyTitle => 'Aucun article';

  @override
  String get rewardsEmptyMessage =>
      'Aucun article dans cette catégorie pour le moment.';

  @override
  String get rewardsDetailConditionsTitle => 'Conditions d\'utilisation';

  @override
  String get rewardsDetailNoCash => 'Aucun retrait en espèces possible';
  String get placesCategoryRelay => 'Points de dépôt';

  @override
  String get placesCategoryRecycling => 'Points de recyclage';

  @override
  String placesNearbyCount(int count) {
    return 'Points proches ($count)';
  }

  @override
  String get placesPillRelay => 'Points relais pesée';

  @override
  String get placesPillRecycling => 'Centres recyclage';

  @override
  String get placesCollapse => 'Réduire';

  @override
  String get placesSeeAll => 'Voir tout';

  @override
  String get placesEmptyTitle => 'Aucun point trouvé';

  @override
  String get placesEmptyRelay =>
      'Aucun point relais ne correspond à votre recherche.';

  @override
  String get placesEmptyRecycling =>
      'Aucun lieu de recyclage ne correspond à votre recherche.';

  @override
  String get placesLocateTooltip => 'Ma position';

  @override
  String get placesLocateError =>
      'Activez la localisation pour voir les points autour de vous.';

  @override
  String get placesLegendRelay => 'Points relais (dépôt & pesée)';

  @override
  String get placesLegendRecycling => 'Recyclage (information)';

  @override
  String get placesSearchHintDefault =>
      'Rechercher une ville, un quartier ou un point';

  @override
  String placesSearchHintCity(String city) {
    return 'Rechercher un point à $city';
  }

  @override
  String placesSearchHintCityDistricts(String city, String districts) {
    return 'Rechercher un point à $city ($districts…)';
  }

  @override
  String placesSearchHintCities(String cities) {
    return 'Rechercher une ville ou un quartier ($cities…)';
  }

  @override
  String get placesOpen => 'Ouvert';

  @override
  String get placesClosed => 'Fermé';

  @override
  String get placesDetails => 'Détails';

  @override
  String get placesAgentPresent => 'Agent présent aujourd\'hui';

  @override
  String get placesRoute => 'Itinéraire';

  @override
  String placesClosesAt(String time) {
    return 'Ferme à $time';
  }

  @override
  String placesOpensAt(String time) {
    return 'Ouvre à $time';
  }

  @override
  String placesOpensDayAt(String day, String time) {
    return 'Ouvre $day à $time';
  }

  @override
  String get placeDetailNotFound => 'Point introuvable';

  @override
  String get placeDetailNotFoundMessage =>
      'Ce point n\'existe plus ou n\'est plus actif.';

  @override
  String get placeDetailRoute => 'Ouvrir dans Maps (Itinéraire)';

  @override
  String get placeDetailAgentPresent =>
      'Agent présent aujourd\'hui (pesée certifiée immédiate)';

  @override
  String get placeDetailMaterialsTitle => 'Types de déchets acceptés';

  @override
  String get placeDetailHoursTitle => 'Horaires d\'ouverture';

  @override
  String get placeDetailLaunchError =>
      'Impossible d\'ouvrir cette application.';

  @override
  String depositRelayPoint(String name) {
    return 'Point relais : $name';
  }

  @override
  String depositPendingCount(int count) {
    return '$count en attente';
  }

  @override
  String get depositRefreshHint => 'Tirez vers le bas pour actualiser.';

  @override
  String depositAiWeight(String weight) {
    return 'Poids IA : ~$weight kg';
  }

  @override
  String get depositWeighButton => 'Passer à la pesée';

  @override
  String get homeStatRecycledLabel => 'recyclés';

  @override
  String get homeStatValidatedLabel => 'validés';

  @override
  String get homeStatPendingLabel => 'en attente';

  @override
  String get homeQuickScanTitle => 'Analyser un déchet';

  @override
  String get homeQuickScanSubtitle =>
      'Prenez-le en photo : l\'IA estime sa valeur en points.';

  @override
  String get homeQuickPlacesTitle => 'Trouver un point relais';

  @override
  String get homeQuickPlacesSubtitle =>
      'Déposez vos déchets près de chez vous.';

  @override
  String get homePendingDepositsEmptyHint =>
      'Analysez un déchet puis déposez-le dans un point relais pour gagner des points.';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsEmptyMessage =>
      'Vous serez prévenu ici dès qu\'un dépôt est traité.';

  @override
  String get agentQuickScanTitle => 'Scanner un QR de dépôt';

  @override
  String get agentQuickScanSubtitle =>
      'Retrouvez le dépôt d\'un usager et passez à la pesée.';

  @override
  String get agentPendingEmptyMessage =>
      'Les dépôts des usagers apparaîtront ici.';

  @override
  String get agentHistoryTitle => 'Historique des validations';

  @override
  String agentHistorySubtitle(String name) {
    return 'Dépôts certifiés à : $name';
  }

  @override
  String agentHistoryTabToday(int count) {
    return 'Aujourd\'hui ($count)';
  }

  @override
  String agentHistoryTabAll(int count) {
    return 'Dépôts traités ($count)';
  }

  @override
  String get agentHistoryEmptyToday => 'Aucun dépôt traité aujourd\'hui';

  @override
  String get agentHistoryEmptyAll => 'Aucun dépôt traité';

  @override
  String get agentHistoryEmptyMessage =>
      'Scannez le QR code d\'un usager pour commencer.';

  @override
  String get agentHistoryDepositor => 'Déposant : ';

  @override
  String get agentHistoryRealWeight => 'Poids réel : ';

  @override
  String commonUserLabel(String id) {
    return 'Usager $id';
  }

  @override
  String get commentOptional => 'Commentaire (facultatif)';

  @override
  String get errorUnauthenticated =>
      'Session expirée. Relancez l\'application.';

  @override
  String get errorNotRelayAgent =>
      'Ce compte n\'est pas un agent relais actif.';

  @override
  String get errorTicketNotFound => 'Dépôt introuvable.';

  @override
  String get errorTicketAlreadyProcessed => 'Ce dépôt a déjà été traité.';

  @override
  String get errorTicketExpired => 'Ce dépôt a expiré (plus de 48 h).';

  @override
  String get errorInvalidTicketCode => 'Ce QR code n\'est pas un dépôt.';

  @override
  String get errorInvalidWeight => 'Poids invalide (entre 0 et 50 kg).';

  @override
  String get errorCommentRequired => 'Un commentaire est obligatoire.';

  @override
  String get errorCommentTooLong =>
      'Commentaire trop long (500 caractères max).';

  @override
  String get errorUnexpected => 'Une erreur inattendue est survenue.';

  @override
  String get rejectionItemMismatch => 'Objet différent de celui analysé';

  @override
  String get rejectionNotRecyclable => 'Matière non acceptée ou non recyclable';

  @override
  String get rejectionItemMissing => 'Objet absent lors du dépôt';

  @override
  String get rejectionOther => 'Autre motif';

  @override
  String agentScanCameraUnavailable(String code) {
    return 'Caméra indisponible ($code).\nAutorisez l\'accès à la caméra dans les réglages.';
  }

  @override
  String get scanAgentHint =>
      'Pointez l\'objectif sur le QR code généré sur l\'écran du déposant';

  @override
  String get scanAgentChip => 'Scanner QR Déposant';

  @override
  String get scanTorch => 'Lampe';

  @override
  String get scanLoadingDeposit => 'Chargement du dépôt…';

  @override
  String get scanAnother => 'Scanner un autre QR';

  @override
  String get scanDetected => 'QR DÉTECTÉ AVEC SUCCÈS';

  @override
  String get scanOpenWeighing => 'Voir la fiche du dépôt & peser';

  @override
  String depositTitle(String code) {
    return 'Dépôt $code';
  }

  @override
  String get depositMaterial => 'Matériau';

  @override
  String get depositDepositor => 'Déposant';

  @override
  String get depositEstimatedWeight => 'Poids estimé : ';

  @override
  String depositEstimatedPoints(String points) {
    return '~$points pts estimés';
  }

  @override
  String get weighingTitle => 'Validation de la pesée';

  @override
  String get weighingEstimatedTitle => 'Poids estimé (IA)';

  @override
  String get weighingRealTitle => 'Poids réel (Balance)';

  @override
  String weighingEstimatedCaption(String points) {
    return '≈ $points pts estimés';
  }

  @override
  String get weighingEnterWeight => 'Saisir le poids pesé';

  @override
  String weighingCertifiedCaption(String points) {
    return '= $points pts certifiés';
  }

  @override
  String get weighingCommentRequired =>
      'Commentaire (obligatoire : écart important)';

  @override
  String get weighingValidate => 'Valider le dépôt';

  @override
  String weighingValidateWithPoints(String points) {
    return 'Valider le dépôt ($points pts)';
  }

  @override
  String get weighingReject => 'Refuser le dépôt';

  @override
  String weighingDepositId(String code) {
    return 'Dépôt ID : $code';
  }

  @override
  String weighingAiConfidence(String percent) {
    return 'IA $percent';
  }

  @override
  String weighingDeviationOk(String diff, String limit) {
    return 'Écart : $diff kg (OK, ≤ $limit)';
  }

  @override
  String weighingDeviationHigh(String diff, String limit) {
    return 'Écart : $diff kg (> $limit, à justifier)';
  }

  @override
  String get resultCertifiedPill => 'PESÉE CERTIFIÉE';

  @override
  String get resultRejectedPill => 'DÉPÔT REFUSÉ';

  @override
  String get resultValidatedTitle => 'Dépôt validé !';

  @override
  String get resultRejectedTitle => 'Dépôt refusé';

  @override
  String resultPointsCredited(String points, String user) {
    return '$points pts crédités à $user';
  }

  @override
  String resultUserNotified(String user) {
    return '$user a été notifié du motif.';
  }

  @override
  String get resultBackToDashboard => 'Retour au tableau de bord';

  @override
  String get rejectTitle => 'Motif de refus du dépôt';

  @override
  String get rejectSubtitle =>
      'Sélectionnez le motif : il sera affiché à l\'usager.';

  @override
  String get rejectCommentRequired => 'Précisez le motif (obligatoire)';

  @override
  String get rejectConfirm => 'Confirmer le refus';

  @override
  String get detailSheetTitle => 'Fiche du dépôt';

  @override
  String detailId(String code) {
    return 'ID : $code';
  }

  @override
  String get detailStatus => 'Statut';

  @override
  String get detailRealWeight => 'Poids réel';

  @override
  String get detailCertifiedWeight => 'Poids réel certifié';

  @override
  String get detailPointsAwarded => 'Points attribués';

  @override
  String get detailPointsEstimated => 'Points estimés';

  @override
  String get detailReason => 'Motif du refus';

  @override
  String get detailComment => 'Commentaire de l\'agent';

  @override
  String get detailRejectedBy => 'Refusé par';

  @override
  String get detailValidatedBy => 'Validé par';

  @override
  String get detailProcessedAt => 'Traité le';

  @override
  String get detailDepositedAt => 'Déposé le';

  @override
  String get detailQrTitle => 'QR Code à présenter à l\'agent';

  @override
  String detailQrHint(String date) {
    return 'L\'agent scannera ce code pour charger votre pesée. Valable jusqu\'au $date.';
  }

  @override
  String get placesKindRecyclingCenter => 'Centre de recyclage';

  @override
  String get placesKindSortingCenter => 'Centre de tri';

  @override
  String get placesKindDump => 'Dépotoir';

  @override
  String get placesKindScrapDealer => 'Ferrailleur';

  @override
  String get placesTypeRelay => 'Point relais SecondLife';

  @override
  String get placesTypeRecycling => 'Lieu de recyclage';

  @override
  String agentInfoRemaining(int amount) {
    return 'Encore $amount kg avant l\'enlèvement du lot.';
  }

  @override
  String get authForgotSubtitle =>
      'Saisis ton email : nous t\'enverrons un lien pour choisir un nouveau mot de passe.';

  @override
  String get authForgotButton => 'Envoyer le lien';

  @override
  String get authForgotSent =>
      'Email envoyé ! Vérifie ta boîte de réception (et les spams).';

  @override
  String get authForgotError => 'Impossible d\'envoyer l\'email. Réessaie.';

  @override
  String get authErrorInvalidEmail => 'Adresse email invalide.';

  @override
  String get profileNotificationsError =>
      'Impossible d\'enregistrer la préférence. Réessaie.';

  @override
  String get notifChannelGeneralName => 'Notifications générales';

  @override
  String get notifChannelGeneralDescription =>
      'Informations générales et mises à jour';

  @override
  String get notifChannelRemindersName => 'Rappels';

  @override
  String get notifChannelRemindersDescription =>
      'Rappels personnalisés et planifiés';

  @override
  String get notifChannelAlertsName => 'Alertes importantes';

  @override
  String get notifChannelAlertsDescription =>
      'Alertes critiques nécessitant une attention immédiate';

  @override
  String get notifChannelProcessingName => 'Traitements';

  @override
  String get notifChannelProcessingDescription => 'Fin des analyses de déchets';

  @override
  String get rewardsTitle => 'Récompenses';

  @override
  String get rewardsBalanceLabel => 'Solde disponible';

  @override
  String rewardsCost(int points) {
    return '$points pts';
  }

  @override
  String get rewardsRedeem => 'Échanger';

  @override
  String rewardsMissing(int points) {
    return 'Encore $points pts';
  }

  @override
  String get rewardsOutOfStock => 'Épuisé';

  @override
  String rewardsStockLeft(int count) {
    return 'Plus que $count';
  }

  @override
  String rewardsValidity(int days) {
    return 'Valable $days jours après l\'échange';
  }

  @override
  String rewardsConfirmTitle(int points) {
    return 'Échanger $points pts ?';
  }

  @override
  String rewardsConfirmMessage(String name, int balance) {
    return 'Vous recevrez « $name ». Il vous restera $balance pts.';
  }

  @override
  String get rewardsSuccessTitle => 'Bon obtenu !';

  @override
  String rewardsSuccessMessage(String partner) {
    return 'Présentez ce code chez $partner.';
  }

  @override
  String get rewardsSeeVouchers => 'Voir mes bons';

  @override
  String get rewardsErrorInsufficient =>
      'Solde insuffisant pour cette récompense.';

  @override
  String get rewardsErrorOutOfStock => 'Cette récompense est épuisée.';

  @override
  String get rewardsErrorGeneric => 'L\'échange n\'a pas abouti. Réessayez.';

  @override
  String get rewardsEmpty => 'Aucune récompense disponible pour le moment.';

  @override
  String homeNextReward(int points, String name) {
    return 'Encore $points pts pour « $name »';
  }

  @override
  String get homeAllRewardsUnlocked =>
      'Toutes les récompenses sont à votre portée !';

  @override
  String get historyEmptyGiftCta => 'Voir les récompenses';

  @override
  String get notifWelcomeTitle => 'Bienvenue sur SecondLife !';

  @override
  String notifWelcomeBody(int points) {
    return '$points pts de bienvenue ont été crédités sur votre compte.';
  }

  @override
  String get notifValidatedTitle => 'Dépôt validé';

  @override
  String notifValidatedBody(int points, String item) {
    return '+$points pts pour « $item ».';
  }

  @override
  String get notifRejectedTitle => 'Dépôt refusé';

  @override
  String notifRejectedBody(String item, String reason) {
    return '« $item » : $reason';
  }

  @override
  String get notifVoucherTitle => 'Bon obtenu';

  @override
  String notifVoucherBody(String name) {
    return '« $name » vous attend dans vos récompenses.';
  }

  @override
  String get notifUnknown => 'Nouvelle notification';

  @override
  String get notificationsMarkAllRead => 'Tout marquer comme lu';

  @override
  String get timeJustNow => 'À l\'instant';

  @override
  String timeMinutesAgo(int count) {
    return 'Il y a $count min';
  }

  @override
  String timeHoursAgo(int count) {
    return 'Il y a $count h';
  }

  @override
  String get agentBatchCollect => 'Lot enlevé';

  @override
  String get agentBatchCollectConfirmTitle => 'Confirmer l\'enlèvement ?';

  @override
  String agentBatchCollectConfirmMessage(int amount) {
    return 'Le compteur du lot ($amount kg) repartira de zéro.';
  }

  @override
  String get agentBatchCollected => 'Lot enregistré comme enlevé.';

  @override
  String get agentBatchError => 'Impossible d\'enregistrer l\'enlèvement.';

  @override
  String agentBatchLastPickup(String date) {
    return 'Dernier enlèvement : $date';
  }
}
