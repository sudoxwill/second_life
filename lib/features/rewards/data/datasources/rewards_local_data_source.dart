import "dart:convert";
import "dart:math";
import "package:shared_preferences/shared_preferences.dart";

import "../../domain/entities/redemption_voucher.dart";
import "../../domain/entities/reward_category.dart";
import "../models/redemption_voucher_model.dart";
import "../models/reward_card_model.dart";
import "../models/reward_tier_model.dart";

/// Source de données locale pour les récompenses et la gestion du solde de points.
class RewardsLocalDataSource {
  RewardsLocalDataSource({SharedPreferences? preferences})
    : _prefsFuture = preferences != null
          ? Future.value(preferences)
          : SharedPreferences.getInstance();

  final Future<SharedPreferences> _prefsFuture;

  static const String _pointsKey = "user_reward_points_balance";
  static const String _vouchersKey = "user_redeemed_vouchers_list";
  static const int _initialPoints = 2450;

  /// Récupère le solde de points de l'utilisateur (avec valeur par défaut initiale).
  Future<int> getUserPoints() async {
    final prefs = await _prefsFuture;
    return prefs.getInt(_pointsKey) ?? _initialPoints;
  }

  /// Met à jour le solde de points.
  Future<void> setUserPoints(int points) async {
    final prefs = await _prefsFuture;
    await prefs.setInt(_pointsKey, max(0, points));
  }

  /// Retourne le catalogue complet des récompenses partenaires.
  Future<List<RewardCardModel>> getCatalog() async {
    // Catalogue local prédéfini et réaliste pour l'Afrique de l'Ouest
    return _staticCatalog;
  }

