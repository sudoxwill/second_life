import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/auth/presentation/widgets/password_strength.dart";

void main() {
  test("un mot de passe vide vaut 0", () {
    expect(PasswordStrength.score(""), 0);
  });

  test("8 lettres minuscules restent faibles", () {
    expect(PasswordStrength.score("abcdefgh"), 1);
  });

  test("chiffres, casse et symbole font un mot de passe robuste", () {
    expect(PasswordStrength.score("Abcdef1!"), 4);
  });

  test("le score est plafonné à 4", () {
    expect(PasswordStrength.score("Abcdefghijkl1!"), 4);
  });
}
