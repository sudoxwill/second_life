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

class UsernameSetupPage extends ConsumerStatefulWidget {
  const UsernameSetupPage({super.key});

  @override
  ConsumerState<UsernameSetupPage> createState() => _UsernameSetupPageState();
}

class _UsernameSetupPageState extends ConsumerState<UsernameSetupPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _usernameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AuthLayout(
      illustration: AppAssets.register,
      title: l10n.authUsernameSetupTitle,
      subtitle: l10n.authUsernameSetupSubtitle,
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: [
            AppTextFormField(
              isRequired: true,
              autoFocus: true,
              labelText: l10n.authUsernameLabel,
              hintText: l10n.authUsernameHint,
              textInputAction: TextInputAction.done,
              prefixIconData: LucideIcons.atSign,
              controller: _usernameController,
              validatorFunction: _validateUsername,
              onFieldSubmitted: (_) => _submit(),
            ),
            AppElevatedButton(
              text: l10n.authUsernameSetupButton,
              isLoading: _isLoading,
              onPressed: _submit,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  String? _validateUsername(String? value) {
    final v = value?.trim() ?? "";
    final regex = RegExp(r"^[a-zA-Z0-9_]{3,20}$");
    if (!regex.hasMatch(v)) return context.l10n.validationUsernameInvalid;
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final role = await ref
          .read(authProvider.notifier)
          .saveUsername(_usernameController.text.trim());
      if (!mounted) return;
      if (role == AppRole.agent) {
        context.goAgentHome();
      } else {
        context.goHome();
      }
    } on UsernameTakenException {
      if (!mounted) return;
      context.showSnackBar(context.l10n.authUsernameTaken);
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar(context.l10n.commonError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
