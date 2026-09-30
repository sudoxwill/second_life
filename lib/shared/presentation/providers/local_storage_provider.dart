import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "local_storage_provider.g.dart";

// SharedPreferences injecté depuis main() — pas d'async dans le provider
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError("Override in main via ProviderScope");
}
