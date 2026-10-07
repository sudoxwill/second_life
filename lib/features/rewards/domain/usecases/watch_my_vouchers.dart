import "../../../../shared/domain/usecases/usecase.dart";
import "../entities/voucher.dart";
import "../repositories/rewards_repository.dart";

// Bons de l'usager connecté, les plus récents d'abord.
class WatchMyVouchers implements StreamUsecase<List<Voucher>, NoParam> {
  new(this.rewardsRepository);
  final RewardsRepository rewardsRepository;

  @override
  Stream<List<Voucher>> call(NoParam p) => rewardsRepository.watchMyVouchers();
}
