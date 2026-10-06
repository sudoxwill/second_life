import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failure_message.dart";
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
  if (replace) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
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

  // Saisie en kg, virgule ou point → grammes.
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
        failureMessage(InvalidWeightFailure()),
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
      showAppSnackBar(context, failureMessage(failure), error: true);
      return;
    }
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
      appBar: AppBar(title: const Text("Validation de la pesée")),
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
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AppCard(
                  child: _WeightColumn(
                    title: "Poids estimé (IA)",
                    value: Text(
                      Formatters.kg(estimated),
                      style: AppTextStyles.heading(30),
                    ),
                    caption: Text(
                      "≈ ${Formatters.points(estimatedPoints)} pts estimés",
                      style: TextStyle(color: context.warning),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  borderColor: AppColors.primary,
                  child: _WeightColumn(
                    title: "Poids réel (Balance)",
                    value: TextField(
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
                    caption: Text(
                      certifiedPoints == null
                          ? "Saisir le poids pesé"
                          : "= ${Formatters.points(certifiedPoints)} "
                                "pts certifiés",
                      style: TextStyle(color: context.primaryText),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (measured != null) ...[
          const SizedBox(height: 14),
          _DeviationBanner(
            measured: measured,
            estimated: estimated,
            deviated: deviated,
          ),
        ],
        const SizedBox(height: 14),
        TextField(
          controller: _commentController,
          enabled: canProcess,
          maxLength: TicketValidationPolicy.maxCommentLength,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: deviated
                ? "Commentaire (obligatoire : écart important)"
                : "Commentaire (facultatif)",
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
              : const Icon(Icons.check_circle_outline_rounded),
          label: Text(
            certifiedPoints == null
                ? "Valider le dépôt"
                : "Valider le dépôt "
                      "(${Formatters.points(certifiedPoints)} pts)",
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: canProcess ? _reject : null,
          style: TextButton.styleFrom(foregroundColor: context.danger),
          icon: const Icon(Icons.cancel_outlined),
          label: const Text("Refuser le dépôt"),
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
    final scheme = Theme.of(context).colorScheme;
    final item = ticket.wasteAnalysisResult.detectedItem;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel("Déposant"),
                    const SizedBox(height: 6),
                    Text(
                      Formatters.userLabel(ticket.userId),
                      style: AppTextStyles.heading(20),
                    ),
                    Text(
                      "Dépôt ID : ${Formatters.shortCode(ticket.code)}",
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Pill(
                label: item.itemMainCategory,
                color: context.primaryText,
                background: context.primarySoft,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.eco_outlined, size: 18, color: context.primaryText),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.itemLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                "IA ${Formatters.percent(item.itemconfidenceScore)}",
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
        const Spacer(),
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
    final diff = measured - estimated;
    final color = deviated ? context.warning : context.primaryText;
    final limit = Formatters.percent(TicketValidationPolicy.maxWeightDeviation);
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
            deviated
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Écart : ${diff >= 0 ? '+' : '−'}'
              "${Formatters.kg(diff.abs())} kg "
              '${deviated ? '(> $limit, à justifier)' : '(OK, ≤ $limit)'}',
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
