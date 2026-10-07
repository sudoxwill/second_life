import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../domain/entities/relay_point_stock.dart";
import "current_relay_agent_provider.dart";
import "ticket_validation_providers.dart";

part "relay_point_stock_provider.g.dart";

// Lot en cours du point relais de l'agent connecté.
@Riverpod(keepAlive: true)
Stream<RelayPointStock> relayPointStock(Ref ref) {
  final agent = ref.watch(currentRelayAgentProvider).value;
  if (agent == null) return Stream.value(const RelayPointStock());
  return ref.watch(watchRelayPointStockProvider)(agent.relayPointId);
}
