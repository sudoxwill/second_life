import "dart:convert";

import "../../../core/constants/app_keys.dart";
import "../../domain/repositories/storage_repository.dart";

class StorageRepositoryImpl {
  const StorageRepositoryImpl({
    required this._regular,
  });

  final StorageRepository _regular;

  // Core

  Future<void> write(String key, String value) =>
      _regular.write(key, value);

  Future<String?> read(String key) =>
      _regular.read(key);

  Future<void> delete(String key) =>
      _regular.delete(key);

  Future<void> clearAll() =>
      _regular.clear();

  // Typed helpers

  Future<void> writeBool(String key, bool value) =>
      write(key, value.toString());

  Future<bool?> readBool(String key) async {
    final v = await read(key);
    if (v == null) return null;
    return v == "true";
  }

  Future<void> writeInt(String key, int value) =>
      write(key, value.toString());

  Future<int?> readInt(String key) async {
    final v = await read(key);
    return v != null ? int.tryParse(v) : null;
  }

  Future<void> writeDouble(String key, double value) =>
      write(key, value.toString());

  Future<double?> readDouble(String key) async {
    final v = await read(key);
    return v != null ? double.tryParse(v) : null;
  }

  Future<void> writeJson(String key, Map<String, dynamic> value) =>
      write(key, jsonEncode(value));

  Future<Map<String, dynamic>?> readJson(String key) async {
    final v = await read(key);
    if (v == null) return null;
    try {
      return jsonDecode(v) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeList(String key, List<String> value) =>
      write(key, jsonEncode(value));

  Future<List<String>?> readList(String key) async {
    final v = await read(key);
    if (v == null) return null;
    try {
      return (jsonDecode(v) as List).cast<String>();
    } catch (_) {
      return null;
    }
  }

  // Utilitaires

  Future<bool> has(String key) async =>
      (await read(key)) != null;

  // Onboarding

  Future<bool> get isOnboardingCompleted async =>
      (await readBool(AppKeys.onboardingCompleted)) ?? false;

  Future<void> setOnboardingCompleted({bool value = true}) =>
      writeBool(AppKeys.onboardingCompleted, value);

  // Thème

  /// 'system', 'light' ou 'dark' ('system' par défaut).
  Future<String> get themeMode async =>
      (await read(AppKeys.themeMode)) ?? "system";

  Future<void> setThemeMode(String mode) => write(AppKeys.themeMode, mode);
}
