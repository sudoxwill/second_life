import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/relay_point_stock.dart";
import "../repositories/relay_point_stock_repository.dart";

// Lot en cours du point relais donné, en temps réel.
class WatchRelayPointStock implements StreamUsecase<RelayPointStock, String> {
  new(this.repository);
  final RelayPointStockRepository repository;

  @override
  Stream<RelayPointStock> call(String relayPointId) =>
      repository.watch(relayPointId);
}
