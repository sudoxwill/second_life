import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/theme/index.dart";
import "../../providers/theme_provider.dart";
import "app_card.dart";

// Section "Paramètres" des profils : mode sombre.
class SettingsCard extends ConsumerWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appThemeModeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: SectionLabel("Paramètres"),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
            child: Row(
              children: [
                IconTile(
                  icon: dark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  color: context.warning,
                  background: context.warningSoft,
                  size: 36,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            "Mode sombre (Nuit)",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Pill(
                            label: dark ? "Activé" : "Désactivé",
                            color: dark
                                ? context.primaryText
                                : scheme.onSurfaceVariant,
                            background: dark
                                ? context.primarySoft
                                : scheme.surfaceContainerLow,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Confort visuel pour les usages en soirée "
                        "ou en intérieur",
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: dark,
                  onChanged: (value) =>
                      ref.read(appThemeModeProvider.notifier).theme = value
                      ? ThemeMode.dark
                      : ThemeMode.light,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
