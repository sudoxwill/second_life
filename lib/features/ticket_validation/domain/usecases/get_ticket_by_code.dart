import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../core/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../repositories/ticket_validation_repository.dart";

// Reçoit le contenu du QR code ou le code saisi à la main.
class GetTicketByCode
    implements Usecase<Either<Failure, RecyclingTicket>, String> {
  new(this.ticketValidationRepository);
  final TicketValidationRepository ticketValidationRepository;

  @override
  Future<Either<Failure, RecyclingTicket>> call(String input) async {
    final code = RecyclingTicket.codeFromInput(input);
    if (code == null) return Left(InvalidTicketCodeFailure());

    return ticketValidationRepository.getTicketByCode(code);
  }
}
