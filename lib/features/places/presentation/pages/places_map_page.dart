import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:latlong2/latlong.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/pill_tabs.dart";
import "../../domain/entities/map_point.dart";
import "../providers/map_points_provider.dart";
import "../providers/user_location_provider.dart";
import "../widgets/map_markers.dart";
import "../widgets/map_point_card.dart";
import "../widgets/map_point_style.dart";

// Onglet "Carte" : points relais SecondLife et lieux de recyclage de Lomé.
class PlacesMapPage extends ConsumerStatefulWidget {
  const PlacesMapPage({super.key});

  @override
  ConsumerState<PlacesMapPage> createState() => _PlacesMapPageState();
}

class _PlacesMapPageState extends ConsumerState<PlacesMapPage> {
  // Lomé, en attendant la position de l'usager.
  static const _defaultCenter = LatLng(6.1550, 1.2300);
  static const _initialZoom = 12.5;
  static const _pointZoom = 15.5;
  // Au-delà, aucun point autour de l'usager : la carte ne bouge pas.
  static const _maxAutoCenterMeters = 50000.0;
  // Hauteur de la recherche, des onglets et des filtres en haut de carte.
  static const _topOverlayHeight = 184.0;
  // Hauteur visible de la liste repliée (poignée + titre).
  static const _sheetPeek = 78.0;

  final _map = MapController();
  final _sheet = DraggableScrollableController();
  final _search = TextEditingController();

  var _mapReady = false;
  var _autoCentered = false;
  var _category = MapPointCategory.relay;
  // WasteMaterial (points relais) ou RecyclingKind (recyclage), null = tous.
  Object? _filter;
  var _query = "";
  var _expanded = false;
  // Tailles de la liste, en fraction de la hauteur disponible.
  var _minSize = 0.1;
  var _maxSize = 0.8;

  @override
  void initState() {
    super.initState();
    _sheet.addListener(_onSheetMoved);
  }

  @override
  void dispose() {
    _sheet.removeListener(_onSheetMoved);
    _sheet.dispose();
    _map.dispose();
    _search.dispose();
    super.dispose();
  }

  void _onSheetMoved() {
    // Seuil à mi-course entre replié et déplié.
    final expanded = _sheet.size > (_minSize + _maxSize) / 2;
    if (expanded != _expanded) setState(() => _expanded = expanded);
  }

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(mapPointsProvider);
    final location = ref.watch(userLocationProvider).value;

    ref
      ..listen(userLocationProvider, (_, _) => _autoCenter())
      ..listen(mapPointsProvider, (_, _) => _autoCenter());

    final visible = _visiblePoints(points.value ?? const [], location);
    final searchHint = _searchHint(points.value ?? const [], location);

