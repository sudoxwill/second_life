import "package:flutter/material.dart" hide MaterialType;
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "deposit_detail_sheet.dart";
import "deposit_status_badge.dart";
import "material_type_icon.dart";

// Fiche détaillée d'un dépôt de l'usager, en feuille extensible.
Future<void> showDepositDetailSheet(
  BuildContext context,
  RecyclingTicket ticket,
) {
  return showModalBottomSheet<void>(
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

class DepositHistoryCard extends StatelessWidget {
  const DepositHistoryCard({required this.ticket, super.key});

  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

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
    final pending = ticket.status == TicketStatus.pending;
    final pointsLabel = pending
        ? l10n.historyPointsPending(points ?? 0)
        : l10n.historyPointsCertified(points ?? 0);

    return Padding(
      padding: AppSpacing.insetVXs,
      child: AppCard(
        padding: AppSpacing.cardPaddingCompact,
        onTap: () => showDepositDetailSheet(context, ticket),
        child: Column(
          children: [
            Row(
              children: [
                MaterialTypeIcon(material: material, size: AppSpacing.mega),
                AppSpacing.gapHMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.wasteAnalysisResult.detectedItem.itemLabel,
                        style: textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${material.label(l10n)} · $dateLabel",
                        style: textTheme.bodySmall!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AppSpacing.gapHSm,
                DepositStatusBadge(status: ticket.status),
              ],
            ),
            const Divider(height: AppSpacing.xxl),
            Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  LucideIcons.scale,
                  color: context.primaryText,
                  size: AppSpacing.iconSm,
                ),
                Expanded(
                  child: Text(
                    weightLabel,
                    style: textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showPoints && points != null)
                  Pill(
                    label: pointsLabel,
                    icon: pending
                        ? LucideIcons.hourglass
                        : LucideIcons.sparkles,
                    color: pending ? context.warning : context.primaryText,
                    background: pending
                        ? context.warningSoft
                        : context.primarySoft,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
