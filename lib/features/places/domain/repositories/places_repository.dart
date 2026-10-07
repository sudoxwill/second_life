import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../entities/map_point.dart";

abstract class PlacesRepository {
  Future<Either<Failure, List<MapPoint>>> getMapPoints();
}
