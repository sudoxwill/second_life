import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_semantic_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/providers/dyslexic_font_provider.dart";
import "../../../../shared/presentation/providers/locale_provider.dart";
import "../../../../shared/presentation/providers/notifications_enabled_provider.dart";
import "../../../../shared/presentation/providers/theme_provider.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";

class ProfileSettingsSection extends ConsumerStatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  ConsumerState<ProfileSettingsSection> createState() =>
      _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState
    extends ConsumerState<ProfileSettingsSection> {
  /// Chaque langue est écrite dans sa propre langue, on ne la traduit pas.
  static const Map<String, String> _languageNames = {
    "fr": "Français",
    "en": "English",
  };

  // Pendant l'enregistrement : évite les doubles appuis.
  bool _savingNotifications = false;

  Future<void> _setNotifications(bool enabled) async {
    if (_savingNotifications) return;
    setState(() => _savingNotifications = true);
    final ok = await ref
        .read(appNotificationsEnabledProvider.notifier)
        .setEnabled(enabled);
    if (!mounted) return;
    setState(() => _savingNotifications = false);
    if (!ok) showAppSnackBar(context, context.l10n.profileNotificationsError);
  }

  String _languageLabel(Locale locale) =>
      _languageNames[locale.languageCode] ?? _languageNames.entries.last.value;

  void _showThemePicker(ThemeMode current) {
    final l10n = context.l10n;
    final options = [
      (
        mode: ThemeMode.light,
        label: l10n.profileThemeLight,
        icon: LucideIcons.sun,
      ),
      (
        mode: ThemeMode.dark,
        label: l10n.profileThemeDark,
        icon: LucideIcons.moon,
      ),
      (
        mode: ThemeMode.system,
        label: l10n.profileThemeSystem,
        icon: LucideIcons.monitor,
      ),
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
                  ? Icon(
                      LucideIcons.check,
                      size: AppSpacing.iconMd,
                      color: context.primaryText,
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
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entry in _languageNames.entries)
            ListTile(
              title: Text(entry.value),
              trailing: current.languageCode == entry.key
                  ? Icon(
                      LucideIcons.check,
                      size: AppSpacing.iconMd,
                      color: context.primaryText,
                    )
                  : null,
              onTap: () {
                ref
                    .read(appLocaleProvider.notifier)
                    .setLocale(Locale(entry.key));
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
    final l10n = context.l10n;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(appLocaleProvider);
    final dyslexic = ref.watch(appDyslexicFontProvider);
    final notificationsEnabled = ref.watch(appNotificationsEnabledProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Text(
            l10n.profileSettingsTitle,
            style: textTheme.titleSmall!.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsTile(
                icon: LucideIcons.bell,
                title: l10n.profileSettingsNotifications,
                onTap: () => _setNotifications(!notificationsEnabled),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: _savingNotifications ? null : _setNotifications,
                ),
              ),
              const Divider(height: 1, indent: 64),
              _SettingsTile(
                icon: LucideIcons.sunMoon,
                title: l10n.profileSettingsTheme,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      switch (themeMode) {
                        ThemeMode.light => l10n.profileThemeLight,
                        ThemeMode.dark => l10n.profileThemeDark,
                        ThemeMode.system => l10n.profileThemeSystem,
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
              const Divider(height: 1, indent: 64),
              _SettingsTile(
                icon: LucideIcons.globe,
                title: l10n.profileSettingsLanguage,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      _languageLabel(locale),
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
              const Divider(height: 1, indent: 64),
              _SettingsTile(
                icon: LucideIcons.type,
                title: l10n.profileSettingsDyslexicFont,
                onTap: ref.read(appDyslexicFontProvider.notifier).toggle,
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
      leading: IconTile(
        icon: icon,
        color: context.primaryText,
        background: context.primarySoft,
        size: 36,
      ),
      title: Text(title, style: context.textTheme.bodyMedium),
      trailing: trailing,
    );
  }
}
