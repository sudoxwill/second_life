import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "ticket_validation_providers.dart";

part "pending_tickets_provider.g.dart";

@Riverpod(keepAlive: true)
class PendingTicketsNotifier extends _$PendingTicketsNotifier {
  @override
  FutureOr<List<RecyclingTicket>> build() => _fetchTickets();

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchTickets);
  }

  Future<List<RecyclingTicket>> _fetchTickets() async {
    final usecase = ref.read(getPendingTicketsProvider);
    final result = await usecase(NoParam());

    return result.fold((failure) => throw failure, (tickets) => tickets);
  }
}
