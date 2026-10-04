/// Statut du bon d'achat / voucher.
enum VoucherStatus {
  active,
  used,
  expired;

  String get label {
    switch (this) {
      case VoucherStatus.active:
        return "Actif";
      case VoucherStatus.used:
        return "Utilisé";
      case VoucherStatus.expired:
        return "Expiré";
    }
  }
}

/// Bon d'achat ou récompense déjà débloqué par l'utilisateur.
class RedemptionVoucher {
  const RedemptionVoucher({
    required this.id,
    required this.rewardCardId,
    required this.rewardTitle,
    required this.brand,
    required this.tierName,
    required this.pointsSpent,
    required this.monetaryValue,
    required this.currency,
    required this.voucherCode,
    required this.createdAt,
    required this.expiresAt,
    required this.status,
    this.recipient,
    this.pinCode,
  });

  /// Identifiant unique de la transaction de déblocage.
  final String id;

  /// ID de la carte cadeau source.
  final String rewardCardId;

  /// Nom de la récompense (ex: "Recharge T-Money").
  final String rewardTitle;

  /// Marque (ex: "Togocom").
  final String brand;

  /// Libellé du palier (ex: "1 000 FCFA").
  final String tierName;

  /// Quantité de points dépensés.
  final int pointsSpent;

  /// Valeur monétaire.
  final double monetaryValue;

  /// Devise.
  final String currency;

  /// Code unique du coupon à présenter ou à saisir (ex: "SL-TMON-4912-98AF").
  final String voucherCode;

  /// Date de création / déblocage.
  final DateTime createdAt;

  /// Date d'expiration.
  final DateTime expiresAt;

  /// Statut du bon.
  final VoucherStatus status;

  /// Destinataire (numéro de téléphone ou email) si applicable.
  final String? recipient;

  /// Code PIN secret optionnel si le marchand le requiert.
  final String? pinCode;

  /// Indique si le bon est encore utilisable.
  bool get isValid =>
      status == VoucherStatus.active && DateTime.now().isBefore(expiresAt);

  RedemptionVoucher copyWith({VoucherStatus? status}) {
    return RedemptionVoucher(
      id: id,
      rewardCardId: rewardCardId,
      rewardTitle: rewardTitle,
      brand: brand,
      tierName: tierName,
      pointsSpent: pointsSpent,
      monetaryValue: monetaryValue,
      currency: currency,
      voucherCode: voucherCode,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: status ?? this.status,
      recipient: recipient,
      pinCode: pinCode,
    );
  }
}
