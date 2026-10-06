import "package:dio/dio.dart";

Dio createRodiumDioClient() {
  return Dio(
    BaseOptions(
      baseUrl: "https://api.rodiumai.io/v1/",
      contentType: "application/json",
    ),
  );
}
