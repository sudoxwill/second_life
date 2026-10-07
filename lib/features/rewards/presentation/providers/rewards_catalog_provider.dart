import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/domain/usecases/usecase.dart";
import "../../../../shared/presentation/providers/core_providers.dart";
import "../../../auth/presentation/providers/current_user_provider.dart";
import "../../domain/entities/reward.dart";
import "../../domain/entities/voucher.dart";
import "rewards_providers.dart";

part "rewards_catalog_provider.g.dart";

@Riverpod(keepAlive: true)
Stream<List<Reward>> rewards(Ref ref) {
  if (ref.watch(firebaseUserProvider).value == null) {
    return Stream.value(const []);
  }
  return ref.watch(watchRewardsProvider)(NoParam());
}

@Riverpod(keepAlive: true)
Stream<List<Voucher>> vouchers(Ref ref) {
  if (ref.watch(firebaseUserProvider).value == null) {
    return Stream.value(const []);
  }
  return ref.watch(watchMyVouchersProvider)(NoParam());
}

// Solde tenu dans users/{uid}.
@riverpod
int pointsBalance(Ref ref) =>
    ref.watch(currentUserProvider).value?.pointsBalance ?? 0;

// Prochaine récompense hors de portée : l'objectif affiché sur l'accueil.
@riverpod
Reward? nextReward(Ref ref) {
  final balance = ref.watch(pointsBalanceProvider);
  final catalog = ref.watch(rewardsProvider).value ?? const [];
  return catalog
      .where((r) => !r.isOutOfStock && r.pointsCost > balance)
      .firstOrNull;
}
