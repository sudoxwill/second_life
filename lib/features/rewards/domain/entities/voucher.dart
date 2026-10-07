import "package:equatable/equatable.dart";

enum VoucherStatus { active, used, expired }

// Bon obtenu en échange de points. Le nom et le partenaire sont recopiés
// depuis la récompense, dans toutes les langues.
class Voucher extends Equatable {
  const Voucher({
    required this.id,
    required this.name,
    required this.partnerName,
    required this.pointsSpent,
    required this.obtainedAt,
    required this.expiresAt,
    required this.code,
    required this.status,
    this.rewardId,
    this.usedAt,
  });

  final String id;
  final Object? name;
  final Object? partnerName;
  final int pointsSpent;
  final DateTime obtainedAt;
  final DateTime expiresAt;
  final String code;
  final VoucherStatus status;
  final String? rewardId;
  final DateTime? usedAt;

  @override
  List<Object?> get props => [id, status, usedAt];
}
