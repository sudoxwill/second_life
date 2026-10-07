import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/domain/usecases/usecase.dart";
import "../../domain/entities/map_point.dart";
import "places_providers.dart";

part "map_points_provider.g.dart";

@Riverpod(keepAlive: true)
class MapPointsNotifier extends _$MapPointsNotifier {
  @override
  FutureOr<List<MapPoint>> build() => _fetchPoints();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPoints);
  }

  Future<List<MapPoint>> _fetchPoints() async {
    final usecase = ref.read(getMapPointsProvider);
    final result = await usecase(NoParam());

    return result.fold((failure) => throw failure, (points) => points);
  }
}

// Point affiché par la fiche détail, retrouvé dans la liste déjà chargée.
@riverpod
AsyncValue<MapPoint?> mapPointById(Ref ref, String id) {
  return ref
      .watch(mapPointsProvider)
      .whenData((points) => points.where((p) => p.id == id).firstOrNull);
}
