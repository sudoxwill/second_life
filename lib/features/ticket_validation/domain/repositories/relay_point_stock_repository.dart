import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../entities/relay_point_stock.dart";

abstract class RelayPointStockRepository {
  Stream<RelayPointStock> watch(String relayPointId);
  Future<Either<Failure, Unit>> markBatchCollected(String relayPointId);
}
