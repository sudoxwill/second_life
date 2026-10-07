import "dart:math";

import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/rewards/domain/entities/reward.dart";
import "package:second_life/features/rewards/domain/redemption_policy.dart";

Reward reward({int cost = 100, int? stock}) => Reward(
  id: "r1",
  name: "Bon",
  partnerName: "Partenaire",
  description: null,
  pointsCost: cost,
  category: RewardCategory.food,
  validityDays: 30,
  stock: stock,
);

void main() {
  group("RedemptionPolicy.check", () {
    test("autorise quand le solde couvre le coût", () {
      expect(
        RedemptionPolicy.check(balance: 100, reward: reward()),
        RedemptionCheck.allowed,
      );
    });

    test("refuse quand il manque des points", () {
      expect(
        RedemptionPolicy.check(balance: 99, reward: reward()),
        RedemptionCheck.insufficientPoints,
      );
    });

    test("le stock épuisé passe avant le solde", () {
      expect(
        RedemptionPolicy.check(balance: 0, reward: reward(stock: 0)),
        RedemptionCheck.outOfStock,
      );
    });

    test("un stock absent veut dire illimité", () {
      expect(reward().isOutOfStock, isFalse);
    });
  });

  group("RedemptionPolicy.progress", () {
    test("reste entre 0 et 1", () {
      expect(RedemptionPolicy.progress(balance: 50, cost: 200), 0.25);
      expect(RedemptionPolicy.progress(balance: 500, cost: 200), 1);
      expect(RedemptionPolicy.progress(balance: 0, cost: 200), 0);
    });

    test("un coût nul est considéré comme atteint", () {
      expect(RedemptionPolicy.progress(balance: 0, cost: 0), 1);
    });
  });

  group("RedemptionPolicy.generateCode", () {
    test("respecte le format SL-XXXXXX", () {
      final code = RedemptionPolicy.generateCode(Random(1));
      expect(code, matches(RegExp(r"^SL-[A-Z2-9]{6}$")));
    });

    test("n'utilise jamais de caractères ambigus", () {
      for (var seed = 0; seed < 200; seed++) {
        final code = RedemptionPolicy.generateCode(Random(seed));
        expect(code.substring(3), isNot(matches(RegExp("[01OI]"))));
      }
    });
  });
}
