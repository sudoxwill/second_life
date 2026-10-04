import "../../domain/entities/redemption_voucher.dart";
import "../../domain/entities/reward_card.dart";
import "../../domain/entities/reward_category.dart";

/// État global du module de récompenses.
enum RewardsStatus { initial, loading, success, error }

class RewardsState {
  const RewardsState({
    this.status = RewardsStatus.initial,
    this.userPoints = 0,
    this.catalog = const [],
    this.selectedCategory = RewardCategory.all,
    this.searchQuery = "",
    this.vouchers = const [],
    this.errorMessage,
  });

  final RewardsStatus status;
  final int userPoints;
  final List<RewardCard> catalog;
  final RewardCategory selectedCategory;
  final String searchQuery;
  final List<RedemptionVoucher> vouchers;
  final String? errorMessage;

  /// Retourne les cartes cadeaux filtrées par catégorie et mot-clé.
  List<RewardCard> get filteredCatalog {
    return catalog.where((card) {
      final matchCategory =
          selectedCategory == RewardCategory.all ||
          card.category == selectedCategory;
      if (!matchCategory) return false;

      if (searchQuery.trim().isEmpty) return true;
      final query = searchQuery.toLowerCase().trim();
      return card.title.toLowerCase().contains(query) ||
          card.brand.toLowerCase().contains(query) ||
          card.shortDescription.toLowerCase().contains(query);
    }).toList();
  }

  /// Retourne uniquement les bons encore actifs et non expirés.
  List<RedemptionVoucher> get activeVouchers {
    return vouchers.where((v) => v.isValid).toList();
  }

  RewardsState copyWith({
    RewardsStatus? status,
    int? userPoints,
    List<RewardCard>? catalog,
    RewardCategory? selectedCategory,
    String? searchQuery,
    List<RedemptionVoucher>? vouchers,
    String? errorMessage,
  }) {
    return RewardsState(
      status: status ?? this.status,
      userPoints: userPoints ?? this.userPoints,
      catalog: catalog ?? this.catalog,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      vouchers: vouchers ?? this.vouchers,
      errorMessage: errorMessage,
    );
  }
}
