import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/ticket_status.dart";
import "../../domain/entities/ticket_validation.dart";
import "relay_agent_model.dart";

class TicketValidationModel extends TicketValidation {
  const TicketValidationModel({
    required super.processedAt,
    required super.agent,
    super.measuredWeightGrams,
    super.finalPoints,
    super.finalCo2SavedGrams,
    super.rejectionReason,
    super.comment,
  });

  factory TicketValidationModel.fromJson(Map<String, dynamic> json) {
    final rejectionReason = json["rejectionReason"];
    return TicketValidationModel(
      processedAt: (json["processedAt"] as Timestamp).toDate(),
      agent: RelayAgentModel.fromJson(
        Map<String, dynamic>.from(json["agent"] as Map<dynamic, dynamic>),
      ),
      measuredWeightGrams: (json["measuredWeightGrams"] as num?)?.toDouble(),
      finalPoints: (json["finalPoints"] as num?)?.toDouble(),
      finalCo2SavedGrams: (json["finalCo2SavedGrams"] as num?)?.toDouble(),
      rejectionReason: rejectionReason == null
          ? null
          : RejectionReason.values.asNameMap()[rejectionReason] ??
                RejectionReason.other,
      comment: json["comment"] as String?,
    );
  }
}
