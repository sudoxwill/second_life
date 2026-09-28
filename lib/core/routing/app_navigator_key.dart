import "package:flutter/material.dart";

/// GlobalKey permettant la navigation sans BuildContext depuis des callbacks
/// hors du widget tree (tap sur notification, background handler).
///
/// Injecté dans GoRouter via le paramètre navigatorKey.
class AppNavigatorKey {
  AppNavigatorKey._();

  static final GlobalKey<NavigatorState> instance =
      GlobalKey<NavigatorState>(debugLabel: "AppNavigatorKey");
}
