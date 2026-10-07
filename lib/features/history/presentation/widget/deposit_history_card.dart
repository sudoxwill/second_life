import "package:flutter/material.dart" hide MaterialType;
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "deposit_detail_sheet.dart";
import "deposit_status_badge.dart";
import "material_type_icon.dart";

class DepositHistoryCard extends StatelessWidget {
  const DepositHistoryCard({required this.ticket, super.key});

  final RecyclingTicket ticket;

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
            DepositDetailSheet(ticket: ticket, scrollController: sc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isDark = context.isDarkMode;

    final material = MaterialTypeFromCategory.fromCategory(
      ticket.wasteAnalysisResult.detectedItem.itemMainCategory,
    );
    final estimatedWeight =
        ticket.wasteAnalysisResult.itemWeight.estimatedWeight;
    final realWeightKg = ticket.validation?.measuredWeightGrams != null
        ? ticket.validation!.measuredWeightGrams! / 1000
        : null;

    final dateLabel = context.formatDateTime(ticket.createdAt);
    final weightLabel =
        ticket.status == TicketStatus.validated && realWeightKg != null
        ? l10n.historyWeightReal(realWeightKg)
        : l10n.historyWeightEstimated(estimatedWeight);

    final points = ticket.status == TicketStatus.validated
        ? ticket.validation?.finalPoints?.round()
        : ticket.wasteAnalysisResult.itemRecyclability.pointsEarned.round();
    final showPoints = ticket.status != TicketStatus.rejected;
    final pointsLabel = ticket.status == TicketStatus.pending
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
              leading: MaterialTypeIcon(material: material),
              title: Text(
                material.label(l10n),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(dateLabel),
              trailing: DepositStatusBadge(status: ticket.status),
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
                if (showPoints && points != null)
                  Chip(
                    label: Text(
                      pointsLabel,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    backgroundColor: colorScheme.primary.withValues(alpha: .15),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
