class AppUserStats {
  const AppUserStats({
    required this.totalKg,
    required this.depositsCount,
    required this.reportsTreatedCount,
  });

  static const empty = AppUserStats(
    totalKg: 0,
    depositsCount: 0,
    reportsTreatedCount: 0,
  );

  final double totalKg;
  final int depositsCount;
  final int reportsTreatedCount;
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.displayName,
    this.phoneNumber,
    this.pointsBalance = 0,
    this.pendingPoints = 0,
    this.stats = AppUserStats.empty,
    this.reliabilityScore = 1.0,
    this.frequentRelayPointId,
    this.lastKnownGeohash,
    this.notificationsEnabled = true,
    this.fcmToken,
    this.createdAt,
  });

  final String uid;
  final String displayName;
  final String? phoneNumber;
  final int pointsBalance;
  final int pendingPoints;
  final AppUserStats stats;
  final double reliabilityScore;
  final String? frequentRelayPointId;
  final String? lastKnownGeohash;
  final bool notificationsEnabled;
  final String? fcmToken;
  final DateTime? createdAt;
}
