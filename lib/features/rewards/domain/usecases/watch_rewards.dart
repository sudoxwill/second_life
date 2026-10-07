import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/reward.dart";
import "../repositories/rewards_repository.dart";

// Catalogue actif, de la récompense la moins chère à la plus chère.
class WatchRewards implements StreamUsecase<List<Reward>, NoParam> {
  new(this.rewardsRepository);
  final RewardsRepository rewardsRepository;

  @override
  Stream<List<Reward>> call(NoParam p) => rewardsRepository.watchCatalog();
}
