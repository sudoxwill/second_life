import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../data/repositories/local_storage_repository_impl.dart";
import "../../data/sources/shared_prefs_storage_source.dart";

part "local_storage_provider.g.dart";

// Injecté depuis main(), ce qui évite un provider async.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError("Override in main via ProviderScope");
}

@Riverpod(keepAlive: true)
StorageRepositoryImpl localStorageRepository(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageRepositoryImpl(regular: PrefsStorage(prefs));
}
