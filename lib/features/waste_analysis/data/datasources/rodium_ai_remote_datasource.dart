import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "../../../core/configs/env.dart";
import "../../../core/configs/logger.dart";
import "../models/waste_analysis_result_model.dart";

/// Exception personnalisée pour les erreurs de communication avec l'IA.
class AiServiceException implements Exception {
  const AiServiceException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

/// Source de données distante connectée à l'API de vision RodiumAI.
class RodiumAiRemoteDataSource {
  RodiumAiRemoteDataSource({
    String? baseUrl,
    String? apiKey,
    String? model,
    HttpClient? httpClient,
  })  : _baseUrl = baseUrl ?? Env.rodiumBaseUrl,
        _apiKey = apiKey ?? Env.rodiumApiKey,
        _model = model ?? Env.rodiumModel,
        _client = httpClient ?? HttpClient();

  final String _baseUrl;
  final String _apiKey;
  final String _model;
  final HttpClient _client;

  /// Prompt système définissant le barème et la classification SecondLife.
  static const String _systemPrompt =
      "Tu es l'intelligence artificielle de tri et de valorisation des "
      "déchets de l'application SecondLife en Afrique de l'Ouest "
      "(Togo, Bénin, Cameroun).\n"
      "Analyse la photo de déchet fournie.\n"
      "Règles d'acceptation en point relais SecondLife :\n"
      "- Matériaux acceptés (is_accepted = true) : Plastique PET (bouteilles "
      "transparentes/colorées), Plastique PEHD (flacons rigides, bouchons), "
      "Canettes aluminium, Ferraille/métaux ferreux.\n"
      "- Matériaux refusés (is_accepted = false) : verre, carton, papier, "
      "déchets électroniques, déchets organiques ou souillés.\n"
      "Pour le poids estimé : donne une valeur réaliste en kilogrammes (ex: "
      "0.03 pour une petite bouteille plastique, 0.015 pour une canette alu).\n"
      "Tu dois répondre STRICTEMENT et UNIQUEMENT avec un JSON valide sous la "
      "forme suivante :\n"
      "{\n"
      '  "materials": [\n'
      '    {"name": "Nom lisible", "category": '
      '"plastic_pet|plastic_pehd|metal_aluminum|metal_iron|'
      'cardboard|glass|electronic|organic|other", '
      '"confidence": 0.95, "description": "Détails"}\n'
      "  ],\n"
      '  "estimated_quantity": 1,\n'
      '  "estimated_weight_kg": 0.04,\n'
      '  "is_accepted": true,\n'
      '  "rejection_reason": null,\n'
      '  "preparation_advice": "Conseil court (ex: vider et écraser)"\n'
      "}";

  /// Envoie l'image encodée à RodiumAI et retourne le modèle typé.
  Future<WasteAnalysisResultModel> analyzeWasteImage({
    required Uint8List imageBytes,
    required String mimeType,
  }) async {
    // Mode dégradé si aucune clé n'est renseignée (permet de tester en dev)
    if (_apiKey.isEmpty && Env.isDevelopment) {
      Log.w(
        "Clé RodiumAI non fournie. Utilisation du mock de développement.",
        tag: "RodiumAI",
      );
      return _generateDevMockResult();
    }

    if (_apiKey.isEmpty) {
      throw const AiServiceException(
        "Clé d'API RodiumAI absente. Veuillez configurer la clé d'accès.",
      );
    }

    try {
      final base64Image = base64Encode(imageBytes);
      final endpoint = Uri.parse("$_baseUrl/chat/completions");

      final requestPayload = {
        "model": _model,
        "temperature": 0.2,
        "response_format": {"type": "json_object"},
        "messages": [
          {
            "role": "system",
            "content": _systemPrompt,
          },
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": "Analyse ce déchet recyclable.",
              },
              {
                "type": "image_url",
                "image_url": {
                  "url": "data:$mimeType;base64,$base64Image",
                },
              },
            ],
          },
        ],
      };

      Log.i("Envoi de l'image à RodiumAI ($_model)...", tag: "RodiumAI");

      final request = await _client.postUrl(endpoint);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        "application/json",
      );
      request.headers.set(
        HttpHeaders.authorizationHeader,
        "Bearer $_apiKey",
      );
      request.write(jsonEncode(requestPayload));

      final response = await request.close().timeout(
        Env.mistralReceiveTimeout,
        onTimeout: () => throw const AiServiceException(
          "Délai d'attente dépassé lors de l'analyse de l'image.",
        ),
      );

      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != HttpStatus.ok) {
        Log.e(
          "Erreur RodiumAI (${response.statusCode}): $responseBody",
          tag: "RodiumAI",
        );
        throw AiServiceException(
          "Erreur du service d'analyse IA (${response.statusCode}).",
        );
      }

      final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
      final choices = jsonResponse["choices"] as List<dynamic>?;

      if (choices == null || choices.isEmpty) {
        throw const AiServiceException("Aucune réponse générée par l'IA.");
      }

      final firstChoice = choices.first as Map<String, dynamic>;
      final message = firstChoice["message"] as Map<String, dynamic>?;
      final content = message?["content"] as String?;

      if (content == null || content.isEmpty) {
        throw const AiServiceException("Contenu d'analyse vide.");
      }

      final parsedContent = _extractJsonObject(content);
      return WasteAnalysisResultModel.fromJson(
        parsedContent,
        rawResponse: content,
      );
    } catch (e, st) {
      if (e is AiServiceException) rethrow;
      Log.e(
        "Erreur inattendue RodiumAI",
        error: e,
        stackTrace: st,
        tag: "RodiumAI",
      );
      throw AiServiceException(
        "Échec de l'analyse visuelle du déchet.",
        cause: e,
      );
    }
  }

  /// Extraction robuste du JSON, même si le modèle inclut des balises
  /// markdown.
  Map<String, dynamic> _extractJsonObject(String raw) {
    var cleaned = raw.trim();
    if (cleaned.startsWith("```json")) {
      cleaned = cleaned.substring(7);
    }
    if (cleaned.startsWith("```")) {
      cleaned = cleaned.substring(3);
    }
    if (cleaned.endsWith("```")) {
      cleaned = cleaned.substring(0, cleaned.length - 3);
    }
    cleaned = cleaned.trim();

    return jsonDecode(cleaned) as Map<String, dynamic>;
  }

  /// Simulation réaliste pour le développement hors-ligne.
  WasteAnalysisResultModel _generateDevMockResult() {
    return const WasteAnalysisResultModel(
      materials: [],
      estimatedQuantity: 1,
      estimatedWeightKg: 0.045,
      isAccepted: true,
      preparationAdvice:
          "Videz tout liquide et compressez la bouteille avant dépôt.",
      rawResponse: '{"mock": true}',
    );
  }
}
