import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/configs/logger.dart";
import "../../data/datasources/rewards_local_data_source.dart";
import "../../data/repositories/rewards_repository_impl.dart";
import "../../domain/entities/redemption_voucher.dart";
import "../../domain/entities/reward_card.dart";
import "../../domain/entities/reward_category.dart";
import "../../domain/entities/reward_tier.dart";
import "../../domain/repositories/rewards_repository.dart";
import "rewards_state.dart";

/// Injecte la source de données locale des récompenses.
final rewardsLocalDataSourceProvider = Provider<RewardsLocalDataSource>((ref) {
  return RewardsLocalDataSource();
});

/// Injecte le référentiel des récompenses.
final rewardsRepositoryProvider = Provider<RewardsRepository>((ref) {
  final dataSource = ref.watch(rewardsLocalDataSourceProvider);
  return RewardsRepositoryImpl(localDataSource: dataSource);
});

/// Notifier gérant le catalogue, les filtres, le solde et les échanges de cartes cadeaux.
class RewardsNotifier extends Notifier<RewardsState> {
  @override
  RewardsState build() {
    // Chargement asynchrone dès l'initialisation du provider
    Future.microtask(loadRewardsData);
    return const RewardsState(status: RewardsStatus.loading);
  }

  RewardsRepository get _repository => ref.read(rewardsRepositoryProvider);

  /// Charge le catalogue de récompenses, le solde et l'historique des bons.
  Future<void> loadRewardsData() async {
    try {
      state = state.copyWith(status: RewardsStatus.loading);

      final points = await _repository.getUserPoints();
      final catalog = await _repository.getCatalog();
      final vouchers = await _repository.getMyVouchers();

      state = state.copyWith(
        status: RewardsStatus.success,
        userPoints: points,
        catalog: catalog,
        vouchers: vouchers,
      );
      Log.i("Catalogue récompenses chargé ($points pts)", tag: "Rewards");
    } catch (e, st) {
      Log.e(
        "Erreur chargement récompenses",
        error: e,
        stackTrace: st,
        tag: "Rewards",
      );
      state = state.copyWith(
        status: RewardsStatus.error,
        errorMessage: "Impossible de charger le catalogue des récompenses.",
      );
    }
  }

  /// Filtre les récompenses par catégorie.
  void selectCategory(RewardCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Filtre les cartes selon la recherche de l'utilisateur.
  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Effectue la conversion et l'échange des points contre une récompense.
  Future<RedemptionVoucher> redeemCard({
    required RewardCard card,
    required RewardTier tier,
    required String? recipient,
  }) async {
    try {
      final voucher = await _repository.redeemReward(
        card: card,
        tier: tier,
        recipient: recipient,
      );

      // Met à jour l'état local immédiatement
      final updatedPoints = state.userPoints - tier.pointsCost;
      final updatedVouchers = [voucher, ...state.vouchers];

      state = state.copyWith(
        userPoints: updatedPoints,
        vouchers: updatedVouchers,
      );

      Log.s(
        "Récompense échangée avec succès : ${card.title} - Code: ${voucher.voucherCode}",
        tag: "Rewards",
      );
      return voucher;
    } catch (e, st) {
      Log.e(
        "Échec de l'échange de points",
        error: e,
        stackTrace: st,
        tag: "Rewards",
      );
      rethrow;
    }
  }

  /// Marque un bon d'achat comme utilisé.
  Future<void> markVoucherUsed(String voucherId) async {
    try {
      await _repository.markVoucherAsUsed(voucherId);
      final updated = state.vouchers.map((v) {
        if (v.id == voucherId) {
          return v.copyWith(status: VoucherStatus.used);
        }
        return v;
      }).toList();

      state = state.copyWith(vouchers: updated);
    } catch (e, st) {
      Log.e("Erreur mise à jour bon", error: e, stackTrace: st, tag: "Rewards");
    }
  }
}

/// Provider global pour l'UI du module récompenses.
final rewardsNotifierProvider = NotifierProvider<RewardsNotifier, RewardsState>(
  RewardsNotifier.new,
);