    return LayoutBuilder(
      builder: (context, constraints) {
        // La barre du bas passe par-dessus la page (extendBody).
        final navHeight = MediaQuery.paddingOf(context).bottom;
        final sheetArea = constraints.maxHeight - navHeight;
        final minSize = _minSize = (_sheetPeek / sheetArea).clamp(0.05, 0.4);
        final maxSize = _maxSize = ((sheetArea - _topOverlayHeight) / sheetArea)
            .clamp(minSize + 0.1, 1.0);

        return Stack(
          children: [
            Positioned.fill(child: _buildMap(visible, location)),
            Positioned(
              left: 8,
              bottom: navHeight + _sheetPeek + 4,
              child: const _OsmAttribution(),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: navHeight,
              child: DraggableScrollableSheet(
                controller: _sheet,
                initialChildSize: minSize,
                minChildSize: minSize,
                maxChildSize: maxSize,
                snap: true,
                builder: (context, scrollController) => _NearbySheet(
                  scrollController: scrollController,
                  category: _category,
                  points: points,
                  visible: visible,
                  location: location,
                  expanded: _expanded,
                  onToggle: _toggleSheet,
                  onRetry: ref.read(mapPointsProvider.notifier).refresh,
                  onFocus: _focusPoint,
                  onDetails: (p) => context.pushPlaceDetail(p.id),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 12,
              child: _TopBar(
                search: _search,
                searchHint: searchHint,
                category: _category,
                filter: _filter,
                onQueryChanged: (q) => setState(() => _query = q),
                onCategoryChanged: (c) => setState(() {
                  _category = c;
                  _filter = null;
                }),
                onFilterChanged: (f) => setState(() => _filter = f),
              ),
            ),
            Positioned(
              right: 16,
              top: _topOverlayHeight + 4,
              child: _LocateButton(onPressed: _locateUser),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMap(List<MapPoint> visible, LatLng? location) {
    return FlutterMap(
      mapController: _map,
      options: MapOptions(
        initialCenter: _defaultCenter,
        initialZoom: _initialZoom,
        minZoom: 5,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        onMapReady: () {
          _mapReady = true;
          _autoCenter();
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.secondlife.second_life",
        ),
        MarkerLayer(
          markers: [
            if (location != null)
              Marker(
                point: location,
                width: UserLocationMarker.size,
                height: UserLocationMarker.size,
                child: const UserLocationMarker(),
              ),
            for (final point in visible)
              Marker(
                point: point.latLng,
                width: MapPointMarker.width,
                height: MapPointMarker.height,
                // La pastille (et non l'étiquette) est posée sur le point.
                alignment: const Alignment(0, 0.45),
                child: MapPointMarker(
                  point: point,
                  onTap: () => context.pushPlaceDetail(point.id),
                ),
              ),
          ],
        ),
      ],
    );
  }

  List<MapPoint> _visiblePoints(List<MapPoint> all, LatLng? location) {
    final filter = _filter;
    final list = [
      for (final p in all)
        if (p.category == _category &&
            p.matches(_query) &&
            switch (filter) {
              final WasteMaterial m => p.acceptedMaterials.contains(m),
              final RecyclingKind k => p.kind == k,
              _ => true,
            })
          p,
    ];
    if (location != null) {
      list.sort(
        (a, b) => a.distanceFrom(location).compareTo(b.distanceFrom(location)),
      );
    } else {
      list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  // Une seule fois, dès que la carte, la position et les points sont prêts :
  // centre sur l'usager s'il a des points autour de lui.
  void _autoCenter() {
    if (_autoCentered || !_mapReady) return;
    final position = ref.read(userLocationProvider).value;
    final points = ref.read(mapPointsProvider).value;
    if (position == null || points == null) return;
    _autoCentered = true;
    final nearest = _nearest(points, position);
    if (nearest != null &&
        nearest.distanceFrom(position) <= _maxAutoCenterMeters) {
      _map.move(position, 14);
    }
  }

  MapPoint? _nearest(List<MapPoint> points, LatLng position) {
    MapPoint? nearest;
    var best = double.infinity;
    for (final p in points) {
      final d = p.distanceFrom(position);
      if (d < best) {
        best = d;
        nearest = p;
      }
    }
    return nearest;
  }

  // "Rechercher un point à Cotonou (Akpakpa, Fidjrossè…)" pour un usager
  // proche de Cotonou, sinon les villes qui ont le plus de points.
  String _searchHint(List<MapPoint> points, LatLng? location) {
    final nearest = location == null ? null : _nearest(points, location);
    final city = nearest?.city;
    if (city != null &&
        nearest!.distanceFrom(location!) <= _maxAutoCenterMeters) {
      final districts = {
        for (final p in points)
          if (p.city == city) ?p.district,
      }.take(2).toList();
      return districts.isEmpty
          ? "Rechercher un point à $city"
          : "Rechercher un point à $city (${districts.join(", ")}…)";
    }

    final counts = <String, int>{};
    for (final p in points) {
      if (p.city case final c?) counts[c] = (counts[c] ?? 0) + 1;
    }
    final cities =
        (counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!)))
            .take(3);
    return cities.isEmpty
        ? "Rechercher une ville, un quartier ou un point"
        : "Rechercher une ville ou un quartier (${cities.join(", ")}…)";
  }

  Future<void> _locateUser() async {
    final position = await ref.read(userLocationProvider.notifier).refresh();
    if (!mounted) return;
    if (position == null) {
      showAppSnackBar(
        context,
        "Activez la localisation pour voir les points autour de vous.",
        error: true,
      );
      return;
    }
    if (_mapReady) _map.move(position, 14.5);
  }

  void _focusPoint(MapPoint point) {
    _collapseSheet();
    if (_mapReady) _map.move(point.latLng, _pointZoom);
  }

  void _toggleSheet() => _animateSheet(_expanded ? _minSize : _maxSize);

  void _collapseSheet() => _animateSheet(_minSize);

  void _animateSheet(double size) {
    if (!_sheet.isAttached) return;
    _sheet.animateTo(
      size,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.search,
    required this.searchHint,
    required this.category,
    required this.filter,
    required this.onQueryChanged,
    required this.onCategoryChanged,
    required this.onFilterChanged,
  });
  final TextEditingController search;
  final String searchHint;
  final MapPointCategory category;
  final Object? filter;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<MapPointCategory> onCategoryChanged;
  final ValueChanged<Object?> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final filters = category == MapPointCategory.relay
        ? const [
            WasteMaterial.plastic,
            WasteMaterial.metal,
            WasteMaterial.paper,
            WasteMaterial.glass,
          ]
        : RecyclingKind.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SearchField(
          controller: search,
          hint: searchHint,
          onChanged: onQueryChanged,
        ),
        const SizedBox(height: 10),
        _Floating(
          child: PillTabs(
            selected: category.index,
            onChanged: (i) => onCategoryChanged(MapPointCategory.values[i]),
            tabs: const [
              PillTab("Points de dépôt", icon: LucideIcons.leaf),
              PillTab("Points de recyclage", icon: LucideIcons.layers),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final value = filters[i];
              final selected = value == filter;
              return _FilterChip(
                label: switch (value) {
                  final WasteMaterial m => m.label,
                  final RecyclingKind k => k.label,
                  _ => "",
                },
                selected: selected,
                color: category == MapPointCategory.relay
                    ? Theme.of(context).colorScheme.primary
                    : context.info,
                onTap: () => onFilterChanged(selected ? null : value),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Ombre légère pour détacher les contrôles de la carte.
class _Floating extends StatelessWidget {
  const _Floating({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
  });
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    return _Floating(
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintMaxLines: 1,
            hintStyle: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(LucideIcons.x, size: 18),
                    onPressed: () {
                      controller.clear();
                      onChanged("");
                    },
                  ),
            filled: true,
            fillColor: scheme.surface,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color : scheme.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? color : scheme.outlineVariant),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _LocateButton extends StatelessWidget {
  const _LocateButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      shape: const CircleBorder(),
      elevation: 3,
      child: IconButton(
        tooltip: "Ma position",
        onPressed: onPressed,
        icon: Icon(LucideIcons.navigation, color: context.info, size: 20),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}

class _OsmAttribution extends StatelessWidget {
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      color: Colors.white.withValues(alpha: 0.7),
      child: const Text(
        "© OpenStreetMap",
        style: TextStyle(fontSize: 9, color: Colors.black87),
      ),
    );
  }
}

class _NearbySheet extends StatelessWidget {
  const _NearbySheet({
    required this.scrollController,
    required this.category,
    required this.points,
    required this.visible,
    required this.location,
    required this.expanded,
    required this.onToggle,
    required this.onRetry,
    required this.onFocus,
    required this.onDetails,
  });
  final ScrollController scrollController;
  final MapPointCategory category;
  final AsyncValue<List<MapPoint>> points;
  final List<MapPoint> visible;
  final LatLng? location;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onRetry;
  final ValueChanged<MapPoint> onFocus;
  final ValueChanged<MapPoint> onDetails;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final relay = category == MapPointCategory.relay;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Points proches (${visible.length})",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Pill(
                  label: relay ? "Points relais pesée" : "Centres recyclage",
                  color: relay ? context.primaryText : context.info,
                  background: relay ? context.primarySoft : context.infoSoft,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onToggle,
                iconAlignment: IconAlignment.end,
                icon: Icon(
                  expanded ? LucideIcons.chevronDown : LucideIcons.chevronUp,
                  size: 16,
                ),
                label: Text(
                  expanded ? "Réduire" : "Voir tout",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _Legend(),
          const SizedBox(height: 12),
          ...switch (points) {
            AsyncError(:final error) => [
              ErrorCard(error: error, onRetry: onRetry),
            ],
            AsyncLoading() => const [
              Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            AsyncData() when visible.isEmpty => [
              EmptyState(
                icon: LucideIcons.mapPin,
                title: "Aucun point trouvé",
                message: relay
                    ? "Aucun point relais ne correspond à votre recherche."
                    : "Aucun lieu de recyclage ne correspond à votre "
                          "recherche.",
              ),
            ],
            AsyncData() => [
              for (final point in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MapPointCard(
                    point: point,
                    distance: location == null
                        ? null
                        : point.distanceFrom(location!),
                    onTap: () => onFocus(point),
                    onDetails: () => onDetails(point),
                  ),
                ),
            ],
          },
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget item(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 6,
        children: [
          item(scheme.primary, "Points relais (dépôt & pesée)"),
          item(context.info, "Recyclage (information)"),
        ],
      ),
    );
  }
}
