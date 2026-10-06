import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "ticket_validation_providers.dart";

part "current_relay_agent_provider.g.dart";

// En erreur avec NotRelayAgentFailure si l'utilisateur n'est pas un agent
// actif : sert à décider s'il a accès à l'espace point relais.
@Riverpod(keepAlive: true)
class CurrentRelayAgentNotifier extends _$CurrentRelayAgentNotifier {
  @override
  FutureOr<RelayAgent> build() async {
    final usecase = ref.watch(getCurrentRelayAgentProvider);
    final result = await usecase(NoParam());

    return result.fold((failure) => throw failure, (agent) => agent);
  }
}
