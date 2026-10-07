import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";

class DepositStatusBadge extends StatelessWidget {
  const DepositStatusBadge({required this.status, super.key});

  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dark = context.isDarkMode;
    final (bg, fg, label) = switch (status) {
      TicketStatus.pending => (
        dark ? AppColors.semanticWarningBgDark : AppColors.semanticWarningBg,
        dark ? AppColors.semanticWarningDark : AppColors.semanticWarning,
        l10n.historyStatusWaiting,
      ),
      TicketStatus.validated => (
        dark ? AppColors.semanticSuccessBgDark : AppColors.semanticSuccessBg,
        dark ? AppColors.semanticSuccessDark : AppColors.semanticSuccess,
        l10n.historyStatusValidated,
      ),
      TicketStatus.rejected => (
        dark ? AppColors.semanticErrorBgDark : AppColors.semanticErrorBg,
        dark ? AppColors.semanticErrorDark : AppColors.semanticError,
        l10n.historyStatusRejected,
      ),
    };
    return Pill(label: label, color: fg, background: bg, outlined: true);
  }
}
