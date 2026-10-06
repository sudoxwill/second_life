import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";
import "../providers/auth_provider.dart";
import "../widgets/oauth_section.dart";

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
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
              AppAssets.register,
              width: AppSpacing.yotta * 2,
              height: AppSpacing.yotta * 2,
            ),
          ),
          AppSpacing.gapVSm,
          Center(
            child: Text(l10n.authSignupTitle, style: textTheme.headlineMedium),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.authUsernameLabel,
                  textInputAction: .next,
                  prefixIconData: LucideIcons.userRound,
                  controller: _usernameController,
                ),
                AppSpacing.gapVXl,
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
                text: l10n.authSignupButton,
                isLoading: _isLoading,
                onPressed: _signUp,
              ),
              RichText(
                text: TextSpan(
                  text: "${l10n.authAlreadyHaveAccount} ",
                  style: textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: l10n.authLoginLink,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: .bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.goAuthLogin(),
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

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ref.read(authProvider.notifier).signIn(AppRole.user);
    context.goHome();
  }

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ref.read(authProvider.notifier).signIn(AppRole.user);
    context.goHome();
  }
}
