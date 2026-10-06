import "dart:async";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/errors/failure.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../domain/usecases/reject_ticket.dart";
import "../../domain/usecases/validate_ticket.dart";
import "agent_history_provider.dart";
import "pending_tickets_provider.dart";
import "ticket_validation_providers.dart";

part "ticket_validation_provider.g.dart";

// Ticket en cours de traitement par l'agent.
// validate et reject renvoient l'échec au lieu de le mettre dans l'état :
// l'agent garde le ticket affiché et peut corriger sa saisie.
@Riverpod(keepAlive: true)
class TicketValidationNotifier extends _$TicketValidationNotifier {
  @override
  FutureOr<RecyclingTicket?> build() => null;

  // input : contenu du QR code ou code saisi à la main.
  Future<void> loadTicket(String input) async {
    state = const AsyncValue.loading();
    final usecase = ref.read(getTicketByCodeProvider);
    final result = await usecase(input);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (ticket) => state = AsyncValue.data(ticket),
    );
  }

  Future<Failure?> validate({
    required double measuredWeightGrams,
    String? comment,
  }) async {
    final ticket = state.value;
    if (ticket == null) return TicketNotFoundFailure();

    final usecase = ref.read(validateTicketProvider);
    final result = await usecase(
      ValidateTicketParams(
        ticket: ticket,
        measuredWeightGrams: measuredWeightGrams,
        comment: comment,
      ),
    );
    return result.fold<Failure?>((failure) => failure, _onProcessed);
  }

  Future<Failure?> reject({
    required RejectionReason reason,
    String? comment,
  }) async {
    final ticket = state.value;
    if (ticket == null) return TicketNotFoundFailure();

    final usecase = ref.read(rejectTicketProvider);
    final result = await usecase(
      RejectTicketParams(code: ticket.code, reason: reason, comment: comment),
    );
    return result.fold<Failure?>((failure) => failure, _onProcessed);
  }

  void clear() => state = const AsyncValue.data(null);

  Failure? _onProcessed(RecyclingTicket ticket) {
    state = AsyncValue.data(ticket);
    ref
      ..invalidate(agentHistoryProvider)
      ..invalidate(pendingTicketsProvider);
    return null;
  }
}
