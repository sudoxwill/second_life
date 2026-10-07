import "dart:ui" show Locale, PlatformDispatcher;

import "../../l10n/app_localizations.dart";

class NotificationChannel {
  NotificationChannel._();

  static const String generalId = "second_life_general";
  static const String remindersId = "second_life_reminders";
  static const String alertsId = "second_life_alerts";
  static const String processingId = "second_life_processing";

  // Les canaux sont créés avant runApp, hors de tout BuildContext : leurs
  // noms suivent la langue de l'appareil (français par défaut).
  static AppLocalizations get _l10n {
    final locale = PlatformDispatcher.instance.locale;
    return AppLocalizations.delegate.isSupported(locale)
        ? lookupAppLocalizations(locale)
        : lookupAppLocalizations(const Locale("fr"));
  }

  static String get generalName => _l10n.notifChannelGeneralName;
  static String get remindersName => _l10n.notifChannelRemindersName;
  static String get alertsName => _l10n.notifChannelAlertsName;
  static String get processingName => _l10n.notifChannelProcessingName;

  static String get generalDescription => _l10n.notifChannelGeneralDescription;
  static String get remindersDescription =>
      _l10n.notifChannelRemindersDescription;
  static String get alertsDescription => _l10n.notifChannelAlertsDescription;
  static String get processingDescription =>
      _l10n.notifChannelProcessingDescription;
}

class NotificationId {
  NotificationId._();

  static const int welcome = 1;
  static const int accountUpdate = 2;
  static const int goodBye = 3;
  static const int checkout = 4;

  // Une seule notification pour la fin de la file d'attente,
  // remplacée à chaque nouveau lot.
  static const int queueDone = 10000;

  // Ids 100 à 9999 : rappels liés à une entité
  static int forReminder(int entityId) => 100 + (entityId % 9900);
}
