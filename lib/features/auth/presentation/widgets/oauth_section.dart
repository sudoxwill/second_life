import "package:flutter/material.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_outlined_button.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

class OAuthSection extends StatelessWidget {
  const OAuthSection({
    // required this._isLoading,
    super.key,
    this._onGoogleSignIn,
  });

  // final bool _isLoading;
  final void Function()? _onGoogleSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tt = context.textTheme;
    final cs = context.colorScheme;
    return Column(
      children: [
        AppDivider(
          label: l10n.authOr,
          style: tt.titleMedium!.copyWith(
            color: cs.onSurface.withValues(alpha: .6),
          ),
        ),
        AppOutlinedButton(
          backgroundColor: cs.surfaceContainer,
          // isLoading: _isLoading,
          onPressed: _onGoogleSignIn,
          child: Row(
            spacing: AppSpacing.md,
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                AppAssets.googleLogo,
                width: AppSpacing.xl,
                height: AppSpacing.xl,
              ),
              Text(
                l10n.authOAuthGoogle,
                style: tt.titleSmall!.copyWith(
                  color: cs.onSurface.withValues(alpha: .8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
