import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../core/utils/formatters.dart";
import "../../../../shared/presentation/widgets/buttons/app_outlined_button.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../auth/presentation/providers/auth_provider.dart";

// Demande confirmation, déconnecte puis renvoie vers la connexion.
Future<void> confirmLogout(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(LucideIcons.logOut, color: context.colorScheme.error),
      title: Text(l10n.authLogoutConfirmTitle),
      content: Text(l10n.authLogoutConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.authLogoutButton),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await ref.read(authProvider.notifier).signOut();
  if (!context.mounted) return;
  context.goAuthLogin();
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = context.colorScheme.error;
    return AppOutlinedButton(
      onPressed: () => confirmLogout(context, ref),
      text: context.l10n.authLogout,
      textColor: error,
      borderColor: error.withValues(alpha: 0.5),
      icon: Icon(LucideIcons.logOut, size: AppSpacing.iconMd, color: error),
    );
  }
}

// En-tête des profils : avatar à initiales, nom, sous-titre et contenu
// facultatif (statistiques) sous un séparateur.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    required this.name,
    super.key,
    this.subtitle,
    this.subtitleIcon,
    this.footer,
  });

  final String name;
  final String? subtitle;
  final IconData? subtitleIcon;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return BrandCard(
      child: Column(
        children: [
          Row(
            spacing: AppSpacing.md,
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.supernova.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.supernova,
                  child: Text(
                    Formatters.initials(name),
                    style: textTheme.titleLarge!.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: BrandCard.foreground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Row(
                        spacing: AppSpacing.xs,
                        children: [
                          if (subtitleIcon != null)
                            Icon(
                              subtitleIcon,
                              size: AppSpacing.iconSm,
                              color: BrandCard.foregroundMuted,
                            ),
                          Expanded(
                            child: Text(
                              subtitle!,
                              style: textTheme.bodyMedium!.copyWith(
                                color: BrandCard.foregroundMuted,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (footer != null) ...[
            Divider(
              height: AppSpacing.xxxl,
              color: BrandCard.foreground.withValues(alpha: 0.15),
            ),
            footer!,
          ],
        ],
      ),
    );
  }
}
