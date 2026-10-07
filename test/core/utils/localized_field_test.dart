import "package:flutter_test/flutter_test.dart";
import "package:second_life/core/utils/localized_field.dart";

void main() {
  const text = {"fr": "Bon alimentaire", "en": "Food voucher"};

  test("choisit la langue demandée", () {
    expect(localizedField(text, "en"), "Food voucher");
    expect(localizedField(text, "fr_FR"), "Bon alimentaire");
  });

  test("se replie sur le français", () {
    expect(localizedField(text, "es"), "Bon alimentaire");
  });

  test("accepte une simple chaîne", () {
    expect(localizedField("Marché", "en"), "Marché");
  });

  test("renvoie une chaîne vide sinon", () {
    expect(localizedField(null, "fr"), "");
    expect(localizedField(42, "fr"), "");
  });
}
