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
}
