import "package:equatable/equatable.dart";

import "ticket_status.dart";
import "ticket_validation.dart";
import "waste_analysis_result.dart";

class RecyclingTicket extends Equatable {
  const RecyclingTicket({
    required this.code,
    required this.userId,
    required this.wasteAnalysisResult,
    required this.createdAt,
    required this.status,
    this.validation,
  });
  // Durée imposée dans firestore.rules
  static const validity = Duration(hours: 48);
  // Préfixe du QR code : permet d'écarter un QR code qui n'est pas un ticket.
  static const qrPrefix = "recycling-ticket:";
  static final _codePattern = RegExp(r"^[A-Za-z0-9]{20}$");

  final String code;
  final String userId;
  final WasteAnalysisResult wasteAnalysisResult;
  final DateTime createdAt;
  final TicketStatus status;
  final TicketValidation? validation;

  DateTime get expiresAt => createdAt.add(validity);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get canBeProcessed => status == TicketStatus.pending && !isExpired;

  String get qrData => "$qrPrefix$code";

  // Accepte le contenu du QR code ou le code saisi à la main.
  static String? codeFromInput(String input) {
    var value = input.trim();
    if (value.startsWith(qrPrefix)) value = value.substring(qrPrefix.length);
    return _codePattern.hasMatch(value) ? value : null;
  }

  @override
  List<Object?> get props => [
    code,
    userId,
    wasteAnalysisResult,
    createdAt,
    status,
    validation,
  ];
}
