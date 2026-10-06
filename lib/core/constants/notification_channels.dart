class NotificationChannel {
  NotificationChannel._();

  static const String generalId = "second_life_general";
  static const String remindersId = "second_life_reminders";
  static const String alertsId = "second_life_alerts";
  static const String processingId = "second_life_processing";

  static const String generalName = "Notifications générales";
  static const String remindersName = "Rappels";
  static const String alertsName = "Alertes importantes";
  static const String processingName = "Traitements";

  static const String generalDescription =
      "Informations générales et mises à jour";
  static const String remindersDescription =
      "Rappels personnalisés et planifiés";
  static const String alertsDescription =
      "Alertes critiques nécessitant une attention immédiate";
  static const String processingDescription =
      "Fin des analyses différées (OCR, transcription)";
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
