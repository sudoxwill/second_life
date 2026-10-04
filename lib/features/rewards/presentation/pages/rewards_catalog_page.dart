import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../domain/entities/reward_card.dart";
import "../providers/rewards_provider.dart";
import "../providers/rewards_state.dart";
import "../widgets/balance_header_card.dart";
import "../widgets/category_filter_chips.dart";
import "../widgets/reward_card_tile.dart";
import "../widgets/voucher_card_tile.dart";
import "reward_detail_page.dart";

/// Écran principal du catalogue de récompenses et de gestion des cartes cadeaux.
class RewardsCatalogPage extends ConsumerStatefulWidget {
  const RewardsCatalogPage({super.key});

  @override
  ConsumerState<RewardsCatalogPage> createState() => _RewardsCatalogPageState();
}

class _RewardsCatalogPageState extends ConsumerState<RewardsCatalogPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetail(RewardCard card) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RewardDetailPage(card: card),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final state = ref.watch(rewardsNotifierProvider);
    final notifier = ref.read(rewardsNotifierProvider.notifier);

    return AppScaffold(
      onRefresh: () async {
        await notifier.loadRewardsData();
      },
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre principal
                Text(
                  "Besoins Essentiels",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Transformez vos points en alimentation, santé et éducation",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapVLg,

                // Carte de solde et simulateur
                BalanceHeaderCard(points: state.userPoints),
                AppSpacing.gapVLg,

                // Onglets Catalogue / Mes Cartes
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: AppSpacing.roundedMd,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: colorScheme.primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    labelStyle: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: [
                      const Tab(iconMargin: EdgeInsets.zero, text: "Catalogue"),
                      Tab(
                        iconMargin: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Mes Cartes"),
                            if (state.vouchers.isNotEmpty) ...[
                              AppSpacing.gapHSm,
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "${state.vouchers.length}",
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapVLg,
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ─── Onglet 1 : Catalogue ───────────
            _buildCatalogTab(context, state, notifier),

            // ─── Onglet 2 : Mes Cartes Débloquées ───
            _buildMyVouchersTab(context, state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogTab(
    BuildContext context,
    RewardsState state,
    RewardsNotifier notifier,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final cards = state.filteredCatalog;

    return CustomScrollView(
      slivers: [
        // Champ de recherche
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppTextFormField(
              controller: _searchController,
              hintText: "Rechercher riz, pharmacie, écolage, kits...",
              prefixIconData: LucideIcons.search,
              onChanged: (val) => notifier.updateSearch(val ?? ""),
              suffixIconData: _searchController.text.isNotEmpty
                  ? LucideIcons.x
                  : null,
              suffixIconOnClick: () {
                _searchController.clear();
                notifier.updateSearch("");
              },
            ),
          ),
        ),

        // Filtres par catégories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: CategoryFilterChips(
              selectedCategory: state.selectedCategory,
              onSelected: notifier.selectCategory,
            ),
          ),
        ),

        // Liste des cartes du catalogue
        if (state.status == RewardsStatus.loading && cards.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (cards.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.gift, size: 48, color: colorScheme.outline),
                  AppSpacing.gapVMd,
                  Text(
                    "Aucune récompense trouvée",
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.gapVXs,
                  Text(
                    "Essayez avec un autre mot-clé ou filtre.",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: RewardCardTile(
                  card: card,
                  onTap: () => _navigateToDetail(card),
                ),
              );
            }, childCount: cards.length),
          ),
      ],
    );
  }

  Widget _buildMyVouchersTab(
    BuildContext context,
    RewardsState state,
    RewardsNotifier notifier,
  ) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final vouchers = state.vouchers;

    if (vouchers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.ticket,
                size: 48,
                color: colorScheme.outline,
              ),
            ),
            AppSpacing.gapVLg,
            Text(
              "Aucun bon d'achat pour le moment",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapVXs,
            Text(
              "Échangez vos points dans le catalogue pour débloquer votre première carte cadeau !",
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapVLg,
            OutlinedButton.icon(
              onPressed: () {
                _tabController.animateTo(0);
              },
              icon: const Icon(LucideIcons.arrowLeft, size: 16),
              label: const Text("Parcourir le catalogue"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final voucher = vouchers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: VoucherCardTile(
            voucher: voucher,
            onMarkAsUsed: () => notifier.markVoucherUsed(voucher.id),
          ),
        );
      },
    );
  }
}
