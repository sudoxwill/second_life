import "dart:math";

import "../../domain/entities/redemption_voucher.dart";
import "../../domain/entities/reward_card.dart";
import "../../domain/entities/reward_tier.dart";
import "../../domain/repositories/rewards_repository.dart";
import "../datasources/rewards_local_data_source.dart";
import "../models/redemption_voucher_model.dart";

/// Implémentation du référentiel des récompenses SecondLife.
class RewardsRepositoryImpl implements RewardsRepository {
  const RewardsRepositoryImpl({required RewardsLocalDataSource localDataSource})
    : _dataSource = localDataSource;

  final RewardsLocalDataSource _dataSource;

  @override
  Future<int> getUserPoints() => _dataSource.getUserPoints();

  @override
  Future<List<RewardCard>> getCatalog() => _dataSource.getCatalog();

  @override
  Future<RewardCard?> getCardById(String id) async {
    final catalog = await _dataSource.getCatalog();
    for (final card in catalog) {
      if (card.id == id) return card;
    }
    return null;
  }

  @override
  Future<List<RedemptionVoucher>> getMyVouchers() => _dataSource.getVouchers();

  @override
  Future<RedemptionVoucher> redeemReward({
    required RewardCard card,
    required RewardTier tier,
    required String? recipient,
  }) async {
    final currentPoints = await _dataSource.getUserPoints();

    if (currentPoints < tier.pointsCost) {
      final missing = tier.pointsCost - currentPoints;
      throw Exception(
        "Solde insuffisant : il vous manque $missing points pour débloquer cette récompense.",
      );
    }

    // Déduction des points
    final newPoints = currentPoints - tier.pointsCost;
    await _dataSource.setUserPoints(newPoints);

    // Génération d'un code unique
    final code = _generateVoucherCode(card.brand);
    final now = DateTime.now();
    final expiresAt = now.add(Duration(days: card.validityDays));

    final voucher = RedemptionVoucherModel(
      id: "vch_${now.millisecondsSinceEpoch}_${Random().nextInt(9999)}",
      rewardCardId: card.id,
      rewardTitle: card.title,
      brand: card.brand,
      tierName: tier.name,
      pointsSpent: tier.pointsCost,
      monetaryValue: tier.monetaryValue,
      currency: tier.currency,
      voucherCode: code,
      createdAt: now,
      expiresAt: expiresAt,
      status: VoucherStatus.active,
      recipient: recipient,
    );

    await _dataSource.saveVoucher(voucher);
    return voucher;
  }

  @override
  Future<void> markVoucherAsUsed(String voucherId) {
    return _dataSource.updateVoucherStatus(voucherId, VoucherStatus.used);
  }

  /// Génère un code de bon lisible (ex: "SL-RAMCO-8419-X8A2").
  String _generateVoucherCode(String brand) {
    final cleanBrand = brand
        .replaceAll(RegExp("[^a-zA-Z0-9]"), "")
        .toUpperCase();
    final prefix = cleanBrand.length > 5
        ? cleanBrand.substring(0, 5)
        : cleanBrand;
    final randomDigits = (1000 + Random().nextInt(9000)).toString();
    final suffix = DateTime.now().millisecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase()
        .padLeft(4, "0")
        .substring(0, 4);

    return "SL-$prefix-$randomDigits-$suffix";
  }
}
