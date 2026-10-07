import "package:flutter_test/flutter_test.dart";
import "package:second_life/core/utils/formatters.dart";

void main() {
  test("kg convertit les grammes sans zéros inutiles", () {
    expect(Formatters.kg(600), "0.6");
    expect(Formatters.kg(2000), "2");
    expect(Formatters.kg(146250), "146.25");
  });

  test("shortCode garde les 6 premiers caractères en majuscules", () {
    expect(Formatters.shortCode("bffde5abcdefghij"), "#BFFDE5");
    expect(Formatters.shortCode("ab"), "#AB");
  });

  test("initials prend les deux premiers mots", () {
    expect(Formatters.initials("Ama Kodjovi Mensah"), "AK");
    expect(Formatters.initials("wilfried"), "W");
    expect(Formatters.initials("   "), "?");
  });

  test("percent arrondit", () {
    expect(Formatters.percent(0.456), "46 %");
  });
}
