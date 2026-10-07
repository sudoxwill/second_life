import "package:flutter/material.dart";

import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/theme/index.dart";
import "motion.dart";

// Carte blanche arrondie, utilisée sur tous les écrans.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.borderColor,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppSpacing.radiusLg);
    return PressScale(
      enabled: onTap != null,
      child: Material(
        color: color ?? scheme.surfaceContainer,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: borderColor ?? scheme.outlineVariant),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Carte en dégradé vert de la marque : solde, en-tête de profil, stock.
// Le texte posé dessus est clair dans les deux thèmes.
class BrandCard extends StatelessWidget {
  const BrandCard({
    required this.child,
    super.key,
    this.padding = AppSpacing.cardPadding,
    this.onTap,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  static const foreground = AppColors.springWhite;
  static Color get foregroundMuted => foreground.withValues(alpha: 0.75);

  @override
  Widget build(BuildContext context) {
    const radius = AppSpacing.roundedXl;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PressScale(
      enabled: onTap != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: const LinearGradient(
            colors: [AppColors.grassCourt, AppColors.jungleGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: dark
              ? AppSpacing.elevationShadowMdDark
              : AppSpacing.elevationShadowMd,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                children: [
                  // Feuille en filigrane dans le coin haut droit.
                  Positioned(
                    right: -24,
                    top: -24,
                    child: Icon(
                      LucideIcons.leaf,
                      size: 140,
                      color: foreground.withValues(alpha: 0.06),
                    ),
                  ),
                  Padding(
                    padding: padding,
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: foreground),
                      child: IconTheme.merge(
                        data: const IconThemeData(color: foreground),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Raccourci : icône teintée, titre, sous-titre et chevron.
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
    this.highlighted = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  // Action principale : fond teinté vert.
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.cardPaddingCompact,
      color: highlighted ? context.primarySoft : null,
      borderColor: highlighted
          ? context.primaryText.withValues(alpha: 0.25)
          : null,
      child: Row(
        children: [
          IconTile(
            icon: icon,
            color: highlighted ? scheme.onPrimary : context.primaryText,
            background: highlighted ? scheme.primary : context.primarySoft,
          ),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            LucideIcons.chevronRight,
            size: AppSpacing.iconMd,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

// Titre de section avec compteur facultatif et lien "Voir plus".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    super.key,
    this.count,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final int? count;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (count != null && count! > 0) ...[
          AppSpacing.gapHSm,
          AnimatedSwitcher(
            duration: AppSpacing.durationFast,
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Pill(
              key: ValueKey(count),
              label: "$count",
              color: context.onWarning,
              background: context.warning,
            ),
          ),
        ],
        const Spacer(),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, AppSpacing.tapTargetMin),
              padding: AppSpacing.insetHSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.xs,
              children: [
                Text(actionLabel!),
                const Icon(LucideIcons.arrowRight, size: AppSpacing.iconSm),
              ],
            ),
          ),
      ],
    );
  }
}

// Petit carré arrondi teinté contenant une icône.
class IconTile extends StatelessWidget {
  const IconTile({
    required this.icon,
    required this.color,
    required this.background,
    super.key,
    this.size = 44,
  });
  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

// Étiquette en pilule (statut, catégorie, points…).
class Pill extends StatelessWidget {
  const Pill({
    required this.label,
    required this.color,
    required this.background,
    super.key,
    this.icon,
    this.outlined = false,
  });
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
  // Contour de la couleur du texte (badges de statut).
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: outlined
            ? Border.all(color: color.withValues(alpha: 0.45))
            : null,
      ),
      // Text.rich plutôt qu'une Row : les libellés de l'IA peuvent être
      // longs et sont coupés si la largeur est limitée, sans imposer de
      // largeur bornée au parent.
      child: Text.rich(
        TextSpan(
          children: [
            if (icon != null)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(icon, size: 14, color: color),
                ),
              ),
            TextSpan(text: label),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Titre de section en petites capitales grises.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

// Titre + sous-titre en haut des écrans principaux.
class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });
  final String title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.heading(24)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  child: subtitle!,
                ),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

// Ligne "libellé ........ valeur" des fiches.
class DetailRow extends StatelessWidget {
  const DetailRow(this.label, this.value, {super.key, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Le libellé peut passer à la ligne, mais garde au moins 40 % de
          // la largeur : la valeur ne l'écrase pas.
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: valueColor ?? scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
