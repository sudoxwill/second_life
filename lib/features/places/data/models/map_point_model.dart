import "package:cloud_firestore/cloud_firestore.dart";

import "../../domain/entities/map_point.dart";

class MapPointModel extends MapPoint {
  const MapPointModel({
    required super.id,
    required super.category,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.district,
    super.city,
    super.country,
    super.phone,
    super.imageUrl,
    super.description,
    super.hoursNote,
    super.kind,
    super.acceptedMaterials,
    super.openingHours,
  });

  static const _dayKeys = ["mon", "tue", "wed", "thu", "fri", "sat", "sun"];

  // Document relay_points/{id} ou recycling_points/{id}. Renvoie null si le
  // document est incomplet (pas de nom ou de position) : il est ignoré.
  static MapPointModel? fromFirestore(
    String id,
    MapPointCategory category,
    Map<String, dynamic> json,
  ) {
    final name = json["name"] as String?;
    final location = json["location"];
    if (name == null || name.isEmpty || location is! GeoPoint) return null;

    return MapPointModel(
      id: id,
      category: category,
      name: name,
      address: json["address"] as String? ?? "",
      latitude: location.latitude,
      longitude: location.longitude,
      district: json["district"] as String?,
      city: json["city"] as String?,
      country: json["country"] as String?,
      phone: json["phone"] as String?,
      imageUrl: json["imageUrl"] as String?,
      description: json["description"] as String?,
      hoursNote: json["hoursNote"] as String?,
      kind: RecyclingKind.fromName(json["kind"] as String?),
      acceptedMaterials: [
        for (final m in json["acceptedMaterials"] as List? ?? const [])
          ?WasteMaterial.fromName(m as String?),
      ],
      openingHours: _parseHours(json["openingHours"]),
    );
  }

  // { "mon": "08:00-18:00", "sat": "08:00-14:00" }
  static Map<int, DayHours> _parseHours(Object? raw) {
    if (raw is! Map) return const {};
    final hours = <int, DayHours>{};
    for (var i = 0; i < _dayKeys.length; i++) {
      final range = _parseRange(raw[_dayKeys[i]]);
      if (range != null) hours[i + 1] = range;
    }
    return hours;
  }

  static DayHours? _parseRange(Object? raw) {
    if (raw is! String) return null;
    final parts = raw.split("-");
    if (parts.length != 2) return null;
    final opensAt = _parseTime(parts[0]);
    final closesAt = _parseTime(parts[1]);
    if (opensAt == null || closesAt == null || closesAt <= opensAt) {
      return null;
    }
    return DayHours(opensAt, closesAt);
  }

  static int? _parseTime(String raw) {
    final parts = raw.trim().split(":");
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null || h > 24 || m > 59) return null;
    return h * 60 + m;
  }
}
