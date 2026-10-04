import "dart:convert";
import "dart:math";
import "package:shared_preferences/shared_preferences.dart";

import "../../domain/entities/redemption_voucher.dart";
import "../../domain/entities/reward_category.dart";
import "../models/redemption_voucher_model.dart";
import "../models/reward_card_model.dart";
import "../models/reward_tier_model.dart";

/// Source de données locale pour les récompenses et la gestion du solde de points.
///
/// Dans SecondLife, les points sont non monétisables en espèces et ne financent
/// que les besoins vitaux stricts : alimentation, santé, scolarisation et eau/hygiène.
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

  /// Retourne le catalogue complet des récompenses de première nécessité.
  Future<List<RewardCardModel>> getCatalog() async {
    return _staticCatalog;
  }

  /// Récupère la liste des bons de subsistance déjà débloqués par l'utilisateur.
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

  /// Enregistre un nouveau bon de subsistance débloqué.
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
    // ══════════════════════════════════════════════════════════
    // 1. ALIMENTATION & RAVITAILLEMENT (PRODUITS DE BASE)
    // ══════════════════════════════════════════════════════════
    RewardCardModel(
      id: "panier_alimentaire_base",
      title: "Panier Alimentaire de Première Nécessité",
      brand: "Supermarchés & Épiceries Partenaires",
      category: RewardCategory.food,
      description:
          "Bon de ravitaillement réservé exclusivement aux denrées alimentaires de base : riz, maïs, huile végétale, farine, sucre et haricots secs. Utilisable en caisse dans les supermarchés et épiceries partenaires agréées.",
      shortDescription:
          "Ravitaillement en denrées de base (riz, huile, farine)",
      isPopular: true,
      badgeText: "Vital",
      accentColorHex: "#007A3D",
      validityDays: 60,
      termsAndConditions: [
        "Strictement réservé aux produits alimentaires de première nécessité.",
        "Non échangeable contre de l'alcool, du tabac ou des espèces.",
        "À présenter à la caisse d'un supermarché partenaire sous forme de code ou QR.",
      ],
      tiers: [
        RewardTierModel(
          id: "panier_1500",
          name: "Ravitaillement 1 500 FCFA",
          pointsCost: 300,
          monetaryValue: 1500,
        ),
        RewardTierModel(
          id: "panier_3000",
          name: "Ravitaillement 3 000 FCFA",
          pointsCost: 600,
          monetaryValue: 3000,
        ),
        RewardTierModel(
          id: "panier_5000",
          name: "Sac de riz & huile (5 000 FCFA)",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
        RewardTierModel(
          id: "panier_10000",
          name: "Grand Panier Familial (10 000 FCFA)",
          pointsCost: 2000,
          monetaryValue: 10000,
        ),
      ],
    ),

    RewardCardModel(
      id: "nutrition_infantile",
      title: "Pack Nutrition Enfant & Bébé",
      brand: "Réseau Petite Enfance Partenaire",
      category: RewardCategory.food,
      description:
          "Prise en charge de farines infantiles enrichies, lait de croissance et compléments nutritionnels essentiels pour assurer la bonne croissance des jeunes enfants.",
      shortDescription: "Farines enrichies et lait pour bébés et enfants",
      isPopular: true,
      badgeText: "Nutrition",
      accentColorHex: "#E65100",
      validityDays: 90,
      termsAndConditions: [
        "Délivré en pharmacie ou supérette partenaire.",
        "Réservé à l'alimentation des nourrissons et enfants en bas âge.",
      ],
      tiers: [
        RewardTierModel(
          id: "bebe_2000",
          name: "Farines infantiles (2 000 FCFA)",
          pointsCost: 400,
          monetaryValue: 2000,
        ),
        RewardTierModel(
          id: "bebe_4000",
          name: "Pack Lait & Céréales (4 000 FCFA)",
          pointsCost: 800,
          monetaryValue: 4000,
        ),
      ],
    ),

    // ══════════════════════════════════════════════════════════
    // 2. SANTÉ & SOINS MÉDICAUX
    // ══════════════════════════════════════════════════════════
    RewardCardModel(
      id: "bon_pharmacie_essentiel",
      title: "Bon Pharmacie — Médicaments Essentiels",
      brand: "Pharmacies Partenaires Agréées",
      category: RewardCategory.health,
      description:
          "Couvre l'achat de médicaments essentiels sur ordonnance : traitements antipaludiques, antibiotiques de base, paracétamol, solutés de réhydratation et antiseptiques.",
      shortDescription: "Médicaments vitaux et premiers soins en pharmacie",
      isPopular: true,
      badgeText: "Santé",
      accentColorHex: "#D32F2F",
      validityDays: 90,
      termsAndConditions: [
        "Valable dans toutes les pharmacies affiliées au réseau SecondLife.",
        "Présentation d'une ordonnance médicale requise pour les traitements régulés.",
        "Aucun rendu de monnaie en espèces.",
      ],
      tiers: [
        RewardTierModel(
          id: "pharma_1000",
          name: "Soins & Fièvre (1 000 FCFA)",
          pointsCost: 200,
          monetaryValue: 1000,
        ),
        RewardTierModel(
          id: "pharma_2500",
          name: "Traitement Paludisme / Soins (2 500 FCFA)",
          pointsCost: 500,
          monetaryValue: 2500,
        ),
        RewardTierModel(
          id: "pharma_5000",
          name: "Ordonnance Complète (5 000 FCFA)",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
      ],
    ),

    RewardCardModel(
      id: "consultation_dispensaire",
      title: "Consultation Médicale Dispensaire",
      brand: "Centres de Santé & Dispensaires Partenaires",
      category: RewardCategory.health,
      description:
          "Prise en charge intégrale d'une consultation médicale générale ou pédiatrique dans un centre médico-social ou dispensaire de quartier partenaire.",
      shortDescription: "Prise en charge d'une consultation médicale",
      accentColorHex: "#C2185B",
      validityDays: 120,
      termsAndConditions: [
        "Valable pour un patient dans les dispensaires communautaires affiliés.",
        "Comprend l'examen clinique de base par un professionnel de santé.",
      ],
      tiers: [
        RewardTierModel(
          id: "consult_1500",
          name: "Consultation Générale (1 500 FCFA)",
          pointsCost: 300,
          monetaryValue: 1500,
        ),
        RewardTierModel(
          id: "consult_3000",
          name: "Consultation + Bilan Simple (3 000 FCFA)",
          pointsCost: 600,
          monetaryValue: 3000,
        ),
      ],
    ),

    // ══════════════════════════════════════════════════════════
    // 3. SCOLARISATION & ÉDUCATION
    // ══════════════════════════════════════════════════════════
    RewardCardModel(
      id: "fournitures_scolaires",
      title: "Kit Fournitures Scolaires Élève",
      brand: "Papeteries & Librairies Partenaires",
      category: RewardCategory.education,
      description:
          "Pack complet de rentrée scolaire comprenant cahiers d'exercices, stylos, règles, crayons, taille-crayon, boîte de géométrie et trousse pour un élève du primaire ou secondaire.",
      shortDescription: "Cahiers, stylos et fournitures indispensables",
      isPopular: true,
      badgeText: "Éducation",
      accentColorHex: "#1565C0",
      validityDays: 120,
      termsAndConditions: [
        "À retirer auprès des librairies scolaires agréées.",
        "Kit remis sous forme de paquet scellé conforme aux programmes scolaires.",
      ],
      tiers: [
        RewardTierModel(
          id: "fourniture_1500",
          name: "Kit Essentiel Primaire (1 500 FCFA)",
          pointsCost: 300,
          monetaryValue: 1500,
        ),
        RewardTierModel(
          id: "fourniture_3000",
          name: "Kit Complet + Sac d'école (3 000 FCFA)",
          pointsCost: 600,
          monetaryValue: 3000,
        ),
        RewardTierModel(
          id: "fourniture_6000",
          name: "Pack Fratrie (6 000 FCFA)",
          pointsCost: 1200,
          monetaryValue: 6000,
        ),
      ],
    ),

    RewardCardModel(
      id: "frais_scolarite_ecolage",
      title: "Participation aux Frais de Scolarité",
      brand: "Établissements Scolaires Partenaires",
      category: RewardCategory.education,
      description:
          "Bon de scolarité remis directement à l'administration de l'école primaire ou du collège partenaire afin de régler une partie ou la totalité de l'écolage trimestriel d'un enfant.",
      shortDescription: "Règlement direct de l'écolage auprès de l'école",
      isPopular: true,
      badgeText: "Prioritaire",
      accentColorHex: "#0D47A1",
      validityDays: 180,
      termsAndConditions: [
        "Virement direct vers le compte de l'établissement scolaire partenaire.",
        "Indiquer le nom de l'élève et sa classe lors de la confirmation.",
        "Un reçu de scolarité officiel est délivré par l'école.",
      ],
      tiers: [
        RewardTierModel(
          id: "ecole_2500",
          name: "Aide Écolage Trimestre (2 500 FCFA)",
          pointsCost: 500,
          monetaryValue: 2500,
        ),
        RewardTierModel(
          id: "ecole_5000",
          name: "Trimestre Scolaire (5 000 FCFA)",
          pointsCost: 1000,
          monetaryValue: 5000,
        ),
        RewardTierModel(
          id: "ecole_10000",
          name: "Semestre d'Écolage (10 000 FCFA)",
          pointsCost: 2000,
          monetaryValue: 10000,
        ),
      ],
    ),

    RewardCardModel(
      id: "cantine_scolaire",
      title: "Repas Cantine Scolaire Mensuel",
      brand: "Cantines Scolaires Communautaires",
      category: RewardCategory.education,
      description:
          "Assurez à un enfant scolarisé un repas chaud, nutritif et équilibré chaque midi à la cantine de son école pendant tout un mois de cours.",
      shortDescription: "Repas chauds le midi pour un écolier pendant 1 mois",
      accentColorHex: "#2E7D32",
      validityDays: 90,
      termsAndConditions: [
        "Directement crédité auprès du gestionnaire de cantine de l'école.",
        "Garantit la présence et la bonne concentration de l'élève en classe.",
      ],
      tiers: [
        RewardTierModel(
          id: "cantine_2000",
          name: "2 Semaines de Repas (2 000 FCFA)",
          pointsCost: 400,
          monetaryValue: 2000,
        ),
        RewardTierModel(
          id: "cantine_4000",
          name: "1 Mois Complet Cantine (4 000 FCFA)",
          pointsCost: 800,
          monetaryValue: 4000,
        ),
      ],
    ),

    // ══════════════════════════════════════════════════════════
    // 4. EAU POTABLE & HYGIÈNE VITALE
    // ══════════════════════════════════════════════════════════
    RewardCardModel(
      id: "eau_potable_borne",
      title: "Recharge Eau Potable Filtrée",
      brand: "Kiosques à Eau Potable Partenaires",
      category: RewardCategory.hygieneWater,
      description:
          "Crédit de recharge pour bidons d'eau potable saine et traitée dans les bornes fontaines et kiosques à eau partenaires, pour prévenir les maladies d'origine hydrique.",
      shortDescription: "Eau saine et traitée pour le foyer en borne fontaine",
      badgeText: "Vital",
      accentColorHex: "#0288D1",
      validityDays: 60,
      termsAndConditions: [
        "Valable aux bornes fontaines du réseau partenaire.",
        "Permet de remplir plusieurs bidons de 20 à 25 litres.",
      ],
      tiers: [
        RewardTierModel(
          id: "eau_500",
          name: "10 Bidons de 25L (500 FCFA)",
          pointsCost: 100,
          monetaryValue: 500,
        ),
        RewardTierModel(
          id: "eau_1000",
          name: "Pack Eau Mois Foyer (1 000 FCFA)",
          pointsCost: 200,
          monetaryValue: 1000,
        ),
      ],
    ),

    RewardCardModel(
      id: "kit_hygiene_foyer",
      title: "Kit Hygiène & Savon Familial",
      brand: "Partenaires Santé & Hygiène",
      category: RewardCategory.hygieneWater,
      description:
          "Pack d'hygiène essentiel pour le foyer : savons corporels locaux, produit de lavage pour vêtements, eau de Javel pour la désinfection de l'eau et matériel de lavage des mains.",
      shortDescription: "Savons, désinfection de l'eau et hygiène du foyer",
      accentColorHex: "#00838F",
      validityDays: 90,
      termsAndConditions: [
        "Retrait dans les points relais communautaires partenaires.",
        "Produits conformes aux normes sanitaires d'hygiène publique.",
      ],
      tiers: [
        RewardTierModel(
          id: "hygiene_1000",
          name: "Kit Savon & Hygiène (1 000 FCFA)",
          pointsCost: 200,
          monetaryValue: 1000,
        ),
        RewardTierModel(
          id: "hygiene_2500",
          name: "Pack Famille Complet (2 500 FCFA)",
          pointsCost: 500,
          monetaryValue: 2500,
        ),
      ],
    ),
  ];
}
