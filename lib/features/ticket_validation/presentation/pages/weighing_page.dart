import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failure_message.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../../domain/ticket_validation_policy.dart";
import "../providers/ticket_validation_provider.dart";
import "../widgets/reject_reason_dialog.dart";
import "validation_result_page.dart";

// Charge le ticket (code ou contenu du QR) et ouvre l'écran de pesée.
void openWeighing(BuildContext context, String input, {bool replace = false}) {
  ProviderScope.containerOf(
    context,
    listen: false,
  ).read(ticketValidationProvider.notifier).loadTicket(input);
  final route = MaterialPageRoute<void>(builder: (_) => const WeighingPage());
  // Navigateur racine : la pesée s'affiche par-dessus la barre du bas, même
  // quand elle est ouverte depuis un onglet de la coque.
  final navigator = Navigator.of(context, rootNavigator: true);
  if (replace) {
    navigator.pushReplacement(route);
  } else {
    navigator.push(route);
  }
}

// Pesée au point relais : saisie du poids réel, puis validation ou refus.
class WeighingPage extends ConsumerStatefulWidget {
  const WeighingPage({super.key});

  @override
  ConsumerState<WeighingPage> createState() => _WeighingPageState();
}

class _WeighingPageState extends ConsumerState<WeighingPage> {
  final _weightController = TextEditingController();
  final _commentController = TextEditingController();
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _weightController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // L'agent saisit des kg (virgule ou point), on stocke des grammes.
  double? get _measuredGrams {
    final kg = double.tryParse(
      _weightController.text.trim().replaceAll(",", "."),
    );
    return kg == null ? null : kg * 1000;
  }

  Future<void> _validate() async {
    final grams = _measuredGrams;
    if (grams == null) {
      showAppSnackBar(
        context,
        failureMessage(context.l10n, InvalidWeightFailure()),
        error: true,
      );
      return;
    }
    await _process(
      () => ref
          .read(ticketValidationProvider.notifier)
          .validate(
            measuredWeightGrams: grams,
            comment: _commentController.text,
          ),
    );
  }

  Future<void> _reject() async {
    final choice = await showRejectReasonDialog(context);
    if (choice == null) return;
    await _process(
      () => ref
          .read(ticketValidationProvider.notifier)
          .reject(reason: choice.reason, comment: choice.comment),
    );
  }

