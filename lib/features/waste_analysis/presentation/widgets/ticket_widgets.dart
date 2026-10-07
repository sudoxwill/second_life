import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/theme/index.dart";
import "../../../../l10n/app_localizations.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/ticket_status.dart";

extension RejectionReasonLabel on RejectionReason {
  String label(AppLocalizations l10n) => switch (this) {
    RejectionReason.itemMismatch => l10n.rejectionItemMismatch,
    RejectionReason.notRecyclable => l10n.rejectionNotRecyclable,
    RejectionReason.itemMissing => l10n.rejectionItemMissing,
    RejectionReason.other => l10n.rejectionOther,
  };
}

// Badge de statut d'un dépôt : En attente / Expiré / Validé / Refusé.
class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({required this.ticket, super.key});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return switch (ticket.status) {
      TicketStatus.pending when ticket.isExpired => Pill(
        label: l10n.historyVoucherStatusExpired,
        icon: LucideIcons.timerOff,
        color: scheme.onSurfaceVariant,
        background: scheme.surfaceContainerLow,
        outlined: true,
      ),
      TicketStatus.pending => Pill(
        label: l10n.historyStatusWaiting,
        icon: LucideIcons.hourglass,
        color: context.warning,
        background: context.warningSoft,
        outlined: true,
      ),
      TicketStatus.validated => Pill(
        label: l10n.historyStatusValidated,
        icon: LucideIcons.circleCheck,
        color: context.primaryText,
        background: context.primarySoft,
        outlined: true,
      ),
      TicketStatus.rejected => Pill(
        label: l10n.historyStatusRejected,
        icon: LucideIcons.circleX,
        color: context.danger,
        background: context.dangerSoft,
        outlined: true,
      ),
    };
  }
}

// Icône feuille verte, ou rouge si le dépôt a été refusé.
class TicketIcon extends StatelessWidget {
  const TicketIcon({required this.ticket, super.key});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final rejected = ticket.status == TicketStatus.rejected;
    return IconTile(
      icon: LucideIcons.leaf,
      color: rejected ? context.danger : context.primaryText,
      background: rejected ? context.dangerSoft : context.primarySoft,
    );
  }
}
