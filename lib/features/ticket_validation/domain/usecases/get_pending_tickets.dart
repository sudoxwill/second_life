import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../repositories/ticket_validation_repository.dart";

// Tickets en attente et non expirés, du plus récent au plus ancien.
class GetPendingTickets
    implements Usecase<Either<Failure, List<RecyclingTicket>>, NoParam> {
  new(this.ticketValidationRepository);
  final TicketValidationRepository ticketValidationRepository;

  @override
  Future<Either<Failure, List<RecyclingTicket>>> call(NoParam p) {
    return ticketValidationRepository.getPendingTickets();
  }
}
