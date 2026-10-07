import "package:flutter/material.dart" hide MaterialType;
import "package:latlong2/latlong.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../history/presentation/widget/material_type_icon.dart";
import "../../domain/entities/map_point.dart";

extension WasteMaterialStyle on WasteMaterial {
  // Les deux enums partagent les mêmes noms.
  MaterialType get type => MaterialType.values.byName(name);

  IconData get icon => type.icon;
}

extension RecyclingKindStyle on RecyclingKind {
  IconData get icon => switch (this) {
    RecyclingKind.recyclingCenter => LucideIcons.recycle,
    RecyclingKind.sortingCenter => LucideIcons.layers,
    RecyclingKind.dump => LucideIcons.trash2,
    RecyclingKind.scrapDealer => LucideIcons.hammer,
  };

  // (couleur, fond) : une teinte par sorte de lieu.
  (Color, Color) colors(BuildContext context) {
    final dark = context.isDarkMode;
    return switch (this) {
      RecyclingKind.recyclingCenter => (context.info, context.infoSoft),
      RecyclingKind.sortingCenter => (
        dark ? AppColors.materialGlassDark : AppColors.materialGlass,
        dark ? AppColors.materialGlassBgDark : AppColors.materialGlassBg,
      ),
      RecyclingKind.dump => (context.warning, context.warningSoft),
      RecyclingKind.scrapDealer => (
        dark ? AppColors.materialMetalDark : AppColors.materialMetal,
        dark ? AppColors.materialMetalBgDark : AppColors.materialMetalBg,
      ),
    };
  }
}

// Vert pour les points relais (dépôt & pesée) ; une teinte et une icône par
// sorte de lieu de recyclage (information seulement).
extension MapPointStyle on MapPoint {
  LatLng get latLng => LatLng(latitude, longitude);

  IconData get icon => isRelay
      ? LucideIcons.leaf
      : (kind ?? RecyclingKind.recyclingCenter).icon;

  Color color(BuildContext context) => isRelay
      ? Theme.of(context).colorScheme.primary
      : (kind ?? RecyclingKind.recyclingCenter).colors(context).$1;

  Color softColor(BuildContext context) => isRelay
      ? context.primarySoft
      : (kind ?? RecyclingKind.recyclingCenter).colors(context).$2;

  // Prochain changement d'état : la fermeture si le point est ouvert, sinon
  // sa prochaine ouverture (null sans horaires).
  DateTime? nextChange(DateTime now) {
    final minutes = now.hour * 60 + now.minute;
    final today = openingHours[now.weekday];
    DateTime at(DateTime day, int m) =>
        DateTime(day.year, day.month, day.day, m ~/ 60, m % 60);
    if (today != null && today.contains(minutes)) {
      return at(now, today.closesAt);
    }
    if (today != null && today.opensAt > minutes) return at(now, today.opensAt);
    for (var i = 1; i <= 7; i++) {
      final day = DateTime(now.year, now.month, now.day + i);
      final hours = openingHours[day.weekday];
      if (hours != null) return at(day, hours.opensAt);
    }
    return null;
  }

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

// "08h" ou "08h30".
String formatClock(DateTime time) => _formatTime(time.hour * 60 + time.minute);

// "850 m" ou "1,2 km".
String formatDistance(double meters) {
  if (meters < 1000) return "${meters.round()} m";
  return "${(meters / 1000).toStringAsFixed(1).replaceAll(".", ",")} km";
}
