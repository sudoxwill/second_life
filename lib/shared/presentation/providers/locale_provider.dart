import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/constants/app_keys.dart";
import "local_storage_provider.dart";

part "locale_provider.g.dart";

/// Locale active de l'application, persistée dans les préférences partagées.
///
/// Défaut : `fr`. Langues supportées : `fr`, `en`.
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

  /// Change et persiste la locale.
  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(AppKeys.locale, locale.languageCode);
    state = locale;
  }
}
