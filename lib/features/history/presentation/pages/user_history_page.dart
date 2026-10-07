import "package:flutter/material.dart" hide ButtonSegment;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../l10n/app_localizations.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/buttons/app_segmented_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/motion.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
import "../../../rewards/presentation/providers/rewards_catalog_provider.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/providers/user_tickets_provider.dart";
import "../providers/history_providers.dart";
import "../widgets/index.dart";

class UserHistoryPage extends ConsumerStatefulWidget {
  const UserHistoryPage({super.key});

  @override
  ConsumerState<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends ConsumerState<UserHistoryPage> {
  Set<HistoryType> currentHistory = {HistoryType.waiting};
  // Dernier ?tab= appliqué : l'onglet reste libre tant que l'URL ne change pas.
  String? _handledTab;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final depositId = GoRouterState.of(context)
          .uri
          .queryParameters["deposit"];
      if (depositId != null) _handleDeepLink(depositId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // /history?tab=gift depuis le bouton "Échanger" de l'accueil, etc.
    final tab = GoRouterState.of(context).uri.queryParameters["tab"];
    if (tab == _handledTab) return;
    _handledTab = tab;
    final type = HistoryType.values.asNameMap()[tab];
    if (type != null) currentHistory = {type};
  }

  void _handleDeepLink(String depositId) {
    final pending = ref.read(pendingDepositsProvider).value;
    final processed = ref.read(processedDepositsProvider).value;

    if (pending == null || processed == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _handleDeepLink(depositId);
      });
      return;
    }

    final ticket = [...pending, ...processed]
        .cast<RecyclingTicket?>()
        .firstWhere((t) => t?.code == depositId, orElse: () => null);
    if (ticket == null) return;

    setState(() {
      currentHistory = {
        if (ticket.status == TicketStatus.pending)
          HistoryType.waiting
        else
          HistoryType.processed,
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showDepositDetailSheet(context, ticket);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = ref.watch(pendingDepositsCountProvider);
    return AppScaffold(
      appBar: AppBar(elevation: 0, title: Text(l10n.historyTitle)),
      body: Column(
        spacing: AppSpacing.md,
        children: [
          AppSegmentedButton<HistoryType>(
            segments: HistoryType.values.map((type) {
              final label = type == HistoryType.waiting && count > 0
                  ? "${type.label(l10n)} ($count)"
                  : type.label(l10n);
              return ButtonSegment(value: type, label: Text(label));
            }).toList(),
            selected: currentHistory,
            onSelectionChanged: (value) =>
                setState(() => currentHistory = value),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: AppSpacing.durationFast,
              child: switch (currentHistory.first) {
                HistoryType.waiting => const _WaitingDepositList(
                  key: ValueKey(HistoryType.waiting),
                ),
                HistoryType.processed => const _ProcessedDepositList(
                  key: ValueKey(HistoryType.processed),
                ),
                HistoryType.gift => const _VoucherList(
                  key: ValueKey(HistoryType.gift),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Listes ──────────────────────────────────────────────────

// Liste animée et rafraîchissable, commune aux trois onglets.
class _AnimatedList extends StatelessWidget {
  const _AnimatedList({
    required this.itemCount,
    required this.itemBuilder,
    required this.onRefresh,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          bottom: AppSpacing.bottomScrollablePadding,
        ),
        itemCount: itemCount,
        itemBuilder: (context, i) =>
            FadeSlideIn(index: i, child: itemBuilder(context, i)),
      ),
    );
  }
}

// État vide ou erreur, qui reste rafraîchissable par un tirer vers le bas.
class _RefreshableCenter extends StatelessWidget {
  const _RefreshableCenter({required this.child, required this.onRefresh});

  final Widget child;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _DepositList extends StatelessWidget {
  const _DepositList({
    required this.tickets,
    required this.type,
    required this.onRefresh,
  });

  final AsyncValue<List<RecyclingTicket>> tickets;
  final HistoryType type;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return tickets.when(
      loading: () => const _DepositSkeleton(),
      error: (_, _) => _RefreshableCenter(
        onRefresh: onRefresh,
        child: _ErrorState(onRetry: onRefresh),
      ),
      data: (list) => list.isEmpty
          ? _RefreshableCenter(
              onRefresh: onRefresh,
              child: _EmptyState(type: type),
            )
          : _AnimatedList(
              onRefresh: onRefresh,
              itemCount: list.length,
              itemBuilder: (_, i) => DepositHistoryCard(ticket: list[i]),
            ),
    );
  }
}

class _WaitingDepositList extends ConsumerWidget {
  const _WaitingDepositList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DepositList(
      tickets: ref.watch(pendingDepositsProvider),
      type: HistoryType.waiting,
      onRefresh: ref.read(userTicketsProvider.notifier).refresh,
    );
  }
}

class _ProcessedDepositList extends ConsumerWidget {
  const _ProcessedDepositList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _DepositList(
      tickets: ref.watch(processedDepositsProvider),
      type: HistoryType.processed,
      onRefresh: ref.read(userTicketsProvider.notifier).refresh,
    );
  }
}

class _VoucherList extends ConsumerWidget {
  const _VoucherList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> refresh() => ref.refresh(vouchersProvider.future);
    return ref
        .watch(vouchersProvider)
        .when(
          loading: () => const _DepositSkeleton(),
          error: (_, _) => _RefreshableCenter(
            onRefresh: refresh,
            child: _ErrorState(onRetry: refresh),
          ),
          data: (vouchers) => vouchers.isEmpty
              ? _RefreshableCenter(
                  onRefresh: refresh,
                  child: const _EmptyState(type: HistoryType.gift),
                )
              : _AnimatedList(
                  onRefresh: refresh,
                  itemCount: vouchers.length,
                  itemBuilder: (_, i) =>
                      VoucherHistoryCard(voucher: vouchers[i]),
                ),
        );
  }
}

// ── États spéciaux ─────────────────────────────────────────────

class _DepositSkeleton extends StatelessWidget {
  const _DepositSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, _) => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: SkeletonTile(showTrailing: true),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyState(icon: LucideIcons.cloudOff, title: l10n.commonError),
        AppElevatedButton(
          onPressed: onRetry,
          text: l10n.commonRetry,
          icon: const Icon(LucideIcons.refreshCw, size: AppSpacing.iconMd),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type});

  final HistoryType type;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isGift = type == HistoryType.gift;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmptyState(
          icon: isGift ? LucideIcons.gift : LucideIcons.inbox,
          title: isGift
              ? l10n.historyEmptyGiftTitle
              : l10n.historyEmptyDepositTitle,
          message: isGift
              ? l10n.historyEmptyGiftMessage
              : l10n.homePendingDepositsEmptyHint,
        ),
        FilledButton.tonalIcon(
          onPressed: isGift ? context.pushRewards : context.pushScan,
          icon: Icon(isGift ? LucideIcons.gift : LucideIcons.scanBox),
          label: Text(
            isGift ? l10n.historyEmptyGiftCta : l10n.homeQuickScanTitle,
          ),
        ),
      ],
    );
  }
}

// ── Enum ──────────────────────────────────────────────────

enum HistoryType {
  waiting,
  processed,
  gift;

  String label(AppLocalizations l10n) => switch (this) {
    HistoryType.waiting => l10n.historyTabWaiting,
    HistoryType.processed => l10n.historyTabProcessed,
    HistoryType.gift => l10n.historyTabGift,
  };
}
