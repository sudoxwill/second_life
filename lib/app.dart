import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "core/configs/env.dart";
import "core/routing/app_router.dart";
import "l10n/app_localizations.dart";
import "shared/presentation/providers/index.dart";

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: locale,
      title: Env.appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
