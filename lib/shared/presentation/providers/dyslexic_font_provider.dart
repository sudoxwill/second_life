import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/constants/app_keys.dart";
import "local_storage_provider.dart";

part "dyslexic_font_provider.g.dart";

@Riverpod(keepAlive: true)
class AppDyslexicFont extends _$AppDyslexicFont {
  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(AppKeys.dyslexicFont) ?? false;
  }

  Future<void> toggle() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final next = !state;
    await prefs.setBool(AppKeys.dyslexicFont, next);
    state = next;
  }
}
