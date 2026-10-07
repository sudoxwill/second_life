import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/errors/failure_message.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/scan_widgets.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../../domain/entities/waste_analysis_result.dart";
import "../providers/user_tickets_provider.dart";
import "../providers/waste_analysis_providers.dart";
import "../providers/waste_analysis_result_provider.dart";
import "../widgets/ticket_qr_card.dart";
import "waste_scan_page.dart";

// Analyse de la photo par l'IA, puis enregistrement du dépôt (ticket) et
// affichage de son QR code.
class AnalysisResultPage extends ConsumerStatefulWidget {
  const AnalysisResultPage({required this.image, super.key});
  final File image;

  @override
  ConsumerState<AnalysisResultPage> createState() => _AnalysisResultPageState();
}

class _AnalysisResultPageState extends ConsumerState<AnalysisResultPage> {
  bool _submitting = false;
  RecyclingTicket? _ticket;

  @override
  void initState() {
    super.initState();
    Future.microtask(_analyze);
  }

  void _analyze() {
    ref
        .read(wasteAnalysisResultProvider.notifier)
        .analyzeWastePhoto(widget.image);
  }

  Future<void> _submit(WasteAnalysisResult result) async {
    setState(() => _submitting = true);
    final either = await ref.read(submitWasteInfoProvider)(result);
    if (!mounted) return;
    setState(() => _submitting = false);

    either.fold(
      (failure) =>
          showAppSnackBar(context, failureMessage(failure), error: true),
      (ticket) {
        setState(() => _ticket = ticket);
        ref.invalidate(userTicketsProvider);
      },
    );
  }

  void _scanAgain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const WasteScanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final analysis = ref.watch(wasteAnalysisResultProvider);
    final result = analysis.value;

