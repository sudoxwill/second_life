import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:second_life/core/errors/exception.dart";
import "package:second_life/core/errors/failure.dart";
import "package:second_life/features/rewards/data/datasources/rewards_remote_datasource.dart";
import "package:second_life/features/rewards/data/models/voucher_model.dart";
import "package:second_life/features/rewards/data/repositories/rewards_repository_impl.dart";
import "package:second_life/features/rewards/domain/entities/reward.dart";

class MockRewardsRemoteDatasource extends Mock
    implements RewardsRemoteDatasource {}

const reward = Reward(
  id: "r1",
  name: "Bon",
  partnerName: "Partenaire",
  description: null,
  pointsCost: 100,
  category: RewardCategory.food,
  validityDays: 30,
);

void main() {
  late MockRewardsRemoteDatasource datasource;
  late RewardsRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(reward));

  setUp(() {
    datasource = MockRewardsRemoteDatasource();
    repository = RewardsRepositoryImpl(datasource);
  });

  test("renvoie le bon créé", () async {
    final voucher = VoucherModel.issue(
      id: "v1",
      reward: reward,
      code: "SL-ABCDEF",
      now: DateTime(2026, 10),
    );
    when(() => datasource.redeem(any())).thenAnswer((_) async => voucher);

    final result = await repository.redeem(reward);

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => throw StateError("")).code, "SL-ABCDEF");
  });

  test("solde insuffisant -> InsufficientPointsFailure", () async {
    when(() => datasource.redeem(any()))
        .thenThrow(InsufficientPointsException());

    final result = await repository.redeem(reward);

    expect(
      result.fold((f) => f, (_) => null),
      isA<InsufficientPointsFailure>(),
    );
  });

  test("stock épuisé -> RewardOutOfStockFailure", () async {
    when(() => datasource.redeem(any())).thenThrow(RewardOutOfStockException());

    final result = await repository.redeem(reward);

    expect(result.fold((f) => f, (_) => null), isA<RewardOutOfStockFailure>());
  });

  test("erreur inattendue -> UnExpectedFailure", () async {
    when(() => datasource.redeem(any())).thenThrow(StateError("boom"));

    final result = await repository.redeem(reward);

    expect(result.fold((f) => f, (_) => null), isA<UnExpectedFailure>());
  });
}
