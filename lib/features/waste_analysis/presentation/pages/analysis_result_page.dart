import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/errors/failure_message.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
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
      (failure) => showAppSnackBar(
        context,
        failureMessage(context.l10n, failure),
        error: true,
      ),
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
    final l10n = context.l10n;
    final analysis = ref.watch(wasteAnalysisResultProvider);
    final result = analysis.value;

    return AppScaffold(
      appBar: AppBar(title: Text(l10n.analysisResultTitle)),
      body: ListView(
        children: [
          _PhotoPreview(
            image: widget.image,
            result: analysis.isLoading ? null : result,
            analyzing: analysis.isLoading,
          ),
          AppSpacing.gapVLg,
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
    final l10n = context.l10n;
    final item = result?.detectedItem;
    return ClipRRect(
      borderRadius: AppSpacing.roundedLg,
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(image, fit: BoxFit.cover),
            AnimatedOpacity(
              opacity: analyzing ? 1 : 0,
              duration: AppSpacing.durationBase,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ColoredBox(color: Colors.black.withValues(alpha: 0.35)),
                  if (analyzing) const ScanLineOverlay(),
                  if (analyzing)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.radiusLg,
                        ),
                        child: ScanChip(
                          icon: LucideIcons.sparkles,
                          label: l10n.analysisAnalyzingTitle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (item != null)
              Container(
                margin: AppSpacing.insetLg,
                decoration: BoxDecoration(
                  borderRadius: AppSpacing.roundedLg,
                  border: Border.all(
                    color: AppColors.scanFrame,
                    width: AppSpacing.borderWidthThick,
                  ),
                ),
                alignment: Alignment.topLeft,
                padding: AppSpacing.insetSm,
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
                          borderRadius: AppSpacing.roundedSm,
                        ),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(
                                    LucideIcons.sparkles,
                                    size: AppSpacing.iconSm,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: l10n.analysisDetected(item.itemLabel),
                              ),
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
                    AppSpacing.gapHSm,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: AppSpacing.roundedSm,
                      ),
                      child: Text(
                        l10n.analysisConfidenceScore(
                          Formatters.percent(item.itemconfidenceScore),
                        ),
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
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.xl,
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          AppSpacing.gapVLg,
          Text(
            l10n.analysisAnalyzingTitle,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.gapVXs,
          Text(
            l10n.analysisAnalyzingSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge!.copyWith(
              color: colorScheme.onSurfaceVariant,
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
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final recyclable = result.itemRecyclability.isRecyclable;

    final tips = [
      if (result.itemRecyclability.sortingInstructions.isNotEmpty)
        result.itemRecyclability.sortingInstructions,
      ...result.warnings,
    ].join("\n\n");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AnalysisCard(result: result),
        if (recyclable && tips.isNotEmpty) ...[
          AppSpacing.gapVMd,
          _TipsCard(tips: tips),
        ],
        AppSpacing.gapVMd,
        if (!recyclable)
          _NoticeCard(
            color: context.danger,
            background: context.dangerSoft,
            icon: LucideIcons.ban,
            children: [
              Text(
                l10n.analysisNonRecyclable,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (result.itemRecyclability.sortingInstructions.isNotEmpty)
                Text(result.itemRecyclability.sortingInstructions),
            ],
          )
        else ...[
          _QrSection(ticket: ticket),
          AppSpacing.gapVMd,
          _NoticeCard(
            color: context.warning,
            background: context.warningSoft,
            icon: LucideIcons.badgeInfo,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: l10n.analysisImportantLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: l10n.analysisImportantBody),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVLg,
          if (ticket == null)
            AppElevatedButton(
              onPressed: onSubmit,
              icon: const Icon(LucideIcons.check),
              text: l10n.analysisSaveDeposit,
            )
          else
            _NoticeCard(
              color: context.primaryText,
              background: context.primarySoft,
              icon: LucideIcons.badgeCheck,
              children: [
                Text(
                  l10n.analysisDepositSaved(Formatters.shortCode(ticket!.code)),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
        ],
        AppSpacing.gapVMd,
        TextButton.icon(
          onPressed: onScanAgain,
          icon: const Icon(LucideIcons.rotateCcw),
          label: Text(
            l10n.analysisScanAgain,
            style: textTheme.titleMedium!.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
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
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
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
                    AppSpacing.gapVSm,
                    Text(
                      item.itemLabel,
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.itemsubCategory.isNotEmpty &&
                        item.itemsubCategory != "Autre")
                      Text(
                        item.itemsubCategory,
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              AppSpacing.gapHMd,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: context.primarySoft,
                  borderRadius: AppSpacing.roundedLg,
                  border: Border.all(
                    color: context.primaryText.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "≈ ${Formatters.points(recyclability.pointsEarned)}",
                      style: textTheme.titleLarge!.copyWith(
                        color: context.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.analysisEstimatedPoints,
                      style: textTheme.labelSmall!.copyWith(
                        color: context.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVLg,
          Container(
            padding: AppSpacing.insetLg,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: AppSpacing.roundedLg,
            ),
            child: Row(
              children: [
                Icon(LucideIcons.scale, color: context.primaryText),
                AppSpacing.gapHSm,
                Expanded(
                  child: Text(
                    l10n.analysisEstimatedWeight(estimatedKg),
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapVLg,
          Row(
            children: [
              Text(
                l10n.analysisConfidenceIndex,
                style: textTheme.labelLarge!.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                l10n.analysisConfidenceScore(
                  Formatters.percent(item.itemconfidenceScore),
                ),
                style: textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.primaryText,
                ),
              ),
            ],
          ),
          AppSpacing.gapVSm,
          ClipRRect(
            borderRadius: AppSpacing.roundedFull,
            child: LinearProgressIndicator(
              value: item.itemconfidenceScore.clamp(0, 1),
              minHeight: AppSpacing.sm,
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
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.qrCode),
              AppSpacing.gapHSm,
              Flexible(
                child: Text(
                  l10n.analysisQrTitle,
                  style: textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVMd,
          TicketQrCard(
            data: ticket?.qrData,
            caption: ticket == null
                ? l10n.analysisQrPlaceholder
                : l10n.analysisQrId(Formatters.shortCode(ticket!.code)),
          ),
          AppSpacing.gapVMd,
          Text(
            l10n.analysisQrCaption,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge!.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});
  final String tips;

  void _showFullTips(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final primaryText = context.primaryText;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: AppSpacing.bottomSheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.lightbulb, color: primaryText),
                AppSpacing.gapHSm,
                Text(l10n.analysisTipsTitle, style: textTheme.titleMedium),
              ],
            ),
            AppSpacing.gapVMd,
            Text(tips, style: textTheme.bodyMedium),
            AppSpacing.gapVXl,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: () => _showFullTips(context),
      child: Container(
        padding: AppSpacing.insetLg,
        decoration: BoxDecoration(
          color: context.primarySoft,
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(color: context.primaryText.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              LucideIcons.lightbulb,
              color: context.primaryText,
              size: AppSpacing.iconMd,
            ),
            AppSpacing.gapHSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    l10n.analysisTipsTitle,
                    style: TextStyle(
                      color: context.primaryText,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    tips,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.primaryText,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    l10n.analysisTipsSeeMore,
                    style: TextStyle(
                      color: context.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: context.primaryText,
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
    final textTheme = context.textTheme;
    return Container(
      padding: AppSpacing.insetLg,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          AppSpacing.gapHSm,
          Expanded(
            child: DefaultTextStyle.merge(
              style: textTheme.labelLarge!.copyWith(color: color, height: 1.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
