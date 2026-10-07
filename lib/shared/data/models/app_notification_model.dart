import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/app_notification.dart";

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    required super.id,
    required super.type,
    required super.data,
    required super.read,
    required super.createdAt,
  });

  factory AppNotificationModel.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return AppNotificationModel(
      id: id,
      type: AppNotificationType.fromName(json["type"] as String?),
      data: (json["data"] as Map<String, dynamic>?) ?? const {},
      read: json["read"] as bool? ?? false,
      // Null tant que le serveur n'a pas posé l'horodatage.
      createdAt: (json["createdAt"] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
