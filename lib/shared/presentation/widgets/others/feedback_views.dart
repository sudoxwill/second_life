import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/errors/failure_message.dart";
import "../../../../core/theme/index.dart";
import "../../../../l10n/app_localizations.dart";
import "app_card.dart";

// Encadré d'erreur avec bouton "Réessayer".
class ErrorCard extends StatelessWidget {
  const ErrorCard({required this.error, super.key, this.onRetry});
  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: context.dangerSoft,
      borderColor: context.danger.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, color: context.danger),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failureMessage(AppLocalizations.of(context)!, error),
              style: TextStyle(
                color: context.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.commonRetry),
            ),
        ],
      ),
    );
  }
}

// Message centré quand une liste est vide.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    super.key,
    this.message,
  });
  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          IconTile(
            icon: icon,
            color: context.primaryText,
            background: context.primarySoft,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          if (message != null) ...[
            const SizedBox(height: 6),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

void showAppSnackBar(
  BuildContext context,
  String message, {
  bool error = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? context.danger : null,
      ),
    );
}
