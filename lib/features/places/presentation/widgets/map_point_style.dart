import "package:flutter/material.dart" hide MaterialType;
import "package:intl/intl.dart";
import "package:latlong2/latlong.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../l10n/app_localizations.dart";
import "../../../history/presentation/widgets/material_type_icon.dart";
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

  IconData get icon =>
      isRelay ? LucideIcons.leaf : (kind ?? RecyclingKind.recyclingCenter).icon;

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

  String typeLabel(AppLocalizations l10n) => isRelay
      ? l10n.placesTypeRelay
      : kind?.label(l10n) ?? l10n.placesTypeRecycling;

  double distanceFrom(LatLng from) =>
      const Distance().as(LengthUnit.Meter, from, latLng);

  // "lun.–ven. 08h–18h · sam. 08h–14h" : jours consécutifs aux mêmes horaires
  // regroupés. Jours abrégés dans la langue de [locale].
  String hoursLabel(String locale) {
    // 1er janvier 2024 = lundi : index 1..7 → jours ISO.
    String dayName(int weekday) =>
        DateFormat.E(locale).format(DateTime(2024, 1, weekday));
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
          ? dayName(day)
          : "${dayName(day)}–${dayName(end)}";
      final opens = _formatTime(hours.opensAt, locale);
      final closes = _formatTime(hours.closesAt, locale);
      groups.add("$days $opens–$closes");
      day = end + 1;
    }
    return groups.join(" · ");
  }
}

extension WasteMaterialLabel on WasteMaterial {
  String label(AppLocalizations l10n) => type.label(l10n);
}

extension RecyclingKindLabel on RecyclingKind {
  String label(AppLocalizations l10n) => switch (this) {
    RecyclingKind.recyclingCenter => l10n.placesKindRecyclingCenter,
    RecyclingKind.sortingCenter => l10n.placesKindSortingCenter,
    RecyclingKind.dump => l10n.placesKindDump,
    RecyclingKind.scrapDealer => l10n.placesKindScrapDealer,
  };
}

// "08h" / "08h30" en français, "08:00" / "08:30" ailleurs.
String _formatTime(int minutes, String locale) {
  final h = (minutes ~/ 60).toString().padLeft(2, "0");
  final m = (minutes % 60).toString().padLeft(2, "0");
  if (locale.startsWith("fr")) return m == "00" ? "${h}h" : "${h}h$m";
  return "$h:$m";
}

String formatClock(DateTime time, String locale) =>
    _formatTime(time.hour * 60 + time.minute, locale);

// "850 m" ou "1,2 km" (séparateur décimal de la langue).
String formatDistance(double meters, String locale) {
  if (meters < 1000) return "${meters.round()} m";
  return "${NumberFormat("0.0", locale).format(meters / 1000)} km";
}
