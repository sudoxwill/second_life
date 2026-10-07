import "package:dartz/dartz.dart";

import "../../../../core/errors/failure.dart";
import "../entities/reward.dart";
import "../entities/voucher.dart";

abstract class RewardsRepository {
  Stream<List<Reward>> watchCatalog();
  Stream<List<Voucher>> watchMyVouchers();
  Future<Either<Failure, Voucher>> redeem(Reward reward);
}
