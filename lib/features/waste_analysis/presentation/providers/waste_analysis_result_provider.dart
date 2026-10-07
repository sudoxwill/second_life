import "dart:async";
import "dart:io";

import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/utils/image_utils.dart";
import "../../domain/entities/waste_analysis_result.dart";
import "waste_analysis_providers.dart";

part "waste_analysis_result_provider.g.dart";

@Riverpod(keepAlive: true)
class WasteAnalysisResultNotifier extends _$WasteAnalysisResultNotifier {
  @override
  FutureOr<WasteAnalysisResult?> build() => null;

  Future<void> analyzeWastePhoto(File image) async {
    // Avant l'encodage : l'ancien résultat ne doit pas rester affiché.
    state = const AsyncValue.loading();
    final imageUrl = await ImageUtils.getImageUrlFromFile(image);
    final usecase = ref.read(analyzeWastePhotoProvider);
    final result = await usecase(imageUrl);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (result) => state = AsyncValue.data(result),
    );
  }
}
