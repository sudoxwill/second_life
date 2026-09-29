import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/theme/app_theme.dart";
part "theme_provider.g.dart";

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    return .system;
  }

  void toggleTheme() {
    state = state == ThemeMode.system
        ? ThemeMode.light
        : (state == .light ? .dark : .light);
  }

  ThemeMode get theme => state;

  set theme(ThemeMode theme) {
    state = theme;
  }
}

@riverpod
ThemeData lightTheme(Ref ref) => AppTheme.lightTheme;

@riverpod
ThemeData darkTheme(Ref ref) => AppTheme.darkTheme;
