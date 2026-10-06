import "package:dartz/dartz.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failures_mapper.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/waste_analysis_result.dart";
import "../../domain/repositories/waste_analysis_repository.dart";
import "../datasources/recycling_ticket_remote_datasource.dart";
import "../datasources/waste_analysis_remote_datasource.dart";
import "../models/waste_analysis_result_model.dart";

class WasteAnalysisRepositoryImpl implements WasteAnalysisRepository {
  new(this.wasteAnalysisRemoteDatasource, this.recyclingTicketRemoteDatasource);
  final WasteAnalysisRemoteDatasource wasteAnalysisRemoteDatasource;
  final RecyclingTicketRemoteDatasource recyclingTicketRemoteDatasource;

  @override
  Future<Either<Failure, WasteAnalysisResult>> analyzeWastePhoto(
    String imageUrl,
  ) async {
    try {
      final wastedAnalysisResult = await wasteAnalysisRemoteDatasource
          .analyzeWastePhoto(imageUrl);
      return Right(wastedAnalysisResult);
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (e) {
      return Left(UnExpectedFailure());
    }
  }

  @override
  Future<Either<Failure, RecyclingTicket>> submitWasteInfo(
    WasteAnalysisResult wasteAnalysisResult,
  ) async {
    try {
      final recyclingTicket = await recyclingTicketRemoteDatasource
          .createTicket(
            WasteAnalysisResultModel.fromEntity(wasteAnalysisResult),
          );
      return Right(recyclingTicket);
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (e) {
      return Left(UnExpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<RecyclingTicket>>> getUserTickets() async {
    try {
      final recyclingTickets = await recyclingTicketRemoteDatasource
          .getUserTickets();
      return Right(recyclingTickets);
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (e) {
      return Left(UnExpectedFailure());
    }
  }
}