  /// Récupère la liste des bons déjà échangés par l'utilisateur.
  Future<List<RedemptionVoucherModel>> getVouchers() async {
    final prefs = await _prefsFuture;
    final jsonString = prefs.getString(_vouchersKey);
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final list = jsonDecode(jsonString) as List<dynamic>;
      return list
          .map(
            (item) =>
                RedemptionVoucherModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Enregistre un nouveau bon d'achat débloqué.
  Future<void> saveVoucher(RedemptionVoucherModel voucher) async {
    final prefs = await _prefsFuture;
    final current = await getVouchers();
    current.insert(0, voucher);

    final raw = current.map((v) => v.toJson()).toList();
    await prefs.setString(_vouchersKey, jsonEncode(raw));
  }

  /// Met à jour le statut d'un bon existant (ex: utilisé).
  Future<void> updateVoucherStatus(
    String voucherId,
    VoucherStatus status,
  ) async {
    final prefs = await _prefsFuture;
    final current = await getVouchers();
    final index = current.indexWhere((v) => v.id == voucherId);
    if (index != -1) {
      final updated = current[index].copyWith(status: status);
      current[index] = RedemptionVoucherModel(
        id: updated.id,
        rewardCardId: updated.rewardCardId,
        rewardTitle: updated.rewardTitle,
        brand: updated.brand,
        tierName: updated.tierName,
        pointsSpent: updated.pointsSpent,
        monetaryValue: updated.monetaryValue,
        currency: updated.currency,
        voucherCode: updated.voucherCode,
        createdAt: updated.createdAt,
        expiresAt: updated.expiresAt,
        status: updated.status,
        recipient: updated.recipient,
        pinCode: updated.pinCode,
      );

      final raw = current.map((v) => v.toJson()).toList();
      await prefs.setString(_vouchersKey, jsonEncode(raw));
    }
  }

  static const List<RewardCardModel> _staticCatalog = [
    // ── 1. T-Money (Togocom) ──
    RewardCardModel(
      id: "tmoney_recharge",
      title: "Recharge T-Money",
      brand: "Togocom",
      category: RewardCategory.telecom,
      description:
          "Convertissez directement vos points de recyclage en argent liquide sur votre compte T-Money. Les fonds sont crédités sous quelques minutes sur le numéro renseigné.",
      shortDescription: "Transfert direct vers votre compte Mobile Money",
      isPopular: true,
      badgeText: "Populaire",
      accentColorHex: "#FFCC00",
      validityDays: 180,
      termsAndConditions: [
        "Valable pour tous les numéros Togocom actifs.",
        "Le compte T-Money destinataire doit être vérifié.",
        "Transfert irréversible une fois confirmé.",
      ],
      tiers: [
        RewardTierModel(
          id: "tm_500",
          name: "500 FCFA",
          pointsCost: 100,
          monetaryValue: 500,
        ),
        RewardTierModel(
          id: "tm_1000",
          name: "1 000 FCFA",
          pointsCost: 200,
          monetaryValue: 1000,
        ),
        RewardTierModel(
          id: "tm_2500",
          name: "2 500 FCFA",
          pointsCost: 500,
          monetaryValue: 2500,
        ),
        RewardTierModel(
          id: "tm_5000",
          name: "5 000 FCFA",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
      ],
    ),

    // ── 2. Moov Money ──
    RewardCardModel(
      id: "moov_money",
      title: "Transfert Moov Money",
      brand: "Moov Africa",
      category: RewardCategory.telecom,
      description:
          "Recevez vos gains de recyclage sur votre portefeuille Moov Money Flooz. Utilisable pour vos achats quotidiens, factures et retraits.",
      shortDescription: "Recharge instantanée sur portefeuille Moov Money",
      isPopular: true,
      badgeText: "Recommandé",
      accentColorHex: "#0066B3",
      validityDays: 180,
      termsAndConditions: [
        "Disponible pour les abonnés Moov Africa.",
        "Aucun frais de transfert prélevé sur vos gains.",
      ],
      tiers: [
        RewardTierModel(
          id: "moov_500",
          name: "500 FCFA",
          pointsCost: 100,
          monetaryValue: 500,
        ),
        RewardTierModel(
          id: "moov_1000",
          name: "1 000 FCFA",
          pointsCost: 200,
          monetaryValue: 1000,
        ),
        RewardTierModel(
          id: "moov_2500",
          name: "2 500 FCFA",
          pointsCost: 500,
          monetaryValue: 2500,
        ),
      ],
    ),

    // ── 3. Forfait Internet & Data ──
    RewardCardModel(
      id: "telecom_data_bundle",
      title: "Pass Internet & Data",
      brand: "Multi-Opérateurs",
      category: RewardCategory.telecom,
      description:
          "Convertissez vos points en volume data Internet haut débit (1 Go, 2.5 Go ou 5 Go) valable sur votre réseau mobile local.",
      shortDescription: "Recharge data mobile 1 Go à 5 Go",
      accentColorHex: "#008C45",
      validityDays: 30,
      termsAndConditions: [
        "Code de recharge envoyé par SMS.",
        "Volume valable 30 jours à compter de l'activation.",
      ],
      tiers: [
        RewardTierModel(
          id: "data_1gb",
          name: "1 Go Internet",
          pointsCost: 100,
          monetaryValue: 500,
        ),
        RewardTierModel(
          id: "data_25gb",
          name: "2.5 Go Internet",
          pointsCost: 200,
          monetaryValue: 1000,
        ),
        RewardTierModel(
          id: "data_5gb",
          name: "5 Go Internet",
          pointsCost: 400,
          monetaryValue: 2000,
        ),
      ],
    ),

    // ── 4. Bons d'achat Ramco Supermarché ──
    RewardCardModel(
      id: "ramco_voucher",
      title: "Bon d'achat Supermarché",
      brand: "Supermarché Ramco",
      category: RewardCategory.shopping,
      description:
          "Profitez de réductions et bons d'achat valables dans tous les supermarchés et boutiques partenaires de votre ville. Valable au rayon alimentaire et hygiène.",
      shortDescription: "Bons d'achat pour vos courses alimentaires",
      isPopular: true,
      badgeText: "Courses",
      accentColorHex: "#D32F2F",
      termsAndConditions: [
        "À présenter à la caisse du magasin sous forme de code ou QR.",
        "Cumulable avec d'autres promotions en cours.",
        "Non remboursable en espèces.",
      ],
      tiers: [
        RewardTierModel(
          id: "ramco_2000",
          name: "2 000 FCFA",
          pointsCost: 400,
          monetaryValue: 2000,
        ),
        RewardTierModel(
          id: "ramco_5000",
          name: "5 000 FCFA",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
        RewardTierModel(
          id: "ramco_10000",
          name: "10 000 FCFA",
          pointsCost: 2000,
          monetaryValue: 10000,
        ),
      ],
    ),

    // ── 5. Jumia Bon d'achat ──
    RewardCardModel(
      id: "jumia_gift_card",
      title: "Bon d'achat Jumia",
      brand: "Jumia",
      category: RewardCategory.shopping,
      description:
          "Code promo déductible sur vos commandes en ligne sur l'application et le site Jumia. Livraison à domicile ou en point relais.",
      shortDescription: "Code promotionnel sur tout le catalogue en ligne",
      accentColorHex: "#F68B1E",
      validityDays: 60,
      termsAndConditions: [
        "Valable sur l'ensemble du catalogue Jumia hors frais de port.",
        "Utilisation unique par commande.",
      ],
      tiers: [
        RewardTierModel(
          id: "jumia_1500",
          name: "1 500 FCFA",
          pointsCost: 300,
          monetaryValue: 1500,
        ),
        RewardTierModel(
          id: "jumia_3000",
          name: "3 000 FCFA",
          pointsCost: 600,
          monetaryValue: 3000,
        ),
        RewardTierModel(
          id: "jumia_6000",
          name: "6 000 FCFA",
          pointsCost: 1200,
          monetaryValue: 6000,
        ),
      ],
    ),

    // ── 6. TotalEnergies Carburant ──
    RewardCardModel(
      id: "total_energies_fuel",
      title: "Bon Carburant Station",
      brand: "TotalEnergies",
      category: RewardCategory.services,
      description:
          "Bon électronique à présenter en station-service TotalEnergies pour le plein d'essence, de gasoil ou l'achat d'une bouteille de gaz domestique.",
      shortDescription: "Plein de carburant ou recharge de gaz",
      accentColorHex: "#EE3124",
      termsAndConditions: [
        "Valable dans toutes les stations TotalEnergies du réseau national.",
        "Scannez le bon directement auprès du pompiste.",
      ],
      tiers: [
        RewardTierModel(
          id: "total_2000",
          name: "2 000 FCFA",
          pointsCost: 400,
          monetaryValue: 2000,
        ),
        RewardTierModel(
          id: "total_5000",
          name: "5 000 FCFA",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
      ],
    ),

    // ── 7. Canal+ Réabonnement ──
    RewardCardModel(
      id: "canal_plus_sub",
      title: "Réabonnement Canal+",
      brand: "Canal+ Afrique",
      category: RewardCategory.entertainment,
      description:
          "Financez tout ou partie de votre réabonnement aux formules Access, Évasion ou Tout Canal+. Le code est utilisable via l'espace client ou en agence.",
      shortDescription: "Réduction sur votre formule TV Canal+",
      accentColorHex: "#000000",
      validityDays: 60,
      termsAndConditions: [
        "Indiquer votre numéro de décodeur lors de la commande.",
        "Le montant sera déduit de votre prochaine mensualité.",
      ],
      tiers: [
        RewardTierModel(
          id: "canal_3000",
          name: "3 000 FCFA",
          pointsCost: 600,
          monetaryValue: 3000,
        ),
        RewardTierModel(
          id: "canal_5000",
          name: "5 000 FCFA",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
      ],
    ),

    // ── 8. Don Écologique / Reboisement ──
    RewardCardModel(
      id: "eco_tree_planting",
      title: "Plantation d'arbres & Écologie",
      brand: "Collectif Éco-Togo",
      category: RewardCategory.ecoImpact,
      description:
          "Faites don de vos points de recyclage à des projets communautaires locaux : plantation d'arbres, équipement d'écoles en poubelles de tri et soutien aux ramasseurs informels.",
      shortDescription: "Soutenez des actions concrètes pour la planète",
      badgeText: "Solidaire",
      accentColorHex: "#2E7D32",
      validityDays: 365,
      termsAndConditions: [
        "Un certificat d'impact environnemental vous sera adressé par email.",
        "100 % des fonds convertis sont alloués aux actions sur le terrain.",
      ],
      tiers: [
        RewardTierModel(
          id: "tree_500",
          name: "Planter 1 Arbre",
          pointsCost: 100,
          monetaryValue: 500,
        ),
        RewardTierModel(
          id: "tree_2500",
          name: "Bosquet (5 Arbres)",
          pointsCost: 500,
          monetaryValue: 2500,
        ),
      ],
    ),
  ];
}
