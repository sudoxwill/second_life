import "package:firebase_auth/firebase_auth.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../core/errors/failure.dart";
import "../../../../shared/presentation/providers/core_providers.dart";
import "../../../ticket_validation/presentation/providers/current_relay_agent_provider.dart";

part "auth_provider.g.dart";

enum AppRole { user, agent }

// Connexion anonyme Firebase en attendant la vraie auth. Le rôle vient de
// relay_agents : une fiche active pour l'uid fait de l'utilisateur un agent.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AppRole? build() => null;

  Future<AppRole> signIn() async {
    await _ensureSignedIn(ref.read(firebaseAuthProvider));

    // La fiche agent a pu changer depuis la dernière connexion.
    ref.invalidate(currentRelayAgentProvider);
    try {
      await ref.read(currentRelayAgentProvider.future);
      state = AppRole.agent;
    } on NotRelayAgentFailure {
      state = AppRole.user;
    }
    return state!;
  }

  // On garde le même compte anonyme d'une session à l'autre, sinon
  // l'historique des tickets serait perdu à chaque connexion.
  Future<void> _ensureSignedIn(FirebaseAuth auth) async {
    final user = auth.currentUser;
    if (user != null) {
      try {
        // Le compte en cache a pu être supprimé ou désactivé dans la console :
        // son jeton ne se renouvelle plus et Firestore attend indéfiniment.
        await user.reload();
        return;
      } on FirebaseAuthException catch (e) {
        if (e.code == "network-request-failed") rethrow;
        await auth.signOut();
      }
    }
    await auth.signInAnonymously();
  }

  // Ne déconnecte pas Firebase : un nouveau compte anonyme repartirait de zéro.
  void signOut() {
    ref.invalidate(currentRelayAgentProvider);
    state = null;
  }
}
