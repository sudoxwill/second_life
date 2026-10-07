enum DepositStatus { waiting, validated, rejected }

enum MaterialType { plastic, paper, metal, glass, ewaste, organic }

class DepositEntity {
  const DepositEntity({
    required this.id,
    required this.material,
    required this.estimatedWeight,
    required this.status,
    required this.centerName,
    required this.centerAddress,
    required this.dateTime,
    required this.qrData,
    this.centerLatitude,
    this.centerLongitude,
    this.realWeight,
    this.points,
    this.imageUrl,
    this.agentName,
    this.rejectionReason,
    this.validationDateTime,
  });

  final String id;
  final MaterialType material;
  final double estimatedWeight;
  final double? realWeight;
  final DepositStatus status;
  final String centerName;
  final String centerAddress;
  final double? centerLatitude;
  final double? centerLongitude;
  final DateTime dateTime;
  final int? points;
  final String? imageUrl;
  final String? agentName;
  final String? rejectionReason;
  final String qrData;
  final DateTime? validationDateTime;
}
