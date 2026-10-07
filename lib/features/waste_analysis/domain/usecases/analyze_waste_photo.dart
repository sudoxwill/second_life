import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/waste_analysis_result.dart";
import "../repositories/waste_analysis_repository.dart";

class AnalyzeWastePhoto
    implements Usecase<Either<Failure, WasteAnalysisResult>, String> {
  new(this.wasteAnalysisRepository);
  final WasteAnalysisRepository wasteAnalysisRepository;

  @override
  Future<Either<Failure, WasteAnalysisResult>> call(String imageUrl) async {
    return wasteAnalysisRepository.analyzeWastePhoto(imageUrl);
  }
}
