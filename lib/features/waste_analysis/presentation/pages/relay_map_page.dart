import "package:flutter/material.dart";

import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";

// Onglet "Carte". Les points relais ne sont pas encore stockés dans
// Firestore : écran d'attente en attendant la carte.
class RelayMapPage extends StatelessWidget {
  const RelayMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
      children: [
        const PageHeader(
          title: "Points relais",
          subtitle: Text("Déposez vos déchets triés auprès d’un agent."),
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Column(
            children: [
              const EmptyState(
                icon: Icons.map_outlined,
                title: "La carte arrive bientôt",
                message:
                    "Vous pourrez bientôt trouver le point relais le plus "
                    "proche et ses horaires de permanence.",
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: context.primaryText,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "En attendant, présentez le QR code de votre dépôt "
                        "à n’importe quel agent relais.",
                        style: TextStyle(fontSize: 13, color: scheme.onSurface),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
