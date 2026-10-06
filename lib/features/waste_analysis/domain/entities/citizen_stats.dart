import "package:equatable/equatable.dart";

import "recycling_ticket.dart";
import "ticket_status.dart";

// Calculé à partir des tickets de l'usager : il n'y a pas encore de
// solde stocké côté serveur.
class CitizenStats extends Equatable {
  const CitizenStats({
    required this.pointsBalance,
    required this.pendingPoints,
    required this.pendingCount,
    required this.validatedCount,
    required this.recycledWeightGrams,
  });

  factory CitizenStats.fromTickets(List<RecyclingTicket> tickets) {
    final validated = tickets.where((t) => t.status == TicketStatus.validated);
    final pending = tickets.where((t) => t.canBeProcessed);
    return CitizenStats(
      pointsBalance: validated.fold(
        0,
        (sum, t) => sum + (t.validation?.finalPoints ?? 0),
      ),
      pendingPoints: pending.fold(
        0,
        (sum, t) => sum + t.wasteAnalysisResult.itemRecyclability.pointsEarned,
      ),
      pendingCount: pending.length,
      validatedCount: validated.length,
      recycledWeightGrams: validated.fold(
        0,
        (sum, t) => sum + (t.validation?.measuredWeightGrams ?? 0),
      ),
    );
  }
  // Points finaux des tickets validés.
  final double pointsBalance;
  // Points estimés par l'IA des tickets en attente et non expirés.
  final double pendingPoints;
  final int pendingCount;
  final int validatedCount;
  final double recycledWeightGrams;

  @override
  List<Object?> get props => [
    pointsBalance,
    pendingPoints,
    pendingCount,
    validatedCount,
    recycledWeightGrams,
  ];
}
