import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/reward.dart";
import "../entities/voucher.dart";
import "../repositories/rewards_repository.dart";

// Débite le solde et crée le bon correspondant.
class RedeemReward implements Usecase<Either<Failure, Voucher>, Reward> {
  new(this.rewardsRepository);
  final RewardsRepository rewardsRepository;

  @override
  Future<Either<Failure, Voucher>> call(Reward reward) =>
      rewardsRepository.redeem(reward);
}
