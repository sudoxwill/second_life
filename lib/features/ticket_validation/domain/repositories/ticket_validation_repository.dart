import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";

abstract class TicketValidationRepository {
  Future<Either<Failure, RelayAgent>> getCurrentRelayAgent();
  Future<Either<Failure, RecyclingTicket>> getTicketByCode(String code);
  Future<Either<Failure, RecyclingTicket>> validateTicket({
    required String code,
    required double measuredWeightGrams,
    String? comment,
  });
  Future<Either<Failure, RecyclingTicket>> rejectTicket({
    required String code,
    required RejectionReason reason,
    String? comment,
  });
  Future<Either<Failure, List<RecyclingTicket>>> getAgentHistory();
  Future<Either<Failure, List<RecyclingTicket>>> getPendingTickets();
}
