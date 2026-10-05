import "package:flutter/gestures.dart" show TapGestureRecognizer;
import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/index.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../widgets/oauth_section.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authEmailLabel,
                  keyboardType: .emailAddress,
                  prefixIconData: LucideIcons.mail,
                  controller: _emailController,
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
              RichText(
                text: TextSpan(
                  text: "${l10n.authNoAccount} ",
                  style: textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: l10n.authSignupLink,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: .bold,
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
    setState(() => _isLoading = true);
    // Simulate a login process
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
    if (mounted) context.goHome();
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    // Simulate a login process
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
    if (mounted) context.goHome();
  }
}
