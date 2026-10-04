import "../entities/redemption_voucher.dart";
import "../entities/reward_card.dart";
import "../entities/reward_tier.dart";

/// Interface du référentiel des récompenses SecondLife.
abstract class RewardsRepository {
  /// Récupère le solde de points actuel de l'utilisateur.
  Future<int> getUserPoints();

  /// Récupère l'ensemble des cartes cadeaux et récompenses disponibles.
  Future<List<RewardCard>> getCatalog();

  /// Récupère une carte cadeau par son identifiant.
  Future<RewardCard?> getCardById(String id);

  /// Récupère la liste de tous les bons d'achat débloqués par l'utilisateur.
  Future<List<RedemptionVoucher>> getMyVouchers();

  /// Échange des points contre un palier d'une carte cadeau.
  ///
  /// Lève une exception si le solde de points est insuffisant.
  Future<RedemptionVoucher> redeemReward({
    required RewardCard card,
    required RewardTier tier,
    required String? recipient,
  });

  /// Marque un bon d'achat comme utilisé.
  Future<void> markVoucherAsUsed(String voucherId);
}
