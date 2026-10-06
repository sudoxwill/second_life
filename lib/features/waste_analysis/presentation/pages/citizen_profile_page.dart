import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/app_shell.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/settings_card.dart";

// Onglet "Profil" de l'usager.
class CitizenProfilePage extends ConsumerWidget {
  const CitizenProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    final scheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, kShellBottomPadding),
      children: [
        AppCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Mon compte", style: AppTextStyles.heading(20)),
                    const SizedBox(height: 6),
                    Pill(
                      label: "Compte invité",
                      color: context.primaryText,
                      background: context.primarySoft,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          onTap: uid.isEmpty
              ? null
              : () {
                  Clipboard.setData(ClipboardData(text: uid));
                  showAppSnackBar(context, "Identifiant copié.");
                },
          child: Row(
            children: [
              IconTile(
                icon: Icons.badge_outlined,
                color: context.primaryText,
                background: context.primarySoft,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Identifiant",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      uid.isEmpty ? "Non connecté" : uid,
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
                Icons.copy_rounded,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const SettingsCard(),
      ],
    );
  }
}
