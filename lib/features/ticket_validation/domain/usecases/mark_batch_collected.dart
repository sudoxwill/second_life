import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../repositories/relay_point_stock_repository.dart";

// Le camion est passé : le compteur du lot repart de zéro.
class MarkBatchCollected implements Usecase<Either<Failure, Unit>, String> {
  new(this.repository);
  final RelayPointStockRepository repository;

  @override
  Future<Either<Failure, Unit>> call(String relayPointId) =>
      repository.markBatchCollected(relayPointId);
}
