import "dart:typed_data";

import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/waste_analysis/waste_analysis.dart";

void main() {
  group("DetectedMaterialModel", () {
    test("mappe correctement le plastique PET", () {
      final json = {
        "name": "Bouteille d'eau",
        "category": "plastic_pet",
        "confidence": 0.95,
        "description": "Bouteille transparente recyclable",
      };

      final model = DetectedMaterialModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.name, "Bouteille d'eau");
      expect(entity.category, WasteCategory.plasticPet);
      expect(entity.confidence, 0.95);
      expect(entity.isReliable, isTrue);
      expect(entity.category.isRecyclableInRelayPoint, isTrue);
    });

    test("détecte les déchets non recyclables en point relais", () {
      final json = {
        "name": "Morceau de verre",
        "category": "glass",
        "confidence": 0.88,
      };

      final model = DetectedMaterialModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.category, WasteCategory.glass);
      expect(entity.category.isRecyclableInRelayPoint, isFalse);
    });
  });

  group("WasteAnalysisResultModel", () {
    test("calcule correctement les points et le matériau principal", () {
      final json = {
        "materials": [
          {
            "name": "Bouteille plastique",
            "category": "plastic_pet",
            "confidence": 0.92,
          },
          {
            "name": "Bouchon",
            "category": "plastic_pehd",
            "confidence": 0.70,
          },
        ],
        "estimated_quantity": 2,
        "estimated_weight_kg": 0.05,
        "is_accepted": true,
        "preparation_advice": "Vider et écraser avant dépôt",
      };

      final model = WasteAnalysisResultModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.isAccepted, isTrue);
      expect(entity.estimatedQuantity, 2);
      expect(entity.estimatedWeightKg, 0.05);
      expect(entity.estimatedPoints, 5); // 0.05 * 100 = 5 points
      expect(entity.primaryMaterial?.name, "Bouteille plastique");
    });
  });

  group("RodiumAiRemoteDataSource dev simulation", () {
    test("retourne un résultat de dev valide sans clé API", () async {
      final dataSource = RodiumAiRemoteDataSource();
      final result = await dataSource.analyzeWasteImage(
        imageBytes: Uint8List.fromList([1, 2, 3]),
        mimeType: "image/jpeg",
      );

      expect(result.isAccepted, isTrue);
      expect(result.estimatedWeightKg, greaterThan(0));
      expect(result.preparationAdvice, isNotEmpty);
    });
  });
}
