import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/recycling_ticket.dart";
import "../entities/waste_analysis_result.dart";
import "../repositories/waste_analysis_repository.dart";

class SubmitWasteInfo
    implements Usecase<Either<Failure, RecyclingTicket>, WasteAnalysisResult> {
  new(this.wasteAnalysisRepository);
  final WasteAnalysisRepository wasteAnalysisRepository;

  @override
  Future<Either<Failure, RecyclingTicket>> call(
    WasteAnalysisResult wasteAnalysisResult,
  ) {
    return wasteAnalysisRepository.submitWasteInfo(wasteAnalysisResult);
  }
}
