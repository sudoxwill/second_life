import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../domain/entities/citizen_stats.dart";
import "../../domain/entities/recycling_ticket.dart";
import "../providers/user_tickets_provider.dart";

// Onglet "Accueil" de l'usager.
class CitizenHomePage extends ConsumerWidget {
  const CitizenHomePage({
    required this.onScan,
    required this.onOpenMap,
    required this.onOpenHistory,
    super.key,
  });
  // Deux boutons côte à côte : texte plus petit pour tenir sur une ligne.
  static const _actionText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  final VoidCallback onScan;
  final VoidCallback onOpenMap;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(userTicketsProvider);
    final stats = ref.watch(citizenStatsProvider);
    final refresh = ref.read(userTicketsProvider.notifier).refresh;

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
        children: [
          const _Greeting(),
          const SizedBox(height: 18),
          if (stats case AsyncError(:final error))
            ErrorCard(error: error, onRetry: refresh)
          else ...[
            _PointsCard(stats: stats.value),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(textStyle: _actionText),
                    onPressed: onScan,
                    icon: const Icon(Icons.photo_camera_outlined, size: 20),
                    label: const _OneLine("Scanner un déchet"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(textStyle: _actionText),
                    onPressed: onOpenMap,
                    icon: const Icon(Icons.place_outlined, size: 20),
                    label: const _OneLine("Voir la carte"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _PendingCard(
              pending: [
                for (final t in tickets.value ?? <RecyclingTicket>[])
                  if (t.canBeProcessed) t,
              ],
              onTap: onOpenHistory,
            ),
            const SizedBox(height: 14),
            _ImpactCard(stats: stats.value),
          ],
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconTile(
          icon: Icons.eco_rounded,
          color: Colors.white,
          background: AppColors.primary,
          size: 48,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bonjour 👋", style: AppTextStyles.heading(22)),
              const SizedBox(height: 2),
              Text(
                "Ensemble pour un avenir plus propre !",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Échange de points : pas encore de back-end.
class _ComingSoonChip extends StatelessWidget {
  const _ComingSoonChip({
    required this.label,
    required this.icon,
    this.onDark = false,
  });
  final String label;
  final IconData icon;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = onDark ? Colors.white : context.primaryText;
    return Material(
      color: onDark
          ? Colors.white.withValues(alpha: 0.15)
          : context.primarySoft,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => showAppSnackBar(context, "$label : bientôt disponible."),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({required this.stats});
  final CitizenStats? stats;

  @override
  Widget build(BuildContext context) {
    final white70 = Colors.white.withValues(alpha: 0.75);
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.grassCourt, AppColors.primaryPressed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg + 4),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: Icon(
              Icons.eco_rounded,
              size: 150,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "SOLDE DE POINTS",
                      style: TextStyle(
                        color: white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Spacer(),
                    const _ComingSoonChip(
                      label: "Échanger",
                      icon: Icons.redeem_outlined,
                      onDark: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (stats == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    ),
                  )
                else
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: Formatters.points(stats!.pointsBalance),
                          style: AppTextStyles.heading(40, color: Colors.white),
                        ),
                        TextSpan(
                          text: "  pts",
                          style: TextStyle(
                            color: white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (stats != null && stats!.pendingPoints > 0) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.warning.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: context.warning.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: Color(0xFFFFD08A),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "+${Formatters.points(stats!.pendingPoints)} pts "
                          "en attente de validation",
                          style: const TextStyle(
                            color: Color(0xFFFFD08A),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  "Non convertible en argent liquide · Échangeable contre "
                  "riz, huile, santé & scolarité.",
                  style: TextStyle(
                    color: white70,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
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

class _PendingCard extends StatelessWidget {
  const _PendingCard({required this.pending, required this.onTap});
  final List<RecyclingTicket> pending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconTile(
                icon: Icons.schedule_rounded,
                color: context.warning,
                background: context.warningSoft,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Dépôts en attente",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Pill(
                          label: "${pending.length}",
                          color: context.onWarning,
                          background: context.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pending.isEmpty
                          ? "Aucun dépôt à présenter à un agent"
                          : "Vos dépôts sont en cours de validation",
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
          if (pending.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in pending.take(4)) _PendingChip(ticket: t),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingChip extends StatelessWidget {
  const _PendingChip({required this.ticket});
  final RecyclingTicket ticket;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final analysis = ticket.wasteAnalysisResult;
    final estimatedPoints = Formatters.points(
      analysis.itemRecyclability.pointsEarned,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: analysis.detectedItem.itemLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: "  +$estimatedPoints pts",
              style: TextStyle(
                color: context.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.stats});
  final CitizenStats? stats;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SectionLabel("Mon impact écologique")),
              Pill(
                label: "Ville Propre 🌿",
                color: context.primaryText,
                background: context.primarySoft,
              ),
            ],
          ),
          const SizedBox(height: 18),
          IntrinsicHeight(
            child: Row(
              children: [
                _ImpactValue(
                  value: stats == null
                      ? "–"
                      : "${Formatters.kg(stats!.recycledWeightGrams)} kg",
                  label: "recyclés",
                ),
                const VerticalDivider(),
                _ImpactValue(
                  value: stats == null ? "–" : "${stats!.validatedCount}",
                  label: "dépôts",
                ),
                const VerticalDivider(),
                // Pas encore de boutique : aucune récompense échangée.
                _ImpactValue(
                  value: stats == null ? "–" : "0",
                  label: "récompenses",
                  highlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactValue extends StatelessWidget {
  const _ImpactValue({
    required this.value,
    required this.label,
    this.highlight = false,
  });
  final String value;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.heading(
              20,
              color: highlight ? context.primaryText : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// Libellé de bouton gardé sur une ligne : réduit si la police du
// téléphone est agrandie.
class _OneLine extends StatelessWidget {
  const _OneLine(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(fit: BoxFit.scaleDown, child: Text(text, maxLines: 1));
  }
}
