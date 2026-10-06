import "package:equatable/equatable.dart";

import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";

// Activité de l'agent sur la journée en cours (heure locale).
class AgentDailyStats extends Equatable {
  const AgentDailyStats({
    required this.processedCount,
    required this.validatedPoints,
  });

  factory AgentDailyStats.fromTickets(
    List<RecyclingTicket> tickets, {
    required DateTime now,
  }) {
    final today = tickets.where((t) {
      final processedAt = t.validation?.processedAt;
      return processedAt != null && isSameDay(processedAt, now);
    }).toList();
    return AgentDailyStats(
      processedCount: today.length,
      validatedPoints: today
          .where((t) => t.status == TicketStatus.validated)
          .fold(0, (sum, t) => sum + (t.validation?.finalPoints ?? 0)),
    );
  }
  final int processedCount;
  final double validatedPoints;

  static bool isSameDay(DateTime a, DateTime b) {
    final localA = a.toLocal();
    final localB = b.toLocal();
    return localA.year == localB.year &&
        localA.month == localB.month &&
        localA.day == localB.day;
  }

  @override
  List<Object?> get props => [processedCount, validatedPoints];
}
