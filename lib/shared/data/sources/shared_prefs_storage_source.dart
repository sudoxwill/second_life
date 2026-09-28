import "package:shared_preferences/shared_preferences.dart";

import "../../domain/repositories/storage_repository.dart";

class PrefsStorage implements StorageRepository {
  const PrefsStorage(this._prefs);
  final SharedPreferences _prefs;

  @override
  Future<void> write(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> delete(String key) => _prefs.remove(key);

  @override
  Future<void> clear() => _prefs.clear();

  @override
  Future<Map<String, String>> readAll() async {
    return Map.fromEntries(
      _prefs
          .getKeys()
          .map((k) => MapEntry(k, _prefs.getString(k) ?? ""))
          .where((e) => e.value.isNotEmpty),
    );
  }
}
