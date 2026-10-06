enum VoucherStatus { active, used, expired }

class VoucherEntity {
  const VoucherEntity({
    required this.id,
    required this.name,
    required this.partnerName,
    required this.pointsSpent,
    required this.obtainedAt,
    required this.expiresAt,
    required this.voucherCode,
    required this.status,
    this.usedAt,
  });

  final String id;
  final String name;
  final String partnerName;
  final int pointsSpent;
  final DateTime obtainedAt;
  final DateTime expiresAt;
  final String voucherCode;
  final VoucherStatus status;
  final DateTime? usedAt;
}
