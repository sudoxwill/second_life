import "package:dartz/dartz.dart";
import "package:equatable/equatable.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../repositories/ticket_validation_repository.dart";
import "../ticket_validation_policy.dart";

class ValidateTicketParams extends Equatable {
  const ValidateTicketParams({
    required this.ticket,
    required this.measuredWeightGrams,
    this.comment,
  });
  final RecyclingTicket ticket;
  final double measuredWeightGrams;
  final String? comment;

  @override
  List<Object?> get props => [ticket, measuredWeightGrams, comment];
}

class ValidateTicket
    implements Usecase<Either<Failure, RecyclingTicket>, ValidateTicketParams> {
  new(this.ticketValidationRepository);
  final TicketValidationRepository ticketValidationRepository;

  @override
  Future<Either<Failure, RecyclingTicket>> call(ValidateTicketParams p) async {
    final comment = TicketValidationPolicy.normalizeComment(p.comment);
    final estimatedWeight =
        p.ticket.wasteAnalysisResult.itemWeight.estimatedWeight;

    if (!TicketValidationPolicy.isWeightAllowed(p.measuredWeightGrams)) {
      return Left(InvalidWeightFailure());
    }
    if (comment != null &&
        comment.length > TicketValidationPolicy.maxCommentLength) {
      return Left(CommentTooLongFailure());
    }
    if (comment == null &&
        TicketValidationPolicy.isWeightDeviated(
          p.measuredWeightGrams,
          estimatedWeight,
        )) {
      return Left(CommentRequiredFailure());
    }

    return ticketValidationRepository.validateTicket(
      code: p.ticket.code,
      measuredWeightGrams: p.measuredWeightGrams,
      comment: comment,
    );
  }
}
