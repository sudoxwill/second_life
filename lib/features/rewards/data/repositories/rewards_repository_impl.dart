import "package:dartz/dartz.dart";

import "../../../../core/errors/exception.dart";
import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failures_mapper.dart";
import "../../domain/entities/reward.dart";
import "../../domain/entities/voucher.dart";
import "../../domain/repositories/rewards_repository.dart";
import "../datasources/rewards_remote_datasource.dart";

class RewardsRepositoryImpl implements RewardsRepository {
  new(this.rewardsRemoteDatasource);
  final RewardsRemoteDatasource rewardsRemoteDatasource;

  @override
  Stream<List<Reward>> watchCatalog() => rewardsRemoteDatasource.watchCatalog();

  @override
  Stream<List<Voucher>> watchMyVouchers() =>
      rewardsRemoteDatasource.watchMyVouchers();

  @override
  Future<Either<Failure, Voucher>> redeem(Reward reward) async {
    try {
      return Right(await rewardsRemoteDatasource.redeem(reward));
    } on CustomException catch (e) {
      return Left(failureMapper(e));
    } catch (_) {
      return Left(UnExpectedFailure());
    }
  }
}
