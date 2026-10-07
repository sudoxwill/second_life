import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/exceptions_mapper.dart";
import "../../domain/entities/ticket_status.dart";
import "../models/recycling_ticket_model.dart";
import "../models/waste_analysis_result_model.dart";

abstract class RecyclingTicketRemoteDatasource {
  Future<RecyclingTicketModel> createTicket(
    WasteAnalysisResultModel wasteAnalysisResult,
  );
  Future<List<RecyclingTicketModel>> getUserTickets();
}

class RecyclingTicketRemoteDatasourceImpl
    implements RecyclingTicketRemoteDatasource {
  new(this.firestore, this.firebaseAuth);
  static const collectionPath = "recycling_tickets";
  static const writeTimeout = Duration(seconds: 15);

  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  @override
  Future<RecyclingTicketModel> createTicket(
    WasteAnalysisResultModel wasteAnalysisResult,
  ) async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw UnauthenticatedException();

    try {
      // Hors ligne, add() ne se termine qu'au retour du réseau :
      // on coupe pour ne pas bloquer l'utilisateur indéfiniment.
      final docRef = await firestore
          .collection(collectionPath)
          .add({
            "userId": user.uid,
            "wasteAnalysis": wasteAnalysisResult.toJson(),
            "createdAt": FieldValue.serverTimestamp(),
            "status": TicketStatus.pending.name,
            "validation": null,
          })
          .timeout(writeTimeout);

      // Lecture serveur : en cache local, createdAt serait encore null.
      final snapshot = await docRef.get(
        const GetOptions(source: Source.server),
      );
      return RecyclingTicketModel.fromFirestore(snapshot.id, snapshot.data()!);
    } on FirebaseException catch (e) {
      throw firebaseExceptionMapper(e);
    } on TimeoutException {
      throw NetworkException();
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<RecyclingTicketModel>> getUserTickets() async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw UnauthenticatedException();

    try {
      // Le filtre sur userId est obligatoire : les règles refusent
      // toute requête qui pourrait renvoyer les tickets d'un autre.
      final querySnapshot = await firestore
          .collection(collectionPath)
          .where("userId", isEqualTo: user.uid)
          .orderBy("createdAt", descending: true)
          .get(
            // Un ticket pas encore confirmé par le serveur a un createdAt
            // null en cache : on prend l'estimation locale à la place.
            const GetOptions(
              serverTimestampBehavior: ServerTimestampBehavior.estimate,
            ),
          );

      return querySnapshot.docs
          .map((doc) => RecyclingTicketModel.fromFirestore(doc.id, doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw firebaseExceptionMapper(e);
    } catch (_) {
      throw ServerException();
    }
  }
}
