import "package:cloud_firestore/cloud_firestore.dart";
import "package:dio/dio.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/network/api_interceptor.dart";
import "../../../core/network/dio_client.dart";

part "core_providers.g.dart";

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

// Utilisateur Firebase courant, null une fois déconnecté.
@Riverpod(keepAlive: true)
Stream<User?> firebaseUser(Ref ref) =>
    ref.watch(firebaseAuthProvider).authStateChanges();

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) => GoogleSignIn();

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = createRodiumDioClient();
  dio.interceptors.add(ApiInterceptor());
  return dio;
}
