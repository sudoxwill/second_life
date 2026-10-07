import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../domain/entities/reward_entity.dart";

part "rewards_provider.g.dart";

const _mockRewards = <RewardEntity>[
  RewardEntity(
    id: "r1",
    name: "Sac de riz 5 kg",
    category: RewardCategory.food,
    pointsCost: 2500,
    conditionsText:
        "Bon à retirer auprès d'un commerçant partenaire SecondLife. "
        "Non remboursable, non échangeable contre des espèces.",
  ),
  RewardEntity(
    id: "r2",
    name: "Bidon d'huile 1 L",
    category: RewardCategory.food,
    pointsCost: 1200,
    conditionsText:
        "Bon à retirer auprès d'un commerçant partenaire SecondLife. "
        "Non remboursable, non échangeable contre des espèces.",
  ),
  RewardEntity(
    id: "r3",
    name: "Kit de fournitures scolaires",
    category: RewardCategory.education,
    pointsCost: 3000,
    conditionsText:
        "Kit comprenant cahiers, stylos et un cartable. "
        "À retirer en magasin sur présentation du bon. "
        "Non remboursable.",
  ),
  RewardEntity(
    id: "r4",
    name: "1 mois de cantine scolaire",
    category: RewardCategory.education,
    pointsCost: 4000,
    conditionsText:
        "Valable pour un élève inscrit dans un établissement partenaire. "
        "Non transférable. Non remboursable.",
  ),
  RewardEntity(
    id: "r5",
    name: "Bon pharmacie 2 000 F",
    category: RewardCategory.health,
    pointsCost: 2000,
    conditionsText:
        "Bon d'achat valable dans les pharmacies partenaires SecondLife. "
        "Aucun retrait en espèces possible.",
  ),
  RewardEntity(
    id: "r6",
    name: "Moustiquaire imprégnée",
    category: RewardCategory.health,
    pointsCost: 1800,
    conditionsText:
        "Moustiquaire à longue durée d'action (MILDA). "
        "À retirer auprès d'un point de distribution partenaire. "
        "Non remboursable.",
  ),
];

@riverpod
Future<List<RewardEntity>> rewards(Ref ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 600));
  return _mockRewards;
}

@riverpod
Future<RewardEntity?> rewardById(Ref ref, String id) async {
  final list = await ref.watch(rewardsProvider.future);
  return list.cast<RewardEntity?>().firstWhere(
    (r) => r?.id == id,
    orElse: () => null,
  );
}
