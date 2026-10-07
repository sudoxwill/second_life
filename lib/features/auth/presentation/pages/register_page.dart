import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/errors/exception.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../providers/auth_provider.dart";
import "../widgets/auth_layout.dart";
import "../widgets/oauth_section.dart";
import "../widgets/password_strength.dart";

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      showBack: true,
      illustration: AppAssets.register,
      title: l10n.authSignupTitle,
      subtitle: l10n.authSignupSubtitle,
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: [
            AppTextFormField(
              isRequired: true,
              labelText: l10n.authUsernameLabel,
              hintText: l10n.authUsernameHint,
              textInputAction: TextInputAction.next,
              prefixIconData: LucideIcons.userRound,
              controller: _usernameController,
              validatorFunction: _validateUsername,
            ),
            AppTextFormField(
              isRequired: true,
              labelText: l10n.authEmailLabel,
              hintText: l10n.authEmailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIconData: LucideIcons.mail,
              controller: _emailController,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authPasswordLabel,
                  hintText: l10n.authPasswordHint,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  prefixIconData: LucideIcons.lockKeyhole,
                  suffixIconData: _obscurePassword
                      ? LucideIcons.eyeOff
                      : LucideIcons.eye,
                  suffixIconOnClick: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  controller: _passwordController,
                  validatorFunction: _validatePassword,
                  onChanged: (_) => setState(() {}),
                ),
                PasswordStrength(password: _passwordController.text),
              ],
            ),
            AppTextFormField(
              isRequired: true,
              labelText: l10n.authConfirmPasswordLabel,
              hintText: l10n.authPasswordHint,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              prefixIconData: LucideIcons.lockKeyhole,
              suffixIconData: _obscureConfirm
                  ? LucideIcons.eyeOff
                  : LucideIcons.eye,
              suffixIconOnClick: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
              controller: _confirmPasswordController,
              validatorFunction: _validateConfirmPassword,
              onFieldSubmitted: (_) => _signUp(),
            ),
            AppSpacing.gapVXs,
            AppElevatedButton(
              text: l10n.authSignupButton,
              isLoading: _isLoading,
              onPressed: _signUp,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      footer: Column(
        children: [
          OAuthSection(onGoogleSignIn: _isLoading ? null : _googleSignIn),
          AppSpacing.gapVSm,
          AuthSwitchLink(
            question: l10n.authAlreadyHaveAccount,
            action: l10n.authLoginLink,
            onTap: _isLoading ? null : context.goAuthLogin,
          ),
        ],
      ),
    );
  }

  String? _validateUsername(String? value) {
    final v = value?.trim() ?? "";
    final regex = RegExp(r"^[a-zA-Z0-9_]{3,20}$");
    if (!regex.hasMatch(v)) return context.l10n.validationUsernameInvalid;
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? "").length < 8) {
      return context.l10n.validationPasswordTooShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return context.l10n.validationPasswordsDoNotMatch;
    }
    return null;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .signUpWithEmailPassword(
            _emailController.text.trim(),
            _passwordController.text,
            _usernameController.text.trim(),
          );
      if (!mounted) return;
      context.goHome();
    } on UsernameTakenException {
      if (!mounted) return;
      context.showSnackBar(context.l10n.authUsernameTaken);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      context.showSnackBar(_mapSignupError(e.code));
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar(context.l10n.authSignupError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _mapSignupError(String code) {
    final l10n = context.l10n;
    return switch (code) {
      "email-already-in-use" => l10n.authErrorEmailAlreadyInUse,
      "too-many-requests" => l10n.authErrorTooManyRequests,
      "user-disabled" => l10n.authErrorUserDisabled,
      _ => l10n.authSignupError,
    };
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final role = await ref.read(authProvider.notifier).signInWithGoogle();
      if (!mounted) return;
      switch (role) {
        case AppRole.agent:
          context.goAgentHome();
        case AppRole.pendingUsername:
          context.goAuthUsernameSetup();
        case AppRole.user:
          context.goHome();
      }
    } on SignInCancelledException {
      // Annulation silencieuse
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final msg = e.code == "account-exists-with-different-credential"
          ? context.l10n.authErrorEmailAlreadyInUse
          : context.l10n.authSignupError;
      context.showSnackBar(msg);
    } catch (e, st) {
      debugPrint("[GoogleSignIn/Register] unexpected error: $e\n$st");
      if (!mounted) return;
      context.showSnackBar(context.l10n.authSignupError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
