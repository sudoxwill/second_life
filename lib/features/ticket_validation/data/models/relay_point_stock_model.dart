import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/relay_point_stock.dart";

class RelayPointStockModel extends RelayPointStock {
  const RelayPointStockModel({
    super.currentBatchGrams,
    super.batchTargetKg,
    super.lastPickupAt,
    super.pickupsCount,
  });

  // Document absent : lot vide, objectif par défaut.
  factory RelayPointStockModel.fromFirestore(Map<String, dynamic>? json) {
    if (json == null) return const RelayPointStockModel();
    return RelayPointStockModel(
      currentBatchGrams: (json["currentBatchGrams"] as num?)?.toDouble() ?? 0,
      batchTargetKg:
          (json["batchTargetKg"] as num?)?.round() ??
          RelayPointStock.defaultBatchTargetKg,
      lastPickupAt: (json["lastPickupAt"] as Timestamp?)?.toDate(),
      pickupsCount: (json["pickupsCount"] as num?)?.round() ?? 0,
    );
  }
}
