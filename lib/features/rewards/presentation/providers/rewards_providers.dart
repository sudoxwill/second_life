import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";
import "../../../../shared/presentation/providers/in_app_notifications_providers.dart";
import "../../data/datasources/rewards_remote_datasource.dart";
import "../../data/repositories/rewards_repository_impl.dart";
import "../../domain/repositories/rewards_repository.dart";
import "../../domain/usecases/redeem_reward.dart";
import "../../domain/usecases/watch_my_vouchers.dart";
import "../../domain/usecases/watch_rewards.dart";

part "rewards_providers.g.dart";

@Riverpod(keepAlive: true)
RewardsRemoteDatasource rewardsRemoteDatasource(Ref ref) =>
    RewardsRemoteDatasourceImpl(
      ref.watch(firebaseFirestoreProvider),
      ref.watch(firebaseAuthProvider),
      ref.watch(notificationsRemoteSourceProvider),
    );

@Riverpod(keepAlive: true)
RewardsRepository rewardsRepository(Ref ref) =>
    RewardsRepositoryImpl(ref.watch(rewardsRemoteDatasourceProvider));

@Riverpod(keepAlive: true)
WatchRewards watchRewards(Ref ref) =>
    WatchRewards(ref.watch(rewardsRepositoryProvider));

@Riverpod(keepAlive: true)
WatchMyVouchers watchMyVouchers(Ref ref) =>
    WatchMyVouchers(ref.watch(rewardsRepositoryProvider));

@Riverpod(keepAlive: true)
RedeemReward redeemReward(Ref ref) =>
    RedeemReward(ref.watch(rewardsRepositoryProvider));
