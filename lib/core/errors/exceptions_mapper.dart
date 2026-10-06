import "package:dio/dio.dart";
import "package:firebase_core/firebase_core.dart";

import "exception.dart";

CustomException dioExceptionMapper(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout => NetworkException(),

    DioExceptionType.sendTimeout => NetworkException(),

    DioExceptionType.receiveTimeout => ServerException(),

    DioExceptionType.badCertificate => ServerException(),

    DioExceptionType.badResponse => ServerException(),

    DioExceptionType.cancel => NetworkException(),

    DioExceptionType.connectionError => NetworkException(),

    DioExceptionType.unknown => ServerException(),

    DioExceptionType.transformTimeout => ServerException(),
  };
}

CustomException firebaseExceptionMapper(FirebaseException e) {
  return switch (e.code) {
    "unavailable" => NetworkException(),

    "deadline-exceeded" => NetworkException(),

    "unauthenticated" => UnauthenticatedException(),

    _ => ServerException(),
  };
}
