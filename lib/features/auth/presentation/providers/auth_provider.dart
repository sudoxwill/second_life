import "package:riverpod_annotation/riverpod_annotation.dart";

part "auth_provider.g.dart";

enum AppRole { user, agent }

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AppRole? build() => .agent;

  // Action métier (connexion), pas un simple setter.
  // ignore: use_setters_to_change_properties
  void signIn(AppRole role) => state = role;
  void signOut() => state = null;
}
