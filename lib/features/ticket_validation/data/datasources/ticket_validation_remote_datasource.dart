import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../../core/configs/logger.dart";
import "../../../../core/constants/firestore_paths.dart";
import "../../../../core/errors/exception.dart";
import "../../../../core/errors/exceptions_mapper.dart";
import "../../../../shared/data/sources/notifications_remote_source.dart";
import "../../../waste_analysis/data/models/recycling_ticket_model.dart";
import "../../../waste_analysis/data/models/relay_agent_model.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../domain/ticket_validation_policy.dart";
import "relay_point_stock_remote_datasource.dart";

abstract class TicketValidationRemoteDatasource {
  Future<RelayAgentModel> getCurrentRelayAgent();
  Future<RecyclingTicketModel> getTicketByCode(String code);
  Future<RecyclingTicketModel> validateTicket({
    required String code,
    required double measuredWeightGrams,
    String? comment,
  });
  Future<RecyclingTicketModel> rejectTicket({
    required String code,
    required RejectionReason reason,
    String? comment,
  });
  Future<List<RecyclingTicketModel>> getAgentHistory();
  Future<List<RecyclingTicketModel>> getPendingTickets();
}

class TicketValidationRemoteDatasourceImpl
    implements TicketValidationRemoteDatasource {
  new(
    this.firestore,
    this.firebaseAuth,
    this.relayPointStock,
    this.notifications,
  );
  static const ticketsPath = "recycling_tickets";
  static const agentsPath = "relay_agents";
  static const writeTimeout = Duration(seconds: 15);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final RelayPointStockRemoteDatasource relayPointStock;
  final NotificationsRemoteSource notifications;

  @override
  Future<RelayAgentModel> getCurrentRelayAgent() {
    return _guard(() => _getActiveAgent(_currentUserId()));
  }

  @override
  Future<RecyclingTicketModel> getTicketByCode(String code) {
    return _guard(() async {
      _currentUserId();
      final snapshot = await firestore.collection(ticketsPath).doc(code).get();
      if (!snapshot.exists) throw TicketNotFoundException();
      return RecyclingTicketModel.fromFirestore(snapshot.id, snapshot.data()!);
    });
  }

  @override
  Future<RecyclingTicketModel> validateTicket({
    required String code,
    required double measuredWeightGrams,
    String? comment,
  }) {
    return _processTicket(code, (ticket, agent) {
      final analysis = ticket.wasteAnalysisResult;
      final estimatedWeight = analysis.itemWeight.estimatedWeight;
      return {
        "status": TicketStatus.validated.name,
        "validation": {
          "processedAt": FieldValue.serverTimestamp(),
          "agent": agent.toJson(),
          "measuredWeightGrams": measuredWeightGrams,
          "finalPoints": TicketValidationPolicy.prorate(
            analysis.itemRecyclability.pointsEarned,
            measuredWeightGrams,
            estimatedWeight,
          ),
          "finalCo2SavedGrams": TicketValidationPolicy.prorate(
            analysis.itemRecyclability.co2SavedGrams,
            measuredWeightGrams,
            estimatedWeight,
          ),
          "comment": ?comment,
        },
      };
    });
  }

  @override
  Future<RecyclingTicketModel> rejectTicket({
    required String code,
    required RejectionReason reason,
    String? comment,
  }) {
    return _processTicket(code, (ticket, agent) {
      return {
        "status": TicketStatus.rejected.name,
        "validation": {
          "processedAt": FieldValue.serverTimestamp(),
          "agent": agent.toJson(),
          "rejectionReason": reason.name,
          "comment": ?comment,
        },
      };
    });
  }

  @override
  Future<List<RecyclingTicketModel>> getAgentHistory() {
    return _guard(() async {
      final agentId = _currentUserId();
      final querySnapshot = await firestore
          .collection(ticketsPath)
          .where("validation.agent.id", isEqualTo: agentId)
          .orderBy("validation.processedAt", descending: true)
          .get(
            const GetOptions(
              serverTimestampBehavior: ServerTimestampBehavior.estimate,
            ),
          );

      return querySnapshot.docs
          .map((doc) => RecyclingTicketModel.fromFirestore(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<List<RecyclingTicketModel>> getPendingTickets() {
    return _guard(() async {
      _currentUserId();
      // Filtre seul et tri en mémoire : pas besoin d'index composite.
      final querySnapshot = await firestore
          .collection(ticketsPath)
          .where("status", isEqualTo: TicketStatus.pending.name)
          .get(
            const GetOptions(
              serverTimestampBehavior: ServerTimestampBehavior.estimate,
            ),
          );

      return querySnapshot.docs
          .map((doc) => RecyclingTicketModel.fromFirestore(doc.id, doc.data()))
          .where((ticket) => !ticket.isExpired)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  String _currentUserId() {
    final user = firebaseAuth.currentUser;
    if (user == null) throw UnauthenticatedException();
    return user.uid;
  }

  Future<RelayAgentModel> _getActiveAgent(String uid) async {
    // Délai max : sans lui, un jeton invalide fait attendre sans fin.
    final snapshot = await firestore
        .collection(agentsPath)
        .doc(uid)
        .get()
        .timeout(writeTimeout);
    final data = snapshot.data();
    if (!snapshot.exists || data == null || data["isActive"] != true) {
      throw NotRelayAgentException();
    }
    return RelayAgentModel.fromFirestore(snapshot.id, data);
  }

  // Transaction : si deux agents traitent le même ticket en même temps,
  // le second relit le ticket déjà traité et reçoit une erreur claire.
  Future<RecyclingTicketModel> _processTicket(
    String code,
    Map<String, dynamic> Function(
      RecyclingTicketModel ticket,
      RelayAgentModel agent,
    )
    buildUpdate,
  ) {
    return _guard(() async {
      final agent = await _getActiveAgent(_currentUserId());
      final ticketRef = firestore.collection(ticketsPath).doc(code);

      await firestore
          .runTransaction<void>((transaction) async {
            final snapshot = await transaction.get(ticketRef);
            if (!snapshot.exists) throw TicketNotFoundException();

            final ticket = RecyclingTicketModel.fromFirestore(
              snapshot.id,
              snapshot.data()!,
            );
            if (ticket.status != TicketStatus.pending) {
              throw TicketAlreadyProcessedException();
            }
            if (ticket.isExpired) throw TicketExpiredException();

            transaction.update(ticketRef, buildUpdate(ticket, agent));
          })
          .timeout(writeTimeout);

      // Lecture serveur : en cache local, processedAt serait encore null.
      final snapshot = await ticketRef.get(
        const GetOptions(source: Source.server),
      );
      final processed = RecyclingTicketModel.fromFirestore(
        snapshot.id,
        snapshot.data()!,
      );
      await _afterProcessed(processed, agent);
      return processed;
    });
  }

  // Hors transaction et sans bloquer : si une écriture est refusée par les
  // règles, le dépôt reste traité ; seule la mise à jour concernée manque.
  Future<void> _afterProcessed(
    RecyclingTicketModel ticket,
    RelayAgentModel agent,
  ) async {
    final validation = ticket.validation;
    if (validation == null) return;
    final validated = ticket.status == TicketStatus.validated;
    final points = (validation.finalPoints ?? 0).round();
    final grams = validation.measuredWeightGrams ?? 0;

    if (validated) {
      await _bestEffort(
        "points usager",
        () => firestore
            .collection(FirestorePaths.users)
            .doc(ticket.userId)
            .update({
              "pointsBalance": FieldValue.increment(points),
              "pointsEarnedTotal": FieldValue.increment(points),
              "stats.totalKg": FieldValue.increment(grams / 1000),
              "stats.depositsCount": FieldValue.increment(1),
            }),
      );
      await _bestEffort(
        "stock",
        () => relayPointStock.addWeight(agent.relayPointId, grams),
      );
    }
    await _bestEffort(
      "notification",
      () => notifications.notify(
        ticket.userId,
        type: validated ? "depositValidated" : "depositRejected",
        data: {
          "ticketCode": ticket.code,
          "itemLabel": ticket.wasteAnalysisResult.detectedItem.itemLabel,
          "points": points,
          "reason": ?validation.rejectionReason?.name,
        },
      ),
    );
  }

  Future<void> _bestEffort(String what, Future<void> Function() write) async {
    try {
      await write().timeout(writeTimeout);
    } on Object catch (e) {
      Log.w("Après traitement : écriture $what impossible ($e)");
    }
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on CustomException {
      rethrow;
    } on FirebaseException catch (e) {
      throw firebaseExceptionMapper(e);
    } on TimeoutException {
      throw NetworkException();
    } catch (_) {
      throw ServerException();
    }
  }
}
