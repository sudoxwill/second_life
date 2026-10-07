import "package:flutter/material.dart";

/// Pour naviguer sans BuildContext, par exemple au tap sur une notification.
class AppNavigatorKey {
  AppNavigatorKey._();

  static final GlobalKey<NavigatorState> instance =
      GlobalKey<NavigatorState>(debugLabel: "AppNavigatorKey");
}
