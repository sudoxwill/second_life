import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";
import "../../domain/entities/voucher_entity.dart";

part "history_providers.g.dart";

// ── Dépôts (dérivés du provider Firebase) ────────────────────

@riverpod
AsyncValue<List<RecyclingTicket>> pendingDeposits(Ref ref) =>
    ref.watch(userTicketsProvider).whenData(
      (tickets) =>
          tickets.where((t) => t.status == TicketStatus.pending).toList(),
    );

@riverpod
AsyncValue<List<RecyclingTicket>> processedDeposits(Ref ref) =>
    ref.watch(userTicketsProvider).whenData(
      (tickets) =>
          tickets.where((t) => t.status != TicketStatus.pending).toList(),
    );

@riverpod
int pendingDepositsCount(Ref ref) =>
    ref.watch(pendingDepositsProvider).value?.length ?? 0;

// ── Vouchers (mock — feature future) ─────────────────────────

final _mockVouchers = <VoucherEntity>[
  VoucherEntity(
    id: "vou-001",
    name: "Bon pharmacie 2000 FCFA",
    partnerName: "Pharmacie Crésus",
    pointsSpent: 200,
    obtainedAt: DateTime(2026, 9, 10),
    expiresAt: DateTime(2026, 10, 10),
    voucherCode: "GIFT-3X7K",
    status: VoucherStatus.active,
  ),
  VoucherEntity(
    id: "vou-002",
    name: "Réduction 500 FCFA",
    partnerName: "Boutique partenaire Tokoin",
    pointsSpent: 50,
    obtainedAt: DateTime(2026, 8, 5),
    expiresAt: DateTime(2026, 9, 5),
    voucherCode: "GIFT-9KLM",
    status: VoucherStatus.expired,
  ),
  VoucherEntity(
    id: "vou-003",
    name: "Bon alimentaire 1000 FCFA",
    partnerName: "Marché Kégué",
    pointsSpent: 100,
    obtainedAt: DateTime(2026, 7, 20),
    expiresAt: DateTime(2026, 8, 20),
    voucherCode: "GIFT-2NQP",
    status: VoucherStatus.used,
    usedAt: DateTime(2026, 8),
  ),
];

@riverpod
class Vouchers extends _$Vouchers {
  @override
  Future<List<VoucherEntity>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _mockVouchers;
  }
}
