// import "package:flutter/material.dart";
// import "package:flutter_riverpod/flutter_riverpod.dart";
//
// import "../../../auth/presentation/providers/auth_provider.dart";
// import "../../../ticket_validation/presentation/widgets/relay_agent_builder.dart";
// import "agent_profile_page.dart";
// import "user_profile_page.dart";
//
// /// Onglet "Profil" : affiche l'écran de l'agent ou de l'usager selon le rôle.
// /// L'agent est chargé depuis relay_agents avant l'affichage.
// class ProfilePage extends ConsumerWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final role = ref.watch(authProvider);
//     return role == AppRole.agent
//         ? RelayAgentBuilder(
//             builder: (context, agent) => AgentProfilePage(agent: agent),
//           )
//         : const UserProfilePage();
//   }
// }
