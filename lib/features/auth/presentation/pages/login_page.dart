import "package:flutter/gestures.dart" show TapGestureRecognizer;
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/index.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../providers/auth_provider.dart";
import "../widgets/oauth_section.dart";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return AppScaffold(
      scrollable: true,
      resizeToAvoidBottomInset: true,
      body: Column(
        spacing: AppSpacing.xxl,
        children: [
          Center(
            child: Image.asset(
              AppAssets.login,
              width: AppSpacing.yotta * 2,
              height: AppSpacing.yotta * 2,
            ),
          ),
          AppSpacing.gapVSm,
          Center(
            child: Text(l10n.authLoginTitle, style: textTheme.headlineMedium),
          ),
          Form(
            key: _formKey,
            child: Column(
              spacing: AppSpacing.xl,
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authEmailLabel,
                  hintText: l10n.authEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIconData: LucideIcons.mail,
                  controller: _emailController,
                ),
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authPasswordLabel,
                  hintText: l10n.authPasswordHint,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  prefixIconData: LucideIcons.lockKeyhole,
                  suffixIconData: _obscurePassword
                      ? LucideIcons.eyeOff
                      : LucideIcons.eye,
                  suffixIconOnClick: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  controller: _passwordController,
                  onFieldSubmitted: (_) => _login(),
                ),
              ],
            ),
          ),
          Column(
            spacing: AppSpacing.sm,
            children: [
              AppElevatedButton(
                text: l10n.authLoginButton,
                isLoading: _isLoading,
                onPressed: _login,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : context.goAuthForgot,
                  child: Text(
                    l10n.authForgotPassword,
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "${l10n.authNoAccount} ",
                  style: textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: l10n.authSignupLink,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.pushAuthSignup(),
                    ),
                  ],
                ),
              ),
              OAuthSection(
                isLoading: _isLoading,
                onGoogleSignIn: _googleSignIn,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await _signIn();
  }

  Future<void> _googleSignIn() => _signIn();

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    final AppRole role;
    try {
      role = await ref.read(authProvider.notifier).signIn();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.showSnackBar(context.l10n.commonError);
      return;
    }
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (role == AppRole.agent) {
      context.goAgentHome();
    } else {
      context.goHome();
    }
  }
}
