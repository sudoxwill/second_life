import "package:dartz/dartz.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failures_mapper.dart";
import "../../domain/entities/map_point.dart";
import "../../domain/repositories/places_repository.dart";
import "../datasources/places_remote_datasource.dart";

class PlacesRepositoryImpl implements PlacesRepository {
  new(this.placesRemoteDatasource);
  final PlacesRemoteDatasource placesRemoteDatasource;

  @override
  Future<Either<Failure, List<MapPoint>>> getMapPoints() async {
    try {
      return Right(await placesRemoteDatasource.getMapPoints());
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (e) {
      return Left(UnExpectedFailure());
    }
  }
}
