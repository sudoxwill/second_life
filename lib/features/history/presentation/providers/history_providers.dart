import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";

part "history_providers.g.dart";

// ── Dépôts (dérivés du provider Firebase) ────────────────────

@riverpod
AsyncValue<List<RecyclingTicket>> pendingDeposits(Ref ref) => ref
    .watch(userTicketsProvider)
    .whenData(
      (tickets) =>
          tickets.where((t) => t.status == TicketStatus.pending).toList(),
    );

@riverpod
AsyncValue<List<RecyclingTicket>> processedDeposits(Ref ref) => ref
    .watch(userTicketsProvider)
    .whenData(
      (tickets) =>
          tickets.where((t) => t.status != TicketStatus.pending).toList(),
    );

@riverpod
int pendingDepositsCount(Ref ref) =>
    ref.watch(pendingDepositsProvider).value?.length ?? 0;
