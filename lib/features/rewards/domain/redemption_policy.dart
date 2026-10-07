import "dart:math";

import "entities/reward.dart";

enum RedemptionCheck { allowed, insufficientPoints, outOfStock }

// Règles d'échange des points contre une récompense.
abstract final class RedemptionPolicy {
  static const codePrefix = "SL-";
  static const codeLength = 6;
  // Sans 0/O ni 1/I, qu'on confond facilement en caisse.
  static const codeAlphabet = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

  static RedemptionCheck check({required int balance, required Reward reward}) {
    if (reward.isOutOfStock) return RedemptionCheck.outOfStock;
    if (balance < reward.pointsCost) return RedemptionCheck.insufficientPoints;
    return RedemptionCheck.allowed;
  }

  // Part du coût déjà couverte par le solde, entre 0 et 1.
  static double progress({required int balance, required int cost}) =>
      cost <= 0 ? 1 : (balance / cost).clamp(0.0, 1.0);

  // "SL-7KQ2MX"
  static String generateCode([Random? random]) {
    final rng = random ?? Random.secure();
    final suffix = List.generate(
      codeLength,
      (_) => codeAlphabet[rng.nextInt(codeAlphabet.length)],
    ).join();
    return "$codePrefix$suffix";
  }
}
