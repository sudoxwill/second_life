import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/map_point.dart";
import "../repositories/places_repository.dart";

// Points relais et lieux de recyclage actifs, toutes catégories confondues.
class GetMapPoints
    implements Usecase<Either<Failure, List<MapPoint>>, NoParam> {
  new(this.placesRepository);
  final PlacesRepository placesRepository;

  @override
  Future<Either<Failure, List<MapPoint>>> call(NoParam p) {
    return placesRepository.getMapPoints();
  }
}
