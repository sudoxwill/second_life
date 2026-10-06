import "package:equatable/equatable.dart";

import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";

class AgentStats extends Equatable {
  const AgentStats({
    required this.validatedCount,
    required this.rejectedCount,
    required this.collectedWeightGrams,
  });

  factory AgentStats.fromTickets(List<RecyclingTicket> tickets) {
    final validated = tickets.where((t) => t.status == TicketStatus.validated);
    final rejected = tickets.where((t) => t.status == TicketStatus.rejected);
    return AgentStats(
      validatedCount: validated.length,
      rejectedCount: rejected.length,
      collectedWeightGrams: validated.fold(
        0,
        (sum, t) => sum + (t.validation?.measuredWeightGrams ?? 0),
      ),
    );
  }
  final int validatedCount;
  final int rejectedCount;
  final double collectedWeightGrams;

  @override
  List<Object?> get props => [
    validatedCount,
    rejectedCount,
    collectedWeightGrams,
  ];
}
