import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/ticket_validation/domain/ticket_validation_policy.dart";

void main() {
  group("isWeightAllowed", () {
    test("refuse zéro et les poids négatifs", () {
      expect(TicketValidationPolicy.isWeightAllowed(0), isFalse);
      expect(TicketValidationPolicy.isWeightAllowed(-10), isFalse);
    });

    test("accepte jusqu'à 50 kg inclus", () {
      expect(TicketValidationPolicy.isWeightAllowed(50000), isTrue);
      expect(TicketValidationPolicy.isWeightAllowed(50001), isFalse);
    });
  });

  group("isWeightDeviated", () {
    test("tolère jusqu'à 50 % d'écart", () {
      expect(TicketValidationPolicy.isWeightDeviated(150, 100), isFalse);
      expect(TicketValidationPolicy.isWeightDeviated(50, 100), isFalse);
    });

    test("signale un écart plus grand", () {
      expect(TicketValidationPolicy.isWeightDeviated(151, 100), isTrue);
      expect(TicketValidationPolicy.isWeightDeviated(49, 100), isTrue);
    });

    test("sans estimation, tout poids est considéré comme un écart", () {
      expect(TicketValidationPolicy.isWeightDeviated(100, 0), isTrue);
    });
  });

  test("prorate ajuste les points au poids réel", () {
    expect(TicketValidationPolicy.prorate(40, 200, 100), 80);
    expect(TicketValidationPolicy.prorate(40, 100, 0), 40);
  });

  test("normalizeComment ignore les commentaires vides", () {
    expect(TicketValidationPolicy.normalizeComment("   "), isNull);
    expect(TicketValidationPolicy.normalizeComment(null), isNull);
    expect(TicketValidationPolicy.normalizeComment("  sale "), "sale");
  });
}
