import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/providers/dyslexic_font_provider.dart";
import "../../../../shared/presentation/providers/locale_provider.dart";
import "../../../../shared/presentation/providers/theme_provider.dart";

class ProfileSettingsSection extends ConsumerStatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  ConsumerState<ProfileSettingsSection> createState() =>
      _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState
    extends ConsumerState<ProfileSettingsSection> {
  bool _notificationsEnabled = true;

  void _showThemePicker(ThemeMode current) {
    final options = [
      (mode: ThemeMode.light, label: "Clair", icon: LucideIcons.sun),
      (mode: ThemeMode.dark, label: "Sombre", icon: LucideIcons.moon),
      (mode: ThemeMode.system, label: "Système", icon: LucideIcons.monitor),
    ];
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final opt in options)
            ListTile(
              leading: Icon(opt.icon, size: AppSpacing.iconMd),
              title: Text(opt.label),
              trailing: current == opt.mode
                  ? const Icon(
                      LucideIcons.check,
                      size: AppSpacing.iconMd,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () {
                ref.read(appThemeModeProvider.notifier).theme = opt.mode;
                Navigator.pop(ctx);
              },
            ),
          AppSpacing.gapVMd,
        ],
      ),
    );
  }

  void _showLanguagePicker(Locale current) {
    final options = [
      (code: "fr", label: "Français"),
      (code: "en", label: "English"),
    ];
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final opt in options)
            ListTile(
              title: Text(opt.label),
              trailing: current.languageCode == opt.code
                  ? const Icon(
                      LucideIcons.check,
                      size: AppSpacing.iconMd,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () {
                ref
                    .read(appLocaleProvider.notifier)
                    .setLocale(Locale(opt.code));
                Navigator.pop(ctx);
              },
            ),
          AppSpacing.gapVMd,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final dyslexic = ref.watch(appDyslexicFontProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            "Paramètres",
            style: textTheme.titleSmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsTile(
                icon: LucideIcons.bell,
                title: "Notifications",
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (v) => setState(() => _notificationsEnabled = v),
                ),
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: LucideIcons.sunMoon,
                title: "Thème",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      switch (themeMode) {
                        ThemeMode.light => "Clair",
                        ThemeMode.dark => "Sombre",
                        ThemeMode.system => "Système",
                      },
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: AppSpacing.iconMd,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                onTap: () => _showThemePicker(themeMode),
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: LucideIcons.globe,
                title: "Langue",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      locale.languageCode == "fr" ? "Français" : "English",
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: AppSpacing.iconMd,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                onTap: () => _showLanguagePicker(locale),
              ),
              const Divider(height: 1, indent: 56),
              _SettingsTile(
                icon: LucideIcons.type,
                title: "Police dyslexique",
                trailing: Switch(
                  value: dyslexic,
                  onChanged: (_) =>
                      ref.read(appDyslexicFontProvider.notifier).toggle(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      leading: Icon(icon, size: AppSpacing.iconXl),
      title: Text(title, style: context.textTheme.bodyMedium),
      trailing: trailing,
    );
  }
}
