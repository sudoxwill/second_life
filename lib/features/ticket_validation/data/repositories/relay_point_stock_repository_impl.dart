import "package:dartz/dartz.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failures_mapper.dart";
import "../../domain/entities/relay_point_stock.dart";
import "../../domain/repositories/relay_point_stock_repository.dart";
import "../datasources/relay_point_stock_remote_datasource.dart";

class RelayPointStockRepositoryImpl implements RelayPointStockRepository {
  new(this.remoteDatasource);
  final RelayPointStockRemoteDatasource remoteDatasource;

  @override
  Stream<RelayPointStock> watch(String relayPointId) =>
      remoteDatasource.watch(relayPointId);

  @override
  Future<Either<Failure, Unit>> markBatchCollected(String relayPointId) async {
    try {
      await remoteDatasource.markBatchCollected(relayPointId);
      return const Right(unit);
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (_) {
      return Left(UnExpectedFailure());
    }
  }
}
