import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../domain/entities/index.dart";

part "history_providers.g.dart";

// ── Mock data ─────────────────────────────────────────────────

final _mockPending = <DepositEntity>[
  DepositEntity(
    id: "dep-001",
    material: MaterialType.plastic,
    estimatedWeight: 0.5,
    status: DepositStatus.waiting,
    centerName: "Centre Bè-Kpota",
    centerAddress: "Bè-Kpota, Lomé",
    centerLatitude: 6.1375,
    centerLongitude: 1.2123,
    dateTime: DateTime(2026, 9, 25, 14, 32),
    points: 20,
    qrData: "SL-DEP-001-2026",
  ),
  DepositEntity(
    id: "dep-002",
    material: MaterialType.paper,
    estimatedWeight: 1.2,
    status: DepositStatus.waiting,
    centerName: "Centre Tokoin",
    centerAddress: "Tokoin, Lomé",
    centerLatitude: 6.1514,
    centerLongitude: 1.2291,
    dateTime: DateTime(2026, 9, 23, 9, 15),
    points: 48,
    qrData: "SL-DEP-002-2026",
  ),
  DepositEntity(
    id: "dep-003",
    material: MaterialType.metal,
    estimatedWeight: 2.0,
    status: DepositStatus.waiting,
    centerName: "Centre Bè-Kpota",
    centerAddress: "Bè-Kpota, Lomé",
    centerLatitude: 6.1375,
    centerLongitude: 1.2123,
    dateTime: DateTime(2026, 9, 20, 16),
    points: 80,
    qrData: "SL-DEP-003-2026",
  ),
];

final _mockProcessed = <DepositEntity>[
  DepositEntity(
    id: "dep-004",
    material: MaterialType.glass,
    estimatedWeight: 0.5,
    realWeight: 0.6,
    status: DepositStatus.validated,
    centerName: "Centre Bè-Kpota",
    centerAddress: "Bè-Kpota, Lomé",
    centerLatitude: 6.1375,
    centerLongitude: 1.2123,
    dateTime: DateTime(2026, 9, 22, 16, 40),
    points: 24,
    agentName: "Kofi Mensah",
    qrData: "SL-DEP-004-2026",
    validationDateTime: DateTime(2026, 9, 22, 17, 5),
  ),
  DepositEntity(
    id: "dep-005",
    material: MaterialType.plastic,
    estimatedWeight: 1.0,
    realWeight: 1.0,
    status: DepositStatus.validated,
    centerName: "Centre Tokoin",
    centerAddress: "Tokoin, Lomé",
    centerLatitude: 6.1514,
    centerLongitude: 1.2291,
    dateTime: DateTime(2026, 9, 18, 11),
    points: 40,
    agentName: "Kofi Mensah",
    qrData: "SL-DEP-005-2026",
    validationDateTime: DateTime(2026, 9, 18, 11, 30),
  ),
  DepositEntity(
    id: "dep-006",
    material: MaterialType.ewaste,
    estimatedWeight: 0.8,
    status: DepositStatus.rejected,
    centerName: "Centre Bè-Kpota",
    centerAddress: "Bè-Kpota, Lomé",
    dateTime: DateTime(2026, 9, 15, 10),
    agentName: "Kofi Mensah",
    rejectionReason: "Matières résiduelles humides et souillées",
    qrData: "SL-DEP-006-2026",
    validationDateTime: DateTime(2026, 9, 15, 10, 20),
  ),
];

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

// ── Providers ─────────────────────────────────────────────────

@riverpod
class PendingDeposits extends _$PendingDeposits {
  @override
  Future<List<DepositEntity>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _mockPending;
  }
}

@riverpod
class ProcessedDeposits extends _$ProcessedDeposits {
  @override
  Future<List<DepositEntity>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _mockProcessed;
  }
}

@riverpod
class Vouchers extends _$Vouchers {
  @override
  Future<List<VoucherEntity>> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _mockVouchers;
  }
}

@riverpod
int pendingDepositsCount(Ref ref) =>
    ref.watch(pendingDepositsProvider).value?.length ?? 0;
