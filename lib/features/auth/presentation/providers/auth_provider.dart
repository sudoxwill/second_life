import "package:cloud_firestore/cloud_firestore.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/core_providers.dart";

part "auth_provider.g.dart";

enum AppRole { user, agent }

// Auth temporaire pour les tests : connexion anonyme Firebase, le rôle est
// choisi par l'écran de connexion. À remplacer par la vraie auth.
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AppRole? build() => null;

  Future<void> signIn(AppRole role) async {
    final auth = ref.read(firebaseAuthProvider);
    // On garde le même compte anonyme d'une session à l'autre, sinon
    // l'historique des tickets serait perdu à chaque connexion.
    final user = auth.currentUser ?? (await auth.signInAnonymously()).user!;

    if (role == AppRole.agent) {
      // Sans fiche dans relay_agents, l'espace agent refuse l'accès.
      await ref
          .read(firebaseFirestoreProvider)
          .collection("relay_agents")
          .doc(user.uid)
          .set({
            "displayName": "Agent de test",
            "relayPointId": "relais-test",
            "relayPointName": "Point relais de test",
            "isActive": true,
          }, SetOptions(merge: true));
    }

    state = role;
  }

  // Ne déconnecte pas Firebase : un nouveau compte anonyme repartirait de zéro.
  void signOut() => state = null;
}
