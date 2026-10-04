/// Règle métier de conversion des points SecondLife en monnaie locale (FCFA).
class PointsConversion {
  const PointsConversion._();

  /// Taux officiel : 1 point = 5 FCFA (soit 200 points = 1 000 FCFA).
  static const double fcfaPerPoint = 5.0;

  /// Convertit un nombre de points en valeur monétaire (FCFA).
  static double toFcfa(int points) {
    if (points <= 0) return 0.0;
    return points * fcfaPerPoint;
  }

  /// Convertit un montant monétaire (FCFA) en points nécessaires.
  static int toPoints(double fcfa) {
    if (fcfa <= 0) return 0;
    return (fcfa / fcfaPerPoint).ceil();
  }

  /// Formate un montant en FCFA lisible (ex: "12 500 FCFA").
  static String formatFcfa(double amount) {
    final rounded = amount.toInt();
    final parts = <String>[];
    var str = rounded.toString();

    while (str.length > 3) {
      parts.insert(0, str.substring(str.length - 3));
      str = str.substring(0, str.length - 3);
    }
    parts.insert(0, str);

    return "${parts.join(' ')} FCFA";
  }

  /// Formate les points (ex: "2 450 pts").
  static String formatPoints(int points) {
    final parts = <String>[];
    var str = points.toString();

    while (str.length > 3) {
      parts.insert(0, str.substring(str.length - 3));
      str = str.substring(0, str.length - 3);
    }
    parts.insert(0, str);

    return "${parts.join(' ')} pts";
  }
}
