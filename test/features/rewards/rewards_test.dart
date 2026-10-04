import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/rewards/rewards.dart";
import "package:second_life/features/rewards/data/datasources/rewards_local_data_source.dart";
import "package:second_life/features/rewards/data/repositories/rewards_repository_impl.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  group("PointsConversion", () {
    test("convertit correctement les points en FCFA (1 pt = 5 FCFA)", () {
      expect(PointsConversion.toFcfa(0), equals(0.0));
      expect(PointsConversion.toFcfa(100), equals(500.0));
      expect(PointsConversion.toFcfa(200), equals(1000.0));
      expect(PointsConversion.toFcfa(500), equals(2500.0));
      expect(PointsConversion.toFcfa(1000), equals(5000.0));
    });

    test("convertit correctement les montants FCFA en points nécessaires", () {
      expect(PointsConversion.toPoints(0), equals(0));
      expect(PointsConversion.toPoints(500), equals(100));
      expect(PointsConversion.toPoints(1000), equals(200));
      expect(PointsConversion.toPoints(2500), equals(500));
    });

    test("formate lisiblement les montants et les points avec séparateurs", () {
      expect(PointsConversion.formatFcfa(500), equals("500 FCFA"));
      expect(PointsConversion.formatFcfa(1000), equals("1 000 FCFA"));
      expect(PointsConversion.formatFcfa(12500), equals("12 500 FCFA"));

      expect(PointsConversion.formatPoints(100), equals("100 pts"));
      expect(PointsConversion.formatPoints(2450), equals("2 450 pts"));
    });
  });

  group("RewardCard & Tiers", () {
    test(
      "calcule correctement les paliers extrêmes (lowestTier & highestTier)",
      () {
        const card = RewardCard(
          id: "test_card",
          title: "Test Card",
          brand: "Test Brand",
          category: RewardCategory.food,
          description: "Test desc",
          shortDescription: "Short desc",
          termsAndConditions: [],
          tiers: [
            RewardTier(
              id: "t2",
              name: "1000 F",
              pointsCost: 200,
              monetaryValue: 1000,
            ),
            RewardTier(
              id: "t1",
              name: "500 F",
              pointsCost: 100,
              monetaryValue: 500,
            ),
            RewardTier(
              id: "t3",
              name: "2500 F",
              pointsCost: 500,
              monetaryValue: 2500,
            ),
          ],
        );

        expect(card.lowestTier.id, equals("t1"));
        expect(card.lowestTier.pointsCost, equals(100));
        expect(card.highestTier.id, equals("t3"));
        expect(card.highestTier.pointsCost, equals(500));
      },
    );
  });

  group("RewardsRepositoryImpl & DataSource", () {
    late RewardsLocalDataSource dataSource;
    late RewardsRepositoryImpl repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      dataSource = RewardsLocalDataSource();
      repository = RewardsRepositoryImpl(localDataSource: dataSource);
    });

    test("initialise le solde par défaut et charge le catalogue", () async {
      final points = await repository.getUserPoints();
      expect(points, equals(2450));

      final catalog = await repository.getCatalog();
      expect(catalog, isNotEmpty);
      expect(catalog.any((c) => c.category == RewardCategory.food), isTrue);
      expect(catalog.any((c) => c.category == RewardCategory.health), isTrue);
      expect(
        catalog.any((c) => c.category == RewardCategory.education),
        isTrue,
      );
      expect(
        catalog.any((c) => c.category == RewardCategory.hygieneWater),
        isTrue,
      );
    });

    test(
      "effectue un échange avec succès, déduit les points et génère un bon",
      () async {
        final catalog = await repository.getCatalog();
        final card = catalog.first;
        final tier = card.lowestTier;

        final initialPoints = await repository.getUserPoints();
        final voucher = await repository.redeemReward(
          card: card,
          tier: tier,
          recipient: "+22890000000",
        );

        expect(voucher.voucherCode, startsWith("SL-"));
        expect(voucher.status, equals(VoucherStatus.active));
        expect(voucher.pointsSpent, equals(tier.pointsCost));

        final newPoints = await repository.getUserPoints();
        expect(newPoints, equals(initialPoints - tier.pointsCost));

        final myVouchers = await repository.getMyVouchers();
        expect(myVouchers.length, equals(1));
        expect(myVouchers.first.id, equals(voucher.id));
      },
    );

    test("rejette l'échange si le solde de points est insuffisant", () async {
      // Définir un solde faible
      await dataSource.setUserPoints(50);

      final catalog = await repository.getCatalog();
      final card = catalog.first;
      final tier = card.lowestTier; // Coûte au moins 100 points

      expect(
        () => repository.redeemReward(card: card, tier: tier, recipient: null),
        throwsA(isA<Exception>()),
      );
    });

    test("permet de marquer un bon d'achat comme utilisé", () async {
      final catalog = await repository.getCatalog();
      final card = catalog.first;
      final tier = card.lowestTier;

      final voucher = await repository.redeemReward(
        card: card,
        tier: tier,
        recipient: null,
      );

      await repository.markVoucherAsUsed(voucher.id);

      final updatedVouchers = await repository.getMyVouchers();
      expect(updatedVouchers.first.status, equals(VoucherStatus.used));
      expect(updatedVouchers.first.isValid, isFalse);
    });
  });
}
