import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/exceptions_mapper.dart";
import "../../domain/entities/map_point.dart";
import "../models/map_point_model.dart";

abstract class PlacesRemoteDatasource {
  Future<List<MapPointModel>> getMapPoints();
}

class PlacesRemoteDatasourceImpl implements PlacesRemoteDatasource {
  new(this.firestore);
  static const relayPointsPath = "relay_points";
  static const recyclingPointsPath = "recycling_points";
  static const readTimeout = Duration(seconds: 15);

  final FirebaseFirestore firestore;

  @override
  Future<List<MapPointModel>> getMapPoints() {
    return _guard(() async {
      final results = await Future.wait([
        _fetch(relayPointsPath, MapPointCategory.relay),
        _fetch(recyclingPointsPath, MapPointCategory.recycling),
      ]);
      return [...results[0], ...results[1]];
    });
  }

  Future<List<MapPointModel>> _fetch(
    String path,
    MapPointCategory category,
  ) async {
    final snapshot = await firestore
        .collection(path)
        .where("isActive", isEqualTo: true)
        .get()
        .timeout(readTimeout);
    return [
      for (final doc in snapshot.docs)
        ?MapPointModel.fromFirestore(doc.id, category, doc.data()),
    ];
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
