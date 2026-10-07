import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/domain/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../domain/entities/agent_daily_stats.dart";
import "../../domain/entities/agent_stats.dart";
import "ticket_validation_providers.dart";

part "agent_history_provider.g.dart";

@Riverpod(keepAlive: true)
class AgentHistoryNotifier extends _$AgentHistoryNotifier {
  @override
  FutureOr<List<RecyclingTicket>> build() => _fetchHistory();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchHistory);
  }

  Future<List<RecyclingTicket>> _fetchHistory() async {
    final usecase = ref.read(getAgentHistoryProvider);
    final result = await usecase(NoParam());

    return result.fold((failure) => throw failure, (tickets) => tickets);
  }
}

@Riverpod(keepAlive: true)
AsyncValue<AgentStats> agentStats(Ref ref) =>
    ref.watch(agentHistoryProvider).whenData(AgentStats.fromTickets);

@Riverpod(keepAlive: true)
AsyncValue<AgentDailyStats> agentDailyStats(Ref ref) => ref
    .watch(agentHistoryProvider)
    .whenData((t) => AgentDailyStats.fromTickets(t, now: DateTime.now()));
