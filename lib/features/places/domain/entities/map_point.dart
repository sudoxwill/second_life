import "package:equatable/equatable.dart";

// Points de dépôt SecondLife (pesée par un agent) ou lieux de recyclage
// externes (informatifs).
enum MapPointCategory { relay, recycling }

// Valeurs stockées dans Firestore : acceptedMaterials.
enum WasteMaterial {
  plastic,
  metal,
  paper,
  glass,
  ewaste,
  organic;

  static WasteMaterial? fromName(String? name) {
    for (final m in values) {
      if (m.name == name) return m;
    }
    return null;
  }
}

// Valeurs stockées dans Firestore : kind (lieux de recyclage seulement).
enum RecyclingKind {
  recyclingCenter,
  sortingCenter,
  dump,
  scrapDealer;

  static RecyclingKind? fromName(String? name) {
    for (final k in values) {
      if (k.name == name) return k;
    }
    return null;
  }
}

// Plage d'ouverture d'un jour, en minutes depuis minuit.
class DayHours extends Equatable {
  const DayHours(this.opensAt, this.closesAt);
  final int opensAt;
  final int closesAt;

  bool contains(int minutes) => minutes >= opensAt && minutes < closesAt;

  @override
  List<Object?> get props => [opensAt, closesAt];
}

class MapPoint extends Equatable {
  const MapPoint({
    required this.id,
    required this.category,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.district,
    this.city,
    this.country,
    this.phone,
    this.imageUrl,
    this.description,
    this.hoursNote,
    this.kind,
    this.acceptedMaterials = const [],
    this.openingHours = const {},
  });
  final String id;
  final MapPointCategory category;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  // Quartier (Bè, Tokoin…), utilisé par la recherche.
  final String? district;
  final String? city;
  final String? country;
  final String? phone;
  final String? imageUrl;
  final String? description;
  // Précision libre sous les horaires (jours fériés…).
  final String? hoursNote;
  final RecyclingKind? kind;
  final List<WasteMaterial> acceptedMaterials;
  // Clé : jour ISO (1 = lundi … 7 = dimanche). Jour absent = fermé.
  final Map<int, DayHours> openingHours;

  bool get isRelay => category == MapPointCategory.relay;

  bool get hasHours => openingHours.isNotEmpty;

  bool isOpenAt(DateTime time) {
    final hours = openingHours[time.weekday];
    return hours != null && hours.contains(time.hour * 60 + time.minute);
  }

  // Un agent tient la permanence les jours d'ouverture du point relais.
  bool hasAgentOn(DateTime day) =>
      isRelay && openingHours.containsKey(day.weekday);

  // Sans tenir compte des accents : "lome" trouve "Lomé".
  bool matches(String query) {
    final q = _fold(query.trim());
    if (q.isEmpty) return true;
    return [
      name,
      address,
      ?district,
      ?city,
      ?country,
    ].any((field) => _fold(field).contains(q));
  }

  static const _accents = {
    "à": "a",
    "â": "a",
    "ä": "a",
    "ç": "c",
    "é": "e",
    "è": "e",
    "ê": "e",
    "ë": "e",
    "î": "i",
    "ï": "i",
    "ô": "o",
    "ö": "o",
    "ù": "u",
    "û": "u",
    "ü": "u",
  };

  static String _fold(String text) =>
      text.toLowerCase().split("").map((c) => _accents[c] ?? c).join();

  @override
  List<Object?> get props => [
    id,
    category,
    name,
    address,
    latitude,
    longitude,
    district,
    city,
    country,
    phone,
    imageUrl,
    description,
    hoursNote,
    kind,
    acceptedMaterials,
    openingHours,
  ];
}
