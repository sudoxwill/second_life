import "dart:async";

import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "user_location_provider.g.dart";

// Position de l'usager, ou null si la localisation est coupée ou refusée :
// la carte reste utilisable sans (pas de distances, centrée sur Lomé).
@Riverpod(keepAlive: true)
class UserLocationNotifier extends _$UserLocationNotifier {
  static const _timeout = Duration(seconds: 10);

  @override
  FutureOr<LatLng?> build() => _locate();

  // Pas d'état de chargement : l'ancienne position reste affichée.
  Future<LatLng?> refresh() async {
    state = await AsyncValue.guard(_locate);
    return state.value;
  }

  Future<LatLng?> _locate() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _timeout,
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      // Délai dépassé ou GPS indisponible : on retombe sur la dernière
      // position connue, sinon rien.
      final last = await Geolocator.getLastKnownPosition();
      return last == null ? null : LatLng(last.latitude, last.longitude);
    }
  }
}
