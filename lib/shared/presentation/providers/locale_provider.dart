import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/constants/app_keys.dart";
import "local_storage_provider.dart";

part "locale_provider.g.dart";

/// Langue de l'app, sauvegardée dans les préférences (fr par défaut).
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  static const _supportedCodes = ["fr", "en"];

  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = prefs.getString(AppKeys.locale) ?? "fr";
    final resolved = _supportedCodes.contains(code) ? code : "fr";
    return Locale(resolved);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppKeys.locale, locale.languageCode);
    state = locale;
  }
}
