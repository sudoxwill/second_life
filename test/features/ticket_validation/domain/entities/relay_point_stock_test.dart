import "package:flutter_test/flutter_test.dart";
import "package:second_life/features/ticket_validation/domain/entities/relay_point_stock.dart";

void main() {
  test("un lot vide a un objectif par défaut de 200 kg", () {
    const stock = RelayPointStock();
    expect(stock.batchTargetKg, 200);
    expect(stock.progress, 0);
    expect(stock.remainingKg, 200);
  });

  test("calcule progression et reste à collecter", () {
    const stock = RelayPointStock(currentBatchGrams: 50000);
    expect(stock.progress, 0.25);
    expect(stock.collectedKg, 50);
    expect(stock.remainingKg, 150);
  });

  test("ne dépasse pas l'objectif", () {
    const stock = RelayPointStock(currentBatchGrams: 250000);
    expect(stock.progress, 1);
    expect(stock.remainingKg, 0);
  });
}
