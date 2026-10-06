import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/ticket_status.dart";
import "ticket_validation_model.dart";
import "waste_analysis_result_model.dart";

class RecyclingTicketModel extends RecyclingTicket {
  const RecyclingTicketModel({
    required super.code,
    required super.userId,
    required super.wasteAnalysisResult,
    required super.createdAt,
    required super.status,
    super.validation,
  });

  factory RecyclingTicketModel.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    final validation = json["validation"] as Map<dynamic, dynamic>?;
    return RecyclingTicketModel(
      code: id,
      userId: json["userId"] as String,
      wasteAnalysisResult: WasteAnalysisResultModel.fromJson(
        Map<String, dynamic>.from(
          json["wasteAnalysis"] as Map<dynamic, dynamic>? ?? {},
        ),
      ),
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      status:
          TicketStatus.values.asNameMap()[json["status"]] ??
          TicketStatus.pending,
      validation: validation == null
          ? null
          : TicketValidationModel.fromJson(
              Map<String, dynamic>.from(validation),
            ),
    );
  }
}
