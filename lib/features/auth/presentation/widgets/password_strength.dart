import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";

// Jauge de robustesse sous le mot de passe : indicative, la seule règle
// bloquante reste les 8 caractères minimum.
class PasswordStrength extends StatelessWidget {
  const PasswordStrength({required this.password, super.key});

  final String password;

  // 0 à 4 : longueur, chiffres, majuscules + minuscules, symboles.
  static int score(String p) {
    if (p.isEmpty) return 0;
    var s = 0;
    if (p.length >= 8) s++;
    if (p.length >= 12) s++;
    if (RegExp("[0-9]").hasMatch(p)) s++;
    if (RegExp("[a-z]").hasMatch(p) && RegExp("[A-Z]").hasMatch(p)) s++;
    if (RegExp("[^a-zA-Z0-9]").hasMatch(p)) s++;
    return s.clamp(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = score(password);
    final (color, label) = switch (s) {
      <= 1 => (context.danger, l10n.authPasswordStrengthWeak),
      2 => (context.warning, l10n.authPasswordStrengthMedium),
      _ => (context.primaryText, l10n.authPasswordStrengthStrong),
    };
    return AnimatedSize(
      duration: AppSpacing.durationFast,
      child: password.isEmpty
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  for (var i = 0; i < 4; i++)
                    Expanded(
                      child: AnimatedContainer(
                        duration: AppSpacing.durationFast,
                        height: 4,
                        decoration: BoxDecoration(
                          color: i < s
                              ? color
                              : context.colorScheme.outlineVariant,
                          borderRadius: AppSpacing.roundedFull,
                        ),
                      ),
                    ),
                  Text(
                    label,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
