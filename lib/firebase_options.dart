import "dart:convert";

import "package:firebase_core/firebase_core.dart" show FirebaseOptions;
import "package:flutter/foundation.dart"
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import "package:flutter/services.dart" show rootBundle;

/// Charge les [FirebaseOptions] depuis `firebase.json` (asset non versionné).
///
/// Copier `firebase.example.json` en `firebase.json` et renseigner les valeurs.
///
/// ```dart
/// await Firebase.initializeApp(
///   options: await DefaultFirebaseOptions.currentPlatform(),
/// );
/// ```
class DefaultFirebaseOptions {
  static const String _configPath = "firebase.json";

  static Future<FirebaseOptions> currentPlatform() async {
    if (kIsWeb) {
      throw UnsupportedError(
        "DefaultFirebaseOptions have not been configured for web.",
      );
    }

    final platform = switch (defaultTargetPlatform) {
      TargetPlatform.android => "android",
      TargetPlatform.iOS => "ios",
      _ => throw UnsupportedError(
        "DefaultFirebaseOptions have not been configured for "
        "$defaultTargetPlatform.",
      ),
    };

    final config =
        jsonDecode(await rootBundle.loadString(_configPath))
            as Map<String, dynamic>;
    final options = (config["options"] as Map<String, dynamic>?)?[platform];
    if (options is! Map<String, dynamic>) {
      throw StateError(
        'Configuration Firebase "$platform" absente de $_configPath.',
      );
    }

    return FirebaseOptions(
      apiKey: options["apiKey"] as String,
      appId: options["appId"] as String,
      messagingSenderId: options["messagingSenderId"] as String,
      projectId: options["projectId"] as String,
      databaseURL: options["databaseURL"] as String?,
      storageBucket: options["storageBucket"] as String?,
      iosBundleId: options["iosBundleId"] as String?,
    );
  }
}
