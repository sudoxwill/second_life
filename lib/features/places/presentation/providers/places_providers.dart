import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";
import "../../data/datasources/places_remote_datasource.dart";
import "../../data/repositories/places_repository_impl.dart";
import "../../domain/repositories/places_repository.dart";
import "../../domain/usecases/get_map_points.dart";

part "places_providers.g.dart";

@Riverpod(keepAlive: true)
PlacesRemoteDatasource placesRemoteDatasource(Ref ref) =>
    PlacesRemoteDatasourceImpl(ref.watch(firebaseFirestoreProvider));

@Riverpod(keepAlive: true)
PlacesRepository placesRepository(Ref ref) =>
    PlacesRepositoryImpl(ref.watch(placesRemoteDatasourceProvider));

@Riverpod(keepAlive: true)
GetMapPoints getMapPoints(Ref ref) =>
    GetMapPoints(ref.watch(placesRepositoryProvider));
