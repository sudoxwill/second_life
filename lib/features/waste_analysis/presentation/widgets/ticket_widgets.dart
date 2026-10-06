import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/ticket_status.dart";

extension RejectionReasonLabel on RejectionReason {
  String get label => switch (this) {
    RejectionReason.itemMismatch => "Objet différent de celui analysé",
    RejectionReason.notRecyclable => "Matière non acceptée ou non recyclable",
    RejectionReason.itemMissing => "Objet absent lors du dépôt",
    RejectionReason.other => "Autre motif",
  };
}

// Badge de statut d'un dépôt : En attente / Expiré / Validé / Refusé.
class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({required this.ticket, super.key});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (ticket.status) {
      TicketStatus.pending when ticket.isExpired => Pill(
        label: "Expiré",
        icon: Icons.timer_off_outlined,
        color: scheme.onSurfaceVariant,
        background: scheme.surfaceContainerLow,
        outlined: true,
      ),
      TicketStatus.pending => Pill(
        label: "En attente",
        icon: Icons.schedule_rounded,
        color: context.warning,
        background: context.warningSoft,
        outlined: true,
      ),
      TicketStatus.validated => Pill(
        label: "Validé",
        icon: Icons.check_circle_outline_rounded,
        color: context.primaryText,
        background: context.primarySoft,
        outlined: true,
      ),
      TicketStatus.rejected => Pill(
        label: "Refusé",
        icon: Icons.cancel_outlined,
        color: context.danger,
        background: const Color(0x1AD9534F),
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
      icon: Icons.eco_outlined,
      color: rejected ? context.danger : context.primaryText,
      background: rejected ? context.dangerSoft : context.primarySoft,
    );
  }
}
