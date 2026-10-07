import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";

class DepositStatusBadge extends StatelessWidget {
  const DepositStatusBadge({required this.status, super.key});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (bg, fg, label) = switch (status) {
      TicketStatus.pending => (
        AppColors.semanticWarningBg,
        AppColors.semanticWarning,
        l10n.historyStatusWaiting,
      ),
      TicketStatus.validated => (
        AppColors.semanticSuccessBg,
        AppColors.semanticSuccess,
        l10n.historyStatusValidated,
      ),
      TicketStatus.rejected => (
        AppColors.semanticErrorBg,
        AppColors.semanticError,
        l10n.historyStatusRejected,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.roundedFull,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }
}
