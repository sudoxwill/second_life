import "dart:convert";

import "package:dio/dio.dart";

import "../../../../core/constants/api_constants.dart";
import "../../../../core/errors/exception.dart";
import "../../../../core/errors/exceptions_mapper.dart";
import "../models/waste_analysis_result_model.dart";

abstract class WasteAnalysisRemoteDatasource {
  Future<WasteAnalysisResultModel> analyzeWastePhoto(String imageUrl);
}

class WasteAnalysisRemoteDatasourceImpl
    implements WasteAnalysisRemoteDatasource {
  new(this.dio);
  final Dio dio;

  @override
  Future<WasteAnalysisResultModel> analyzeWastePhoto(String imageUrl) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        "chat/completions",
        data: {
          "model": ApiConstants.aiModel,
          "messages": [
            {
              "role": ApiConstants.systemRoleKey,
              "content": ApiConstants.systemPrompt,
            },
            {
              "role": ApiConstants.userRoleKey,
              "content": [
                {"type": ApiConstants.textKey, "text": ApiConstants.userPrompt},
                {
                  "type": ApiConstants.imageUrlKey,
                  "image_url": {"url": imageUrl},
                },
              ],
            },
          ],
          "response_format": {"type": "json_object"},
        },
      );

      final choices = response.data?["choices"] as List<dynamic>;
      final message =
          (choices.first as Map<String, dynamic>)["message"]
              as Map<String, dynamic>;
      final data =
          jsonDecode(message["content"] as String) as Map<String, dynamic>;
      return WasteAnalysisResultModel.fromJson(data);
    } on DioException catch (e) {
      throw dioExceptionMapper(e);
    } catch (_) {
      // Réponse de l'IA mal formée
      throw ServerException();
    }
  }
}
