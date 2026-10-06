import "package:equatable/equatable.dart";

import "relay_agent.dart";
import "ticket_status.dart";

class TicketValidation extends Equatable {
  const TicketValidation({
    required this.processedAt,
    required this.agent,
    this.measuredWeightGrams,
    this.finalPoints,
    this.finalCo2SavedGrams,
    this.rejectionReason,
    this.comment,
  });
  final DateTime processedAt;
  final RelayAgent agent;
  final double? measuredWeightGrams;
  final double? finalPoints;
  final double? finalCo2SavedGrams;
  final RejectionReason? rejectionReason;
  final String? comment;

  @override
  List<Object?> get props => [
    processedAt,
    agent,
    measuredWeightGrams,
    finalPoints,
    finalCo2SavedGrams,
    rejectionReason,
    comment,
  ];
}
