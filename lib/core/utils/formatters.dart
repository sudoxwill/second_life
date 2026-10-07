import "../../l10n/app_localizations.dart";

abstract final class Formatters {
  // 600 → "0.6", 2000 → "2", 146250 → "146.25"
  static String kg(double grams) => number(grams / 1000);

  static String number(double value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.contains(".")
        ? fixed.replaceFirst(RegExp(r"\.?0+$"), "")
        : fixed;
  }

  static String points(double points) => points.round().toString();

  static String time(DateTime date) {
    final local = date.toLocal();
    return "${_two(local.hour)}:${_two(local.minute)}";
  }

  // Code Firestore de 20 caractères → "#BFFDE5" (affichage seulement).
  static String shortCode(String code) =>
      "#${code.substring(0, code.length < 6 ? code.length : 6).toUpperCase()}";

  // Les usagers sont anonymes : on affiche un identifiant court.
  static String userLabel(AppLocalizations l10n, String userId) =>
      l10n.commonUserLabel(
        userId.substring(0, userId.length < 5 ? userId.length : 5),
      );

  static String initials(String name) {
    final words = name.trim().split(RegExp(r"\s+")).where((w) => w.isNotEmpty);
    if (words.isEmpty) return "?";
    return words.take(2).map((w) => w[0].toUpperCase()).join();
  }

  static String percent(double ratio) => "${(ratio * 100).round()} %";

  static String _two(int n) => n.toString().padLeft(2, "0");
}
