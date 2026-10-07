import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/recycling_ticket.dart";
import "../repositories/waste_analysis_repository.dart";

class GetUserTickets
    implements Usecase<Either<Failure, List<RecyclingTicket>>, NoParam> {
  new(this.wasteAnalysisRepository);
  final WasteAnalysisRepository wasteAnalysisRepository;

  @override
  Future<Either<Failure, List<RecyclingTicket>>> call(NoParam p) {
    return wasteAnalysisRepository.getUserTickets();
  }
}
