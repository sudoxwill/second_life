import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:mobile_scanner/mobile_scanner.dart";

import "../../../../core/errors/failure.dart";
import "../../../../core/errors/failure_message.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/scan_widgets.dart";
import "../../../waste_analysis/domain/entities/recycling_ticket.dart";
import "../../../waste_analysis/domain/entities/ticket_status.dart";
import "../providers/ticket_validation_provider.dart";
import "weighing_page.dart";

// Scan du QR code présenté par l'usager, puis aperçu du dépôt.
class AgentScannerPage extends ConsumerStatefulWidget {
  const AgentScannerPage({super.key});

  @override
  ConsumerState<AgentScannerPage> createState() => _AgentScannerPageState();
}

class _AgentScannerPageState extends ConsumerState<AgentScannerPage> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  // Contenu du QR en cours de traitement : le scan est mis en pause.
  String? _scanned;
  bool _notATicket = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(ref.read(ticketValidationProvider.notifier).clear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned != null) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null) continue;
      if (RecyclingTicket.codeFromInput(value) == null) {
        setState(() => _notATicket = true);
        continue;
      }
      setState(() {
        _scanned = value;
        _notATicket = false;
      });
      ref.read(ticketValidationProvider.notifier).loadTicket(value);
      return;
    }
  }

  void _scanAgain() {
    ref.read(ticketValidationProvider.notifier).clear();
    setState(() {
      _scanned = null;
      _notATicket = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(ticketValidationProvider);

    return Scaffold(
      backgroundColor: AppColors.scanBackground,
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    l10n.agentScanCameraUnavailable(error.errorCode.name),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          // Cadre centré : son voile assombrit tout autour, il doit donc
          // être peint avant l'en-tête et la fiche du dépôt.
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScanFrame(
                    size: 250,
                    dimOutside: true,
                    scanning: _scanned == null,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ScanHint(
                      _notATicket
                          ? l10n.errorInvalidTicketCode
                          : l10n.scanAgentHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      ScanRoundButton(
                        icon: LucideIcons.arrowLeft,
                        tooltip: l10n.commonBack,
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Flexible(
                        flex: 4,
                        child: ScanChip(
                          icon: LucideIcons.scanQrCode,
                          label: l10n.scanAgentChip,
                        ),
                      ),
                      const Spacer(),
                      ScanRoundButton(
                        icon: LucideIcons.flashlight,
                        tooltip: l10n.scanTorch,
                        onPressed: _controller.toggleTorch,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (_scanned != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: AnimatedSwitcher(
                      duration: AppSpacing.durationFast,
                      child: switch (state) {
                        AsyncData(value: final ticket?) => _DetectedCard(
                          ticket: ticket,
                          onWeigh: () =>
                              openWeighing(context, _scanned!, replace: true),
                          onScanAgain: _scanAgain,
                        ),
                        AsyncError(:final error) => _ErrorSheet(
                          error: error,
                          onScanAgain: _scanAgain,
                        ),
                        _ => const _LoadingSheet(),
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingSheet extends StatelessWidget {
  const _LoadingSheet();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(width: 14),
          Text(
            context.l10n.scanLoadingDeposit,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ErrorSheet extends StatelessWidget {
  const _ErrorSheet({required this.error, required this.onScanAgain});
  final Object error;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(LucideIcons.circleAlert, color: context.danger),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  failureMessage(l10n, error),
                  style: TextStyle(
                    color: context.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onScanAgain,
            icon: const Icon(LucideIcons.scanQrCode),
            label: Text(l10n.scanAnother),
          ),
        ],
      ),
    );
  }
}

class _DetectedCard extends StatelessWidget {
  const _DetectedCard({
    required this.ticket,
    required this.onWeigh,
    required this.onScanAgain,
  });
  final RecyclingTicket ticket;
  final VoidCallback onWeigh;
  final VoidCallback onScanAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final analysis = ticket.wasteAnalysisResult;
    final estimatedKg = Formatters.kg(analysis.itemWeight.estimatedWeight);
    final estimatedPoints = Formatters.points(
      analysis.itemRecyclability.pointsEarned,
    );
    if (!ticket.canBeProcessed) {
      return _ErrorSheet(
        error: ticket.status == TicketStatus.pending
            ? TicketExpiredFailure()
            : TicketAlreadyProcessedFailure(),
        onScanAgain: onScanAgain,
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Pill(
                      label: l10n.scanDetected,
                      icon: LucideIcons.circleCheck,
                      color: context.primaryText,
                      background: context.primarySoft,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.depositTitle(Formatters.shortCode(ticket.code)),
                      style: AppTextStyles.heading(20),
                    ),
                    Text(
                      l10n.agentHistoryDepositor +
                          Formatters.userLabel(l10n, ticket.userId),
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.depositMaterial,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      analysis.detectedItem.itemLabel,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: context.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: l10n.depositEstimatedWeight),
                        TextSpan(
                          text: "~$estimatedKg kg",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                Text(
                  l10n.depositEstimatedPoints(estimatedPoints),
                  style: TextStyle(
                    color: context.warning,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: onWeigh,
            iconAlignment: IconAlignment.end,
            icon: const Icon(LucideIcons.arrowRight),
            label: Text(l10n.scanOpenWeighing),
          ),
        ],
      ),
    );
  }
}
