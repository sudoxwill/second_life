import "package:flutter/material.dart" hide ButtonSegment;
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/buttons/app_segmented_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
import "../../domain/entities/deposit_entity.dart";
import "../providers/history_providers.dart";
import "../widget/deposit_detail_sheet.dart";
import "../widget/deposit_history_card.dart";
import "../widget/index.dart";

class UserHistoryPage extends ConsumerStatefulWidget {
  const UserHistoryPage({super.key});

  @override
  ConsumerState<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends ConsumerState<UserHistoryPage> {
  Set<HistoryType> currentHistory = {HistoryType.waiting};

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

  void _handleDeepLink(String depositId) {
    final pending = ref.read(pendingDepositsProvider).value;
    final processed = ref.read(processedDepositsProvider).value;

    if (pending == null || processed == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _handleDeepLink(depositId);
      });
      return;
    }

    final deposit = [...pending, ...processed]
        .cast<DepositEntity?>()
        .firstWhere((d) => d?.id == depositId, orElse: () => null);
    if (deposit == null) return;

    setState(() {
      currentHistory = {
        if (deposit.status == DepositStatus.waiting)
          HistoryType.waiting
        else
          HistoryType.processed,
      };
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (_) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (ctx, sc) =>
              DepositDetailSheet(deposit: deposit, scrollController: sc),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(pendingDepositsCountProvider);
    return AppScaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Historique de vos activités"),
      ),
      body: Column(
        spacing: AppSpacing.md,
        children: [
          AppSegmentedButton<HistoryType>(
            segments: HistoryType.values.map((type) {
              final label = type == HistoryType.waiting && count > 0
                  ? "${type.label} ($count)"
                  : type.label;
              return ButtonSegment(value: type, label: Text(label));
            }).toList(),
            selected: currentHistory,
            onSelectionChanged: (value) =>
                setState(() => currentHistory = value),
          ),
          Expanded(
            child: switch (currentHistory.first) {
              HistoryType.waiting => const _WaitingDepositList(),
              HistoryType.processed => const _ProcessedDepositList(),
              HistoryType.gift => const _VoucherList(),
            },
          ),
          AppSpacing.gapVMd,
        ],
      ),
    );
  }
}

// ── Listes ────────────────────────────────────────────────────────────────────

class _WaitingDepositList extends ConsumerWidget {
  const _WaitingDepositList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(pendingDepositsProvider)
        .when(
          loading: () => const _DepositSkeleton(),
          error: (_, __) => _ErrorState(
            onRetry: () => ref.invalidate(pendingDepositsProvider),
          ),
          data: (deposits) => deposits.isEmpty
              ? const _EmptyState(type: HistoryType.waiting)
              : ListView.builder(
                  itemCount: deposits.length,
                  itemBuilder: (_, i) =>
                      DepositHistoryCard(deposit: deposits[i]),
                ),
        );
  }
}

class _ProcessedDepositList extends ConsumerWidget {
  const _ProcessedDepositList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(processedDepositsProvider)
        .when(
          loading: () => const _DepositSkeleton(),
          error: (_, __) => _ErrorState(
            onRetry: () => ref.invalidate(processedDepositsProvider),
          ),
          data: (deposits) => deposits.isEmpty
              ? const _EmptyState(type: HistoryType.processed)
              : ListView.builder(
                  itemCount: deposits.length,
                  itemBuilder: (_, i) =>
                      DepositHistoryCard(deposit: deposits[i]),
                ),
        );
  }
}

class _VoucherList extends ConsumerWidget {
  const _VoucherList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(vouchersProvider)
        .when(
          loading: () => const _DepositSkeleton(),
          error: (_, __) =>
              _ErrorState(onRetry: () => ref.invalidate(vouchersProvider)),
          data: (vouchers) => vouchers.isEmpty
              ? const _EmptyState(type: HistoryType.gift)
              : ListView.builder(
                  itemCount: vouchers.length,
                  itemBuilder: (_, i) =>
                      VoucherHistoryCard(voucher: vouchers[i]),
                ),
        );
  }
}

// ── États spéciaux ────────────────────────────────────────────────────────────

class _DepositSkeleton extends StatelessWidget {
  const _DepositSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      isLoading: true,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: const SkeletonTile(
            showLeading: true,
            showTrailing: true,
            lines: 2,
          ),
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
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          Icon(
            LucideIcons.circleAlert,
            size: AppSpacing.iconXxl,
            color: colorScheme.onSurfaceVariant,
          ),
          Text(
            "Une erreur est survenue",
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppElevatedButton(onPressed: onRetry, text: "Réessayer"),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type});

  final HistoryType type;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final isGift = type == HistoryType.gift;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.md,
        children: [
          Icon(
            isGift ? LucideIcons.gift : LucideIcons.inbox,
            size: AppSpacing.iconXxl,
            color: colorScheme.onSurfaceVariant,
          ),
          Text(
            isGift ? "Bientôt disponible" : "Aucun dépôt pour le moment",
            style: textTheme.titleSmall,
          ),
          if (isGift)
            Padding(
              padding: AppSpacing.insetHXl,
              child: Text(
                "L'échange de points contre des récompenses arrive très bientôt.",
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Enum ──────────────────────────────────────────────────────────────────────

enum HistoryType {
  waiting(label: "En attente"),
  processed(label: "Traités"),
  gift(label: "Récompenses");

  const HistoryType({required this.label});

  final String label;
}
