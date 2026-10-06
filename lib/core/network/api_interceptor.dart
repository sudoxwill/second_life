import "package:dio/dio.dart";

import "../configs/app_config.dart";

class ApiInterceptor extends QueuedInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = AppConfig.instance.apiKey;
    assert(
      apiKey.isNotEmpty,
      "Clé API manquante : renseigner lib/core/configs/secrets.dart",
    );
    options.headers["Authorization"] = "Bearer $apiKey";
    handler.next(options);
  }
}
