import "package:flutter/material.dart";
import "package:latlong2/latlong.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/theme/index.dart";
import "../../domain/entities/map_point.dart";

// Vert pour les points relais (dépôt & pesée), bleu pour les lieux de
// recyclage (information seulement).
extension MapPointStyle on MapPoint {
  LatLng get latLng => LatLng(latitude, longitude);

  IconData get icon {
    if (isRelay) return LucideIcons.leaf;
    return switch (kind) {
      RecyclingKind.sortingCenter => LucideIcons.layers,
      RecyclingKind.dump => LucideIcons.trash2,
      RecyclingKind.scrapDealer => LucideIcons.hammer,
      RecyclingKind.recyclingCenter || null => LucideIcons.recycle,
    };
  }

  Color color(BuildContext context) =>
      isRelay ? Theme.of(context).colorScheme.primary : context.info;

  Color softColor(BuildContext context) =>
      isRelay ? context.primarySoft : context.infoSoft;

  String get typeLabel =>
      isRelay ? "Point relais SecondLife" : kind?.label ?? "Lieu de recyclage";

  double distanceFrom(LatLng from) =>
      const Distance().as(LengthUnit.Meter, from, latLng);

  // "Lun–Ven 08h–18h · Sam 08h–14h" : jours consécutifs aux mêmes horaires
  // regroupés.
  String get hoursLabel {
    final groups = <String>[];
    var day = 1;
    while (day <= 7) {
      final hours = openingHours[day];
      if (hours == null) {
        day++;
        continue;
      }
      var end = day;
      while (end < 7 && openingHours[end + 1] == hours) {
        end++;
      }
      final days = end == day
          ? _dayNames[day - 1]
          : "${_dayNames[day - 1]}–${_dayNames[end - 1]}";
      groups.add(
        "$days ${_formatTime(hours.opensAt)}–${_formatTime(hours.closesAt)}",
      );
      day = end + 1;
    }
    return groups.join(" · ");
  }
}

const _dayNames = ["Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim"];

String _formatTime(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, "0");
  final m = minutes % 60;
  return m == 0 ? "${h}h" : "${h}h${m.toString().padLeft(2, "0")}";
}

// "850 m" ou "1,2 km".
String formatDistance(double meters) {
  if (meters < 1000) return "${meters.round()} m";
  return "${(meters / 1000).toStringAsFixed(1).replaceAll(".", ",")} km";
}
