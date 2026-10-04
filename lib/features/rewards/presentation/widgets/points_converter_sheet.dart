import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../domain/entities/points_conversion.dart";

/// Feuille modale interactive de simulation et de conversion de points.
class PointsConverterSheet extends StatefulWidget {
  const PointsConverterSheet({this.initialPoints = 100, super.key});

  final int initialPoints;

  /// Ouvre la modale de conversion.
  static Future<void> show(BuildContext context, {int initialPoints = 100}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PointsConverterSheet(initialPoints: initialPoints),
    );
  }

  @override
  State<PointsConverterSheet> createState() => _PointsConverterSheetState();
}

class _PointsConverterSheetState extends State<PointsConverterSheet> {
  late int _points;
  late final TextEditingController _controller;

  static const List<int> _presets = [100, 200, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    _points = widget.initialPoints > 0 ? widget.initialPoints : 100;
    _controller = TextEditingController(text: _points.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointsChanged(String value) {
    final parsed = int.tryParse(value) ?? 0;
    setState(() {
      _points = parsed;
    });
  }

  void _selectPreset(int value) {
    setState(() {
      _points = value;
      _controller.text = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final fcfaValue = PointsConversion.toFcfa(_points);

    return Container(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.viewInsetsOf(context).bottom +
            AppSpacing.bottomSheetPadding.bottom,
        left: AppSpacing.bottomSheetPadding.left,
        right: AppSpacing.bottomSheetPadding.right,
        top: AppSpacing.bottomSheetPadding.top,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppSpacing.roundedTopLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barre de tirage
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: AppSpacing.roundedFull,
              ),
            ),
          ),
          AppSpacing.gapVLg,

          // Titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs + 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.2),
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Icon(
                  LucideIcons.arrowRightLeft,
                  color: colorScheme.secondary,
                  size: 20,
                ),
              ),
              AppSpacing.gapHMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Simulateur de conversion",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Taux fixe : 1 point = 5 FCFA",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVXl,

          // Champ de saisie des points
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: AppSpacing.roundedMd,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Points SecondLife",
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapVXs,
                Row(
                  children: [
                    Icon(
                      LucideIcons.coins,
                      size: 20,
                      color: colorScheme.secondary,
                    ),
                    AppSpacing.gapHSm,
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        onChanged: _onPointsChanged,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: "0",
                        ),
                      ),
                    ),
                    Text(
                      "pts",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapVMd,

          // Raccourcis de sélection rapide (Presets)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presets.map((val) {
                final isSelected = _points == val;
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: Text("+$val pts"),
                    selected: isSelected,
                    onSelected: (_) => _selectPreset(val),
                    selectedColor: colorScheme.secondary.withValues(
                      alpha: 0.25,
                    ),
                    checkmarkColor: colorScheme.onSurface,
                    labelStyle: textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          AppSpacing.gapVLg,

          // Carte résultat
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.08),
                  colorScheme.secondary.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: AppSpacing.roundedLg,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Valeur de rachat",
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.gapVXs,
                    Text(
                      PointsConversion.formatFcfa(fcfaValue),
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.banknote,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapVXl,

          // Bouton fermer
          AppElevatedButton(
            text: "Compris",
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