  Future<void> _process(Future<Failure?> Function() action) async {
    setState(() => _processing = true);
    final failure = await action();
    if (!mounted) return;
    setState(() => _processing = false);

    if (failure != null) {
      showAppSnackBar(
        context,
        failureMessage(context.l10n, failure),
        error: true,
      );
      return;
    }
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    final ticket = ref.read(ticketValidationProvider).value;
    if (ticket == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ValidationResultPage(ticket: ticket),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ticketValidationProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.weighingTitle)),
      body: switch (state) {
        AsyncData(value: final ticket?) => _form(ticket),
        AsyncError(:final error) => ListView(
          padding: const EdgeInsets.all(20),
          children: [ErrorCard(error: error)],
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _form(RecyclingTicket ticket) {
    final l10n = context.l10n;
    final analysis = ticket.wasteAnalysisResult;
    final estimated = analysis.itemWeight.estimatedWeight;
    final estimatedPoints = analysis.itemRecyclability.pointsEarned;
    final measured = _measuredGrams;
    final certifiedPoints = measured == null
        ? null
        : TicketValidationPolicy.prorate(estimatedPoints, measured, estimated);
    final deviated =
        measured != null &&
        TicketValidationPolicy.isWeightDeviated(measured, estimated);
    final canProcess = ticket.canBeProcessed && !_processing;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [
        _DepositorCard(ticket: ticket),
        if (!ticket.canBeProcessed) ...[
          const SizedBox(height: 14),
          ErrorCard(
            error: ticket.status == TicketStatus.pending
                ? TicketExpiredFailure()
                : TicketAlreadyProcessedFailure(),
          ),
        ],
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppCard(
                child: _WeightColumn(
                  title: l10n.weighingEstimatedTitle,
                  value: Text(
                    Formatters.kg(estimated),
                    style: AppTextStyles.heading(30),
                  ),
                  caption: Text(
                    l10n.weighingEstimatedCaption(
                      Formatters.points(estimatedPoints),
                    ),
                    style: TextStyle(color: context.warning),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppCard(
                borderColor: context.primaryText,
                child: _WeightColumn(
                  title: l10n.weighingRealTitle,
                  // Largeur du texte saisi : "kg" reste collé au nombre.
                  value: IntrinsicWidth(
                    child: TextField(
                      controller: _weightController,
                      enabled: canProcess,
                      autofocus: ticket.canBeProcessed,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9.,]")),
                      ],
                      style: AppTextStyles.heading(
                        30,
                        color: context.primaryText,
                      ),
                      decoration: const InputDecoration(
                        hintText: "0,0",
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  caption: Text(
                    certifiedPoints == null
                        ? l10n.weighingEnterWeight
                        : l10n.weighingCertifiedCaption(
                            Formatters.points(certifiedPoints),
                          ),
                    style: TextStyle(color: context.primaryText),
                  ),
                ),
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: AppSpacing.durationFast,
          child: measured == null
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: _DeviationBanner(
                    measured: measured,
                    estimated: estimated,
                    deviated: deviated,
                  ),
                ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _commentController,
          enabled: canProcess,
          maxLength: TicketValidationPolicy.maxCommentLength,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: deviated
                ? l10n.weighingCommentRequired
                : l10n.commentOptional,
            counterText: "",
          ),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: canProcess && measured != null ? _validate : null,
          icon: _processing
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Icon(LucideIcons.circleCheck),
          label: Text(
            certifiedPoints == null
                ? l10n.weighingValidate
                : l10n.weighingValidateWithPoints(
                    Formatters.points(certifiedPoints),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: canProcess ? _reject : null,
          style: TextButton.styleFrom(foregroundColor: context.danger),
          icon: const Icon(LucideIcons.circleX),
          label: Text(l10n.weighingReject),
        ),
      ],
    );
  }
}

class _DepositorCard extends StatelessWidget {
  const _DepositorCard({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final item = ticket.wasteAnalysisResult.detectedItem;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(l10n.depositDepositor),
          const SizedBox(height: 6),
          Text(
            Formatters.userLabel(l10n, ticket.userId),
            style: AppTextStyles.heading(20),
          ),
          Text(
            l10n.weighingDepositId(Formatters.shortCode(ticket.code)),
            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
          // Sous l'en-tête : les catégories de l'IA peuvent être très longues
          // (ex. "Déchets d'Équipements Électriques et Électroniques").
          const SizedBox(height: 10),
          Pill(
            label: item.itemMainCategory,
            color: context.primaryText,
            background: context.primarySoft,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(LucideIcons.leaf, size: 18, color: context.primaryText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.itemLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                l10n.weighingAiConfidence(
                  Formatters.percent(item.itemconfidenceScore),
                ),
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeightColumn extends StatelessWidget {
  const _WeightColumn({
    required this.title,
    required this.value,
    required this.caption,
  });
  final String title;
  final Widget value;
  final Widget caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Flexible(child: value),
            const SizedBox(width: 4),
            const Text("kg", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        DefaultTextStyle.merge(
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          child: caption,
        ),
      ],
    );
  }
}

class _DeviationBanner extends StatelessWidget {
  const _DeviationBanner({
    required this.measured,
    required this.estimated,
    required this.deviated,
  });
  final double measured;
  final double estimated;
  final bool deviated;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final diff = measured - estimated;
    final color = deviated ? context.warning : context.primaryText;
    final limit = Formatters.percent(TicketValidationPolicy.maxWeightDeviation);
    final signedDiff = "${diff >= 0 ? "+" : "−"}${Formatters.kg(diff.abs())}";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: deviated ? context.warningSoft : context.primarySoft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(
            deviated ? LucideIcons.triangleAlert : LucideIcons.circleCheck,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              deviated
                  ? l10n.weighingDeviationHigh(signedDiff, limit)
                  : l10n.weighingDeviationOk(signedDiff, limit),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          if (estimated > 0)
            Text(
              Formatters.percent(diff.abs() / estimated),
              style: TextStyle(color: color, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
