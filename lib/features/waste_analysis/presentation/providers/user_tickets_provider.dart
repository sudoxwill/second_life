import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/usecases/usecase.dart";
import "../../domain/entities/citizen_stats.dart";
import "../../domain/entities/recycling_ticket.dart";
import "waste_analysis_providers.dart";

part "user_tickets_provider.g.dart";

@Riverpod(keepAlive: true)
class UserTicketsNotifier extends _$UserTicketsNotifier {
  @override
  FutureOr<List<RecyclingTicket>> build() => _fetchTickets();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchTickets);
  }

  Future<List<RecyclingTicket>> _fetchTickets() async {
    final usecase = ref.read(getUserTicketsProvider);
    final result = await usecase(NoParam());

    return result.fold((failure) => throw failure, (tickets) => tickets);
  }
}

@Riverpod(keepAlive: true)
AsyncValue<CitizenStats> citizenStats(Ref ref) =>
    ref.watch(userTicketsProvider).whenData(CitizenStats.fromTickets);
