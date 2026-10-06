import "package:flutter/material.dart" hide MaterialType;
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";
import "../../domain/entities/deposit_entity.dart";
import "deposit_detail_sheet.dart";
import "deposit_status_badge.dart";
import "material_type_icon.dart";

class DepositHistoryCard extends StatelessWidget {
  const DepositHistoryCard({required this.deposit, super.key});

  final DepositEntity deposit;

  void _openDetail(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDark = context.isDarkMode;

    final dateLabel = context.formatDateTime(deposit.dateTime);
    final realWeight = deposit.realWeight;
    final weightLabel = deposit.status == DepositStatus.validated &&
            realWeight != null
        ? l10n.historyWeightReal(realWeight)
        : l10n.historyWeightEstimated(deposit.estimatedWeight);
    final points = deposit.points;
    final showPoints =
        deposit.status != DepositStatus.rejected && points != null;
    final pointsLabel = deposit.status == DepositStatus.waiting
        ? l10n.historyPointsPending(points ?? 0)
        : l10n.historyPointsCertified(points ?? 0);

    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        margin: AppSpacing.insetVXs,
        padding: AppSpacing.insetSm,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.roundedMd,
          color: colorScheme.primaryContainer.withValues(
            alpha: isDark ? .4 : 1,
          ),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: MaterialTypeIcon(material: deposit.material),
              title: Text(
                deposit.material.label(l10n),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(dateLabel),
              trailing: DepositStatusBadge(status: deposit.status),
            ),
            AppDivider(color: colorScheme.outline, indent: 0),
            Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  LucideIcons.scale,
                  color: colorScheme.primary,
                  size: AppSpacing.iconMd,
                ),
                Text(weightLabel, style: textTheme.bodyMedium),
                const Spacer(),
                if (showPoints)
                  Chip(
                    label: Text(
                      pointsLabel,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    backgroundColor:
                        colorScheme.primary.withValues(alpha: .15),
                  ),
                if (deposit.status == DepositStatus.rejected)
                  Text(
                    l10n.historyStatusRejected,
                    style: textTheme.labelMedium!.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
