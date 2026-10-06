import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../entities/recycling_ticket.dart";
import "../entities/waste_analysis_result.dart";

abstract class WasteAnalysisRepository {
  Future<Either<Failure, WasteAnalysisResult>> analyzeWastePhoto(
    String imageUrl,
  );
  Future<Either<Failure, RecyclingTicket>> submitWasteInfo(
    WasteAnalysisResult wasteAnalysisResult,
  );
  Future<Either<Failure, List<RecyclingTicket>>> getUserTickets();
}
