import "package:dartz/dartz.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failures_mapper.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../domain/repositories/ticket_validation_repository.dart";
import "../datasources/ticket_validation_remote_datasource.dart";

class TicketValidationRepositoryImpl implements TicketValidationRepository {
  new(this.ticketValidationRemoteDatasource);
  final TicketValidationRemoteDatasource ticketValidationRemoteDatasource;

  @override
  Future<Either<Failure, RelayAgent>> getCurrentRelayAgent() {
    return _run(ticketValidationRemoteDatasource.getCurrentRelayAgent);
  }

  @override
  Future<Either<Failure, RecyclingTicket>> getTicketByCode(String code) {
    return _run(() => ticketValidationRemoteDatasource.getTicketByCode(code));
  }

  @override
  Future<Either<Failure, RecyclingTicket>> validateTicket({
    required String code,
    required double measuredWeightGrams,
    String? comment,
  }) {
    return _run(
      () => ticketValidationRemoteDatasource.validateTicket(
        code: code,
        measuredWeightGrams: measuredWeightGrams,
        comment: comment,
      ),
    );
  }

  @override
  Future<Either<Failure, RecyclingTicket>> rejectTicket({
    required String code,
    required RejectionReason reason,
    String? comment,
  }) {
    return _run(
      () => ticketValidationRemoteDatasource.rejectTicket(
        code: code,
        reason: reason,
        comment: comment,
      ),
    );
  }

  @override
  Future<Either<Failure, List<RecyclingTicket>>> getAgentHistory() {
    return _run(ticketValidationRemoteDatasource.getAgentHistory);
  }

  @override
  Future<Either<Failure, List<RecyclingTicket>>> getPendingTickets() {
    return _run(ticketValidationRemoteDatasource.getPendingTickets);
  }

  Future<Either<Failure, T>> _run<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (e) {
      return Left(UnExpectedFailure());
    }
  }
}
