import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../waste_analysis/domain/entities/relay_agent.dart";
import "../providers/current_relay_agent_provider.dart";

// Charge l'agent relais courant avant d'afficher une page de l'espace agent.
class RelayAgentBuilder extends ConsumerWidget {
  const RelayAgentBuilder({required this.builder, super.key});
  final Widget Function(BuildContext context, RelayAgent agent) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agent = ref.watch(currentRelayAgentProvider);
    return agent.when(
      data: (agent) => builder(context, agent),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ErrorCard(
            error: error,
            onRetry: () => ref.invalidate(currentRelayAgentProvider),
          ),
        ),
      ),
    );
  }
}
