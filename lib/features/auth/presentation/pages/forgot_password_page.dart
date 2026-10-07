import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../providers/auth_provider.dart";
import "../widgets/auth_layout.dart";

// Envoi du lien de réinitialisation Firebase. Le nouveau mot de passe se
// choisit ensuite sur la page web ouverte par le lien de l'email.
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  bool _isLoading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final l10n = context.l10n;
    try {
      await ref
          .read(authProvider.notifier)
          .sendPasswordResetEmail(_emailController.text.trim());
      if (mounted) setState(() => _sent = true);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      // Même réponse qu'en cas de succès : on ne révèle pas si un compte
      // existe pour cet email.
      if (e.code == "user-not-found") {
        setState(() => _sent = true);
        return;
      }
      context.showSnackBar(switch (e.code) {
        "invalid-email" => l10n.authErrorInvalidEmail,
        "too-many-requests" => l10n.authErrorTooManyRequests,
        "network-request-failed" => l10n.commonNetworkError,
        _ => l10n.authForgotError,
      });
    } catch (_) {
      if (mounted) context.showSnackBar(l10n.authForgotError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      showBack: true,
      illustration: AnimatedSwitcher(
        duration: AppSpacing.durationBase,
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: IconTile(
          key: ValueKey(_sent),
          icon: _sent ? LucideIcons.mailCheck : LucideIcons.keyRound,
          color: context.colorScheme.onPrimary,
          background: context.primaryText,
          size: 96,
        ),
      ),
      title: l10n.routerScreenForgotPassword,
      subtitle: _sent ? l10n.authForgotSent : l10n.authForgotSubtitle,
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: [
            AppTextFormField(
              isRequired: true,
              labelText: l10n.authEmailLabel,
              hintText: l10n.authEmailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              prefixIconData: LucideIcons.mail,
              controller: _emailController,
              onFieldSubmitted: (_) => _send(),
            ),
            AppElevatedButton(
              text: l10n.authForgotButton,
              isLoading: _isLoading,
              onPressed: _send,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      footer: _sent
          ? Center(
              child: TextButton.icon(
                onPressed: context.goAuthLogin,
                icon: const Icon(LucideIcons.logIn, size: AppSpacing.iconMd),
                label: Text(l10n.authLoginLink),
              ),
            )
          : null,
    );
  }
}
