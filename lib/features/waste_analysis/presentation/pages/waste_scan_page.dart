import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/index.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../../domain/entities/detected_material.dart";
import "../../domain/entities/waste_analysis_result.dart";
import "../providers/waste_analysis_provider.dart";
import "../providers/waste_analysis_state.dart";

/// Écran principal de scan et d'analyse visuelle de déchets par RodiumAI.
class WasteScanPage extends ConsumerStatefulWidget {
  const WasteScanPage({super.key});

  @override
  ConsumerState<WasteScanPage> createState() => _WasteScanPageState();
}

class _WasteScanPageState extends ConsumerState<WasteScanPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wasteAnalysisNotifierProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      appBar: AppBar(
        title: const Text("Analyser un déchet"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.popScreen(),
        ),
      ),
      scrollable: true,
      body: switch (state) {
        WasteAnalysisInitial() => _buildScannerView(context, colorScheme),
        WasteAnalysisLoading() => _buildLoadingView(context, colorScheme),
        WasteAnalysisSuccess(:final result) => _buildResultView(
            context,
            colorScheme,
            result,
          ),
        WasteAnalysisFailure(:final errorMessage) => _buildErrorView(
            context,
            colorScheme,
            errorMessage,
          ),
      },
    );
  }

  /// Vue du viseur de scan initial.
  Widget _buildScannerView(BuildContext context, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppSpacing.gapVMd,
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.5),
              width: AppSpacing.borderWidthSm,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.scanLine,
                size: 72,
                color: colorScheme.primary,
              ),
              AppSpacing.gapVSm,
              Text(
                "Placez le déchet dans le cadre",
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapVXs,
              Text(
                "L'IA identifiera le matériau et son éligibilité",
                style: context.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        AppSpacing.gapVLg,
        AppElevatedButton(
          text: "Prendre une photo",
          icon: const Icon(LucideIcons.camera, size: 20),
          onPressed: () => _triggerAnalysis(context),
        ),
        AppSpacing.gapVSm,
        AppOutlinedButton(
          text: "Simuler un scan test",
          icon: const Icon(LucideIcons.sparkles, size: 20),
          onPressed: () => _triggerAnalysis(context),
        ),
        AppSpacing.gapVMd,
      ],
    );
  }

  /// Vue pendant l'analyse IA.
  Widget _buildLoadingView(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 3,
            ),
            AppSpacing.gapVLg,
            Text(
              "Analyse RodiumAI en cours...",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapVXs,
            Text(
              "Reconnaissance des matériaux et estimation du poids",
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Vue du résultat d'analyse.
  Widget _buildResultView(
    BuildContext context,
    ColorScheme colorScheme,
    WasteAnalysisResult result,
  ) {
    final isAccepted = result.isAccepted;
    final primaryMaterial = result.primaryMaterial;
    final statusColor = isAccepted ? colorScheme.primary : colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge de statut d'acceptation
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: statusColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              Icon(
                isAccepted
                    ? LucideIcons.circleCheck
                    : LucideIcons.circleAlert,
                color: statusColor,
                size: 28,
              ),
              AppSpacing.gapHSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAccepted
                          ? "Déchet accepté en point relais"
                          : "Déchet non accepté",
                      style: context.textTheme.titleSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (result.rejectionReason != null) ...[
                      AppSpacing.gapVXs,
                      Text(
                        result.rejectionReason!,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapVMd,

        // Carte des détails du déchet
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Matériau détecté",
                  style: context.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapVXs,
                Row(
                  children: [
                    Icon(
                      _getCategoryIcon(primaryMaterial?.category),
                      color: colorScheme.primary,
                      size: 22,
                    ),
                    AppSpacing.gapHXs,
                    Expanded(
                      child: Text(
                        primaryMaterial?.name ?? "Déchet identifiable",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (primaryMaterial != null)
                      Chip(
                        label: Text(
                          "${(primaryMaterial.confidence * 100).toInt()}%",
                          style: context.textTheme.labelSmall,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetricColumn(
                      context,
                      label: "Poids estimé",
                      value: "${result.estimatedWeightKg} kg",
                    ),
                    _buildMetricColumn(
                      context,
                      label: "Quantité",
                      value: "${result.estimatedQuantity} unité(s)",
                    ),
                    _buildMetricColumn(
                      context,
                      label: "Points estimés",
                      value: "+${result.estimatedPoints} pts",
                      highlight: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapVMd,

        // Conseils de préparation
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                LucideIcons.lightbulb,
                color: colorScheme.primary,
                size: 20,
              ),
              AppSpacing.gapHSm,
              Expanded(
                child: Text(
                  result.preparationAdvice,
                  style: context.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapVLg,

        // Boutons d'action
        if (isAccepted)
          AppElevatedButton(
            text: "Enregistrer le dépôt",
            icon: const Icon(LucideIcons.qrCode, size: 20),
            onPressed: () {
              context.showSnackBar("Dépôt enregistré avec succès !");
            },
          ),
        AppSpacing.gapVSm,
        AppOutlinedButton(
          text: "Scanner un autre déchet",
          icon: const Icon(LucideIcons.refreshCw, size: 18),
          onPressed: () {
            ref.read(wasteAnalysisNotifierProvider.notifier).reset();
          },
        ),
      ],
    );
  }

  /// Vue en cas d'erreur.
  Widget _buildErrorView(
    BuildContext context,
    ColorScheme colorScheme,
    String errorMessage,
  ) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.circleAlert,
              size: 56,
              color: colorScheme.error,
            ),
            AppSpacing.gapVMd,
            Text(
              "Erreur d'analyse",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapVXs,
            Text(
              errorMessage,
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapVLg,
            AppElevatedButton(
              text: "Réessayer",
              icon: const Icon(LucideIcons.refreshCw, size: 18),
              onPressed: () {
                ref.read(wasteAnalysisNotifierProvider.notifier).reset();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(
    BuildContext context, {
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapVXs,
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight ? colorScheme.primary : null,
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(WasteCategory? category) {
    return switch (category) {
      WasteCategory.plasticPet ||
      WasteCategory.plasticPeHd =>
        LucideIcons.sparkles,
      WasteCategory.metalAluminum ||
      WasteCategory.metalIron =>
        LucideIcons.hammer,
      WasteCategory.glass => LucideIcons.wine,
      WasteCategory.cardboard => LucideIcons.package,
      WasteCategory.electronic => LucideIcons.cpu,
      _ => LucideIcons.recycle,
    };
  }

  void _triggerAnalysis(BuildContext context) {
    // Déclenche l'analyse via le provider
    final sampleBytes = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0]);
    ref
        .read(wasteAnalysisNotifierProvider.notifier)
        .analyzeImageBytes(sampleBytes);
  }
}
