import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../shared/presentation/providers/local_storage_provider.dart";

part "onboarding_provider.g.dart";

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<bool> build() async {
    final storage = ref.watch(localStorageRepositoryProvider);
    return storage.isOnboardingCompleted;
  }

  Future<void> completeOnboarding() async {
    state = const AsyncLoading();
    final storage = ref.read(localStorageRepositoryProvider);
    final next = await AsyncValue.guard(() async {
      await storage.setOnboardingCompleted();
      return true;
    });
    if (ref.mounted) state = next;
  }
}
