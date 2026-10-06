import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../../waste_analysis/presentation/widgets/ticket_widgets.dart";
import "../../domain/ticket_validation_policy.dart";

typedef RejectChoice = ({RejectionReason reason, String? comment});

// Choix du motif de refus. Renvoie null si l'agent annule.
Future<RejectChoice?> showRejectReasonDialog(BuildContext context) {
  return showDialog<RejectChoice>(
    context: context,
    builder: (_) => const _RejectReasonDialog(),
  );
}

class _RejectReasonDialog extends StatefulWidget {
  const _RejectReasonDialog();

  @override
  State<_RejectReasonDialog> createState() => _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<_RejectReasonDialog> {
  final _commentController = TextEditingController();
  RejectionReason _reason = RejectionReason.itemMismatch;

  bool get _commentRequired => _reason == RejectionReason.other;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final comment = TicketValidationPolicy.normalizeComment(
      _commentController.text,
    );
    final canConfirm = !_commentRequired || comment != null;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: scheme.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.cancel_outlined, color: context.danger),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Motif de refus du dépôt",
                    style: AppTextStyles.heading(19, color: context.danger),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Sélectionnez le motif : il sera affiché à l’usager.",
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            for (final reason in RejectionReason.values) ...[
              _ReasonOption(
                label: reason.label,
                selected: reason == _reason,
                onTap: () => setState(() => _reason = reason),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 4),
            TextField(
              controller: _commentController,
              maxLength: TicketValidationPolicy.maxCommentLength,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: _commentRequired
                    ? "Précisez le motif (obligatoire)"
                    : "Commentaire (facultatif)",
                counterText: "",
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.onSurfaceVariant,
                      side: BorderSide(color: scheme.outlineVariant),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Annuler"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: context.danger,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: canConfirm
                        ? () => Navigator.pop<RejectChoice>(context, (
                            reason: _reason,
                            comment: comment,
                          ))
                        : null,
                    child: const Text("Confirmer le refus"),
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

class _ReasonOption extends StatelessWidget {
  const _ReasonOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? context.dangerSoft : scheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? context.danger : scheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? context.danger : scheme.onSurface,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? context.danger : scheme.outline,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