    return Scaffold(
      appBar: AppBar(title: const Text("Résultat de l’analyse IA")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _PhotoPreview(
            image: widget.image,
            result: analysis.isLoading ? null : result,
            analyzing: analysis.isLoading,
          ),
          const SizedBox(height: 16),
          switch (analysis) {
            AsyncLoading() => const _AnalyzingCard(),
            AsyncError(:final error) => ErrorCard(
              error: error,
              onRetry: _analyze,
            ),
            _ when result == null => const _AnalyzingCard(),
            _ => _ResultContent(
              result: result,
              ticket: _ticket,
              submitting: _submitting,
              onSubmit: () => _submit(result),
              onScanAgain: _scanAgain,
            ),
          },
        ],
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.image,
    required this.result,
    required this.analyzing,
  });
  final File image;
  final WasteAnalysisResult? result;
  final bool analyzing;

  @override
  Widget build(BuildContext context) {
    final item = result?.detectedItem;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(image, fit: BoxFit.cover),
            // Pendant l'analyse : photo voilée et balayée par la ligne.
            AnimatedOpacity(
              opacity: analyzing ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: Colors.black.withValues(alpha: 0.35)),
                  if (analyzing) const ScanLineOverlay(),
                  if (analyzing)
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: ScanChip(
                          icon: Icons.auto_awesome_rounded,
                          label: "Analyse IA en cours…",
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (item != null)
              Container(
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.scanFrame, width: 2),
                ),
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextSpan(text: "Détecté : ${item.itemLabel}"),
                            ],
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Confiance "
                        "${Formatters.percent(item.itemconfidenceScore)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "monospace",
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AnalyzingCard extends StatelessWidget {
  const _AnalyzingCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            "Analyse par l’IA en cours…",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            "Identification de la matière et estimation du poids",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultContent extends StatelessWidget {
  const _ResultContent({
    required this.result,
    required this.ticket,
    required this.submitting,
    required this.onSubmit,
    required this.onScanAgain,
  });
  final WasteAnalysisResult result;
  final RecyclingTicket? ticket;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final recyclable = result.itemRecyclability.isRecyclable;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AnalysisCard(result: result),
        if (recyclable &&
            (result.warnings.isNotEmpty ||
                result.itemRecyclability.sortingInstructions.isNotEmpty)) ...[
          const SizedBox(height: 14),
          _NoticeCard(
            color: context.primaryText,
            background: context.primarySoft,
            icon: Icons.lightbulb_outline_rounded,
            children: [
              const Text(
                "Conseils de tri",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              if (result.itemRecyclability.sortingInstructions.isNotEmpty)
                Text(result.itemRecyclability.sortingInstructions),
              for (final w in result.warnings) Text(w),
            ],
          ),
        ],
        const SizedBox(height: 14),
        if (!recyclable)
          _NoticeCard(
            color: context.danger,
            background: context.dangerSoft,
            icon: Icons.block_rounded,
            children: [
              const Text(
                "Ce déchet n’est pas accepté en point relais.",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              if (result.itemRecyclability.sortingInstructions.isNotEmpty)
                Text(result.itemRecyclability.sortingInstructions),
            ],
          )
        else ...[
          _QrSection(ticket: ticket),
          const SizedBox(height: 14),
          _NoticeCard(
            color: context.warning,
            background: context.warningSoft,
            icon: Icons.info_outline_rounded,
            children: const [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Important : ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text:
                          "les points seront crédités après la pesée réelle "
                          "par un agent relais. Le calcul final s’effectue "
                          "sur le poids réel.",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (ticket == null)
            FilledButton.icon(
              onPressed: submitting ? null : onSubmit,
              icon: submitting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded),
              label: const Text("Enregistrer le dépôt"),
            )
          else
            _NoticeCard(
              color: context.primaryText,
              background: context.primarySoft,
              icon: Icons.check_circle_outline_rounded,
              children: [
                Text(
                  "Dépôt ${Formatters.shortCode(ticket!.code)} enregistré "
                  "dans votre historique",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
        ],
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: onScanAgain,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text("Scanner un autre déchet"),
        ),
      ],
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.result});
  final WasteAnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final item = result.detectedItem;
    final recyclability = result.itemRecyclability;
    final estimatedKg = Formatters.kg(result.itemWeight.estimatedWeight);
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
                    Pill(
                      label: item.itemMainCategory,
                      color: context.primaryText,
                      background: context.primarySoft,
                    ),
                    const SizedBox(height: 10),
                    Text(item.itemLabel, style: AppTextStyles.heading(22)),
                    if (item.itemsubCategory.isNotEmpty &&
                        item.itemsubCategory != "Autre")
                      Text(
                        item.itemsubCategory,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: context.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: context.primaryText.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "≈ ${Formatters.points(recyclability.pointsEarned)}",
                      style: AppTextStyles.heading(
                        20,
                        color: context.primaryText,
                      ),
                    ),
                    Text(
                      "pts estimés",
                      style: TextStyle(
                        fontSize: 11,
                        color: context.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(Icons.scale_outlined, color: context.primaryText),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Poids estimé par l’IA : "),
                        TextSpan(
                          text: "~$estimatedKg kg",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                "Indice de reconnaissance IA",
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
              ),
              const Spacer(),
              Text(
                "Confiance "
                "${Formatters.percent(item.itemconfidenceScore)}",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: context.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: item.itemconfidenceScore.clamp(0, 1),
              minHeight: 8,
              color: context.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _QrSection extends StatelessWidget {
  const _QrSection({required this.ticket});
  final RecyclingTicket? ticket;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_2_rounded, color: context.primaryText),
              const SizedBox(width: 8),
              const Flexible(
                child: Text(
                  "QR Code du dépôt à présenter à l’agent",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TicketQrCard(
            data: ticket?.qrData,
            caption: ticket == null
                ? "ID : GÉNÉRATION AU DÉPÔT"
                : "ID : ${Formatters.shortCode(ticket!.code)}",
          ),
          const SizedBox(height: 12),
          Text(
            "Présentez ce QR code à l’agent d’un point relais pour procéder "
            "à la pesée certifiée.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.color,
    required this.background,
    required this.icon,
    required this.children,
  });
  final Color color;
  final Color background;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: DefaultTextStyle.merge(
              style: TextStyle(color: color, fontSize: 13, height: 1.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
