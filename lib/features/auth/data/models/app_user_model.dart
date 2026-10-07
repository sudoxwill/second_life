import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/app_user.dart";

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.uid,
    required super.displayName,
    super.phoneNumber,
    super.pointsBalance,
    super.pendingPoints,
    super.stats,
    super.reliabilityScore,
    super.frequentRelayPointId,
    super.lastKnownGeohash,
    super.notificationsEnabled,
    super.fcmToken,
    super.createdAt,
  });

  factory AppUserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    final statsData = data["stats"] as Map<String, dynamic>?;
    return AppUserModel(
      uid: uid,
      displayName: data["displayName"] as String? ?? "",
      phoneNumber: data["phoneNumber"] as String?,
      pointsBalance: (data["pointsBalance"] as num?)?.round() ?? 0,
      pendingPoints: (data["pendingPoints"] as num?)?.round() ?? 0,
      stats: AppUserStats(
        totalKg: (statsData?["totalKg"] as num?)?.toDouble() ?? 0,
        depositsCount: (statsData?["depositsCount"] as num?)?.round() ?? 0,
        reportsTreatedCount: statsData?["reportsTreatedCount"] as int? ?? 0,
      ),
      reliabilityScore: (data["reliabilityScore"] as num?)?.toDouble() ?? 1.0,
      frequentRelayPointId: data["frequentRelayPointId"] as String?,
      lastKnownGeohash: data["lastKnownGeohash"] as String?,
      notificationsEnabled: data["notificationsEnabled"] as bool? ?? true,
      fcmToken: data["fcmToken"] as String?,
      createdAt: (data["createdAt"] as Timestamp?)?.toDate(),
    );
  }
}
