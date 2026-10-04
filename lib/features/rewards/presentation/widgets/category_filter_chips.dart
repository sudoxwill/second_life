import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../domain/entities/reward_category.dart";

/// Barre de filtres horizontaux par catégorie de récompense.
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final RewardCategory selectedCategory;
  final ValueChanged<RewardCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: RewardCategory.values.map((cat) {
          final isSelected = selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              avatar: Icon(
                cat.icon,
                size: 16,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              label: Text(cat.label),
              selected: isSelected,
              onSelected: (_) => onSelected(cat),
              showCheckmark: false,
              backgroundColor: colorScheme.surfaceContainer,
              selectedColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.roundedFull,
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
              ),
              labelStyle: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
