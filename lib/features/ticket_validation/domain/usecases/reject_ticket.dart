import "package:dartz/dartz.dart";
import "package:equatable/equatable.dart";

import "../../../../core/errors/failure.dart";
import "../../../../core/usecases/usecase.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../repositories/ticket_validation_repository.dart";
import "../ticket_validation_policy.dart";

class RejectTicketParams extends Equatable {
  const RejectTicketParams({
    required this.code,
    required this.reason,
    this.comment,
  });
  final String code;
  final RejectionReason reason;
  final String? comment;

  @override
  List<Object?> get props => [code, reason, comment];
}

class RejectTicket
    implements Usecase<Either<Failure, RecyclingTicket>, RejectTicketParams> {
  new(this.ticketValidationRepository);
  final TicketValidationRepository ticketValidationRepository;

  @override
  Future<Either<Failure, RecyclingTicket>> call(RejectTicketParams p) async {
    final comment = TicketValidationPolicy.normalizeComment(p.comment);

    if (comment != null &&
        comment.length > TicketValidationPolicy.maxCommentLength) {
      return Left(CommentTooLongFailure());
    }
    if (comment == null && p.reason == RejectionReason.other) {
      return Left(CommentRequiredFailure());
    }

    return ticketValidationRepository.rejectTicket(
      code: p.code,
      reason: p.reason,
      comment: comment,
    );
  }
}
