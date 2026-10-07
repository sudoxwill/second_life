import "package:equatable/equatable.dart";

// Lot en cours d'un point relais : rempli à chaque validation, vidé quand le
// camion passe.
class RelayPointStock extends Equatable {
  const RelayPointStock({
    this.currentBatchGrams = 0,
    this.batchTargetKg = defaultBatchTargetKg,
    this.lastPickupAt,
    this.pickupsCount = 0,
  });

  static const defaultBatchTargetKg = 200;

  final double currentBatchGrams;
  final int batchTargetKg;
  final DateTime? lastPickupAt;
  final int pickupsCount;

  double get progress =>
      (currentBatchGrams / (batchTargetKg * 1000)).clamp(0.0, 1.0);

  int get collectedKg => (currentBatchGrams / 1000).round();

  int get remainingKg =>
      (batchTargetKg - currentBatchGrams / 1000).ceil().clamp(0, batchTargetKg);

  @override
  List<Object?> get props => [
    currentBatchGrams,
    batchTargetKg,
    lastPickupAt,
    pickupsCount,
  ];
}
