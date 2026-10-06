import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../core/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../repositories/ticket_validation_repository.dart";

class GetCurrentRelayAgent
    implements Usecase<Either<Failure, RelayAgent>, NoParam> {
  new(this.ticketValidationRepository);
  final TicketValidationRepository ticketValidationRepository;

  @override
  Future<Either<Failure, RelayAgent>> call(NoParam p) {
    return ticketValidationRepository.getCurrentRelayAgent();
  }
}
