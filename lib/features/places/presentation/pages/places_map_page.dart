import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:latlong2/latlong.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../l10n/app_localizations.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../../../shared/presentation/widgets/others/skeleton.dart";
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
  // Hauteur de la recherche et des chips en haut de carte.
  static const _topOverlayHeight = 116.0;
  // En dessous de ce zoom, les pins s'affichent sans leur nom.
  static const _labelZoom = 14.5;
  // Hauteur visible de la liste repliée (poignée + titre).
  static const _sheetPeek = 78.0;

  final _map = MapController();
  final _sheet = DraggableScrollableController();
  final _search = TextEditingController();

  var _mapReady = false;
  var _showLabels = false;
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
    final l10n = context.l10n;
    final points = ref.watch(mapPointsProvider);
    final location = ref.watch(userLocationProvider).value;

    ref
      ..listen(userLocationProvider, (_, _) => _autoCenter())
      ..listen(mapPointsProvider, (_, _) => _autoCenter());

    final visible = _visiblePoints(points.value ?? const [], location);
    final searchHint = _searchHint(points.value ?? const [], location, l10n);

    return LayoutBuilder(
      builder: (context, constraints) {
        // La barre du bas passe par-dessus la page (extendBody).
        final navHeight = MediaQuery.paddingOf(context).bottom;
        // La carte passe sous la barre d'état, mais pas les contrôles.
        final statusBarHeight = MediaQuery.paddingOf(context).top;
        final topOverlay = statusBarHeight + _topOverlayHeight;
        final sheetArea = constraints.maxHeight - navHeight;
        final minSize = _minSize = (_sheetPeek / sheetArea).clamp(0.05, 0.4);
        final maxSize = _maxSize = ((sheetArea - topOverlay) / sheetArea).clamp(
          minSize + 0.1,
          1.0,
        );

        return Stack(
          children: [
            Positioned.fill(child: _buildMap(visible, location)),
            Positioned(
              left: AppSpacing.sm,
              bottom: navHeight + _sheetPeek + AppSpacing.xs,
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
                  onRoute: _openRoute,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: statusBarHeight + AppSpacing.md,
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
            // Le bouton suit le haut de la liste, puis disparaît quand elle
            // monte trop haut, comme sur Google Maps.
            Positioned.fill(
              bottom: navHeight,
              child: ListenableBuilder(
                listenable: _sheet,
                builder: (context, _) {
                  final size = _sheet.isAttached ? _sheet.size : minSize;
                  final hidden = size > (minSize + maxSize) / 2;
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: AppSpacing.lg,
                        bottom: size * sheetArea + AppSpacing.md,
                      ),
                      child: AnimatedScale(
                        scale: hidden ? 0 : 1,
                        duration: AppSpacing.durationFast,
                        child: _LocateButton(onPressed: _locateUser),
                      ),
                    ),
                  );
                },
              ),
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
        onPositionChanged: (camera, _) {
          final show = camera.zoom >= _labelZoom;
          if (show != _showLabels) setState(() => _showLabels = show);
        },
      ),
      children: [
        // Tuiles OSM sans clé d'API ; le mode sombre inverse les couleurs.
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.secondlife.second_life",
          tileBuilder: context.isDarkMode ? darkModeTileBuilder : null,
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
                alignment: MapPointMarker.alignment,
                child: MapPointMarker(
                  point: point,
                  showLabel: _showLabels,
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
  String _searchHint(
    List<MapPoint> points,
    LatLng? location,
    AppLocalizations l10n,
  ) {
    final nearest = location == null ? null : _nearest(points, location);
    final city = nearest?.city;
    if (city != null &&
        nearest!.distanceFrom(location!) <= _maxAutoCenterMeters) {
      final districts = {
        for (final p in points)
          if (p.city == city) ?p.district,
      }.take(2).toList();
      return districts.isEmpty
          ? l10n.placesSearchHintCity(city)
          : l10n.placesSearchHintCityDistricts(city, districts.join(", "));
    }

    final counts = <String, int>{};
    for (final p in points) {
      if (p.city case final c?) counts[c] = (counts[c] ?? 0) + 1;
    }
    final cities =
        (counts.keys.toList()..sort((a, b) => counts[b]!.compareTo(counts[a]!)))
            .take(3);
    return cities.isEmpty
        ? l10n.placesSearchHintDefault
        : l10n.placesSearchHintCities(cities.join(", "));
  }

  Future<void> _locateUser() async {
    final position = await ref.read(userLocationProvider.notifier).refresh();
    if (!mounted) return;
    if (position == null) {
      showAppSnackBar(context, context.l10n.placesLocateError, error: true);
      return;
    }
    if (_mapReady) _map.move(position, 14.5);
  }

  Future<void> _openRoute(MapPoint point) async {
    final opened = await launchUrl(
      Uri.https("www.google.com", "/maps/dir/", {
        "api": "1",
        "destination": "${point.latitude},${point.longitude}",
      }),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      showAppSnackBar(
        context,
        context.l10n.placeDetailLaunchError,
        error: true,
      );
    }
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
      duration: AppSpacing.durationBase,
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
    final l10n = context.l10n;
    final scheme = context.colorScheme;
    final relay = category == MapPointCategory.relay;
    final filters = relay
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
        Padding(
          padding: AppSpacing.insetHLg,
          child: _SearchField(
            controller: search,
            hint: searchHint,
            onChanged: onQueryChanged,
          ),
        ),
        AppSpacing.gapVSm,
        SizedBox(
          height: AppSpacing.chipHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: AppSpacing.insetHLg,
            children: [
              _FilterChip(
                label: l10n.placesCategoryRelay,
                icon: LucideIcons.leaf,
                selected: relay,
                filled: true,
                color: scheme.primary,
                soft: context.primarySoft,
                onTap: () => onCategoryChanged(MapPointCategory.relay),
              ),
              AppSpacing.gapHSm,
              _FilterChip(
                label: l10n.placesCategoryRecycling,
                icon: LucideIcons.layers,
                selected: !relay,
                filled: true,
                color: context.info,
                soft: context.infoSoft,
                onTap: () => onCategoryChanged(MapPointCategory.recycling),
              ),
              AppSpacing.gapHSm,
              Container(
                width: AppSpacing.borderWidthBase,
                margin: AppSpacing.insetVSm,
                color: scheme.outline,
              ),
              AppSpacing.gapHSm,
              for (final value in filters) ...[
                _FilterChip(
                  label: switch (value) {
                    final WasteMaterial m => m.label(l10n),
                    final RecyclingKind k => k.label(l10n),
                    _ => "",
                  },
                  icon: switch (value) {
                    final WasteMaterial m => m.icon,
                    final RecyclingKind k => k.icon,
                    _ => null,
                  },
                  selected: value == filter,
                  color: switch (value) {
                    final RecyclingKind k => k.colors(context).$1,
                    _ => context.primaryText,
                  },
                  soft: switch (value) {
                    final RecyclingKind k => k.colors(context).$2,
                    _ => context.primarySoft,
                  },
                  onTap: () => onFilterChanged(value == filter ? null : value),
                ),
                AppSpacing.gapHSm,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// Ombre légère pour détacher les contrôles de la carte.
class _Floating extends StatelessWidget {
  const _Floating({required this.child, this.radius = AppSpacing.roundedXl});
  final Widget child;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: context.isDarkMode
            ? AppSpacing.shadowFloatingDark
            : AppSpacing.shadowFloating,
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
    final scheme = context.colorScheme;
    final textTheme = context.textTheme;
    const border = OutlineInputBorder(
      borderRadius: AppSpacing.roundedFull,
      borderSide: BorderSide.none,
    );
    return _Floating(
      radius: AppSpacing.roundedFull,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, _) => TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintMaxLines: 1,
            hintStyle: textTheme.bodyMedium!.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            prefixIcon: Icon(
              LucideIcons.search,
              size: AppSpacing.iconMd,
              color: scheme.onSurfaceVariant,
            ),
            suffixIcon: value.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(LucideIcons.x, size: AppSpacing.iconMd),
                    onPressed: () {
                      controller.clear();
                      onChanged("");
                    },
                  ),
            filled: true,
            fillColor: scheme.surface,
            isDense: true,
            contentPadding: AppSpacing.insetVLg,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
          ),
        ),
      ),
    );
  }
}

// Chip de catégorie (pleine) ou de filtre (teintée), avec ombre comme sur
// Google Maps.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.soft,
    required this.onTap,
    this.icon,
    this.filled = false,
  });
  final String label;
  final IconData? icon;
  final bool selected;
  final bool filled;
  final Color color;
  final Color soft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final foreground = !selected
        ? scheme.onSurface
        : filled
        ? scheme.onPrimary
        : color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.durationFast,
        padding: AppSpacing.insetHMd,
        decoration: BoxDecoration(
          color: !selected
              ? scheme.surface
              : filled
              ? color
              : soft,
          borderRadius: AppSpacing.roundedFull,
          border: selected && !filled ? Border.all(color: color) : null,
          boxShadow: context.isDarkMode
              ? AppSpacing.shadowFloatingDark
              : AppSpacing.shadowFloating,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSpacing.iconSm, color: foreground),
              AppSpacing.gapHXs,
            ],
            Text(
              label,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ],
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
    final scheme = context.colorScheme;
    return Material(
      color: scheme.surface,
      shape: const CircleBorder(),
      elevation: AppSpacing.elevationMd,
      child: IconButton(
        tooltip: context.l10n.placesLocateTooltip,
        onPressed: onPressed,
        icon: Icon(
          LucideIcons.locateFixed,
          color: context.info,
          size: AppSpacing.iconMd,
        ),
        padding: AppSpacing.insetMd,
      ),
    );
  }
}

class _OsmAttribution extends StatelessWidget {
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: AppSpacing.roundedXs,
      ),
      child: Text(
        "© OpenStreetMap",
        style: context.textTheme.labelSmall!.copyWith(color: Colors.black87),
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
    required this.onRoute,
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
  final ValueChanged<MapPoint> onRoute;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.colorScheme;
    final relay = category == MapPointCategory.relay;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXxl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkMode ? 0.28 : 0.12,
            ),
            blurRadius: AppSpacing.lg,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.huge,
        ),
        children: [
          Center(
            child: Container(
              margin: AppSpacing.insetVSm,
              width: AppSpacing.huge,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: AppSpacing.roundedXs,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                l10n.placesNearbyCount(visible.length),
                style: context.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapHSm,
              Flexible(
                child: Pill(
                  label: relay
                      ? l10n.placesPillRelay
                      : l10n.placesPillRecycling,
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
                  size: AppSpacing.iconSm,
                ),
                label: Text(
                  expanded ? l10n.placesCollapse : l10n.placesSeeAll,
                  style: context.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapVMd,
          ...switch (points) {
            AsyncError(:final error) => [
              ErrorCard(error: error, onRetry: onRetry),
            ],
            AsyncLoading() => [
              SkeletonLoader(
                child: SkeletonList(
                  itemCount: 4,
                  itemBuilder: (_, _) => const SkeletonCard(showAvatar: true),
                ),
              ),
            ],
            AsyncData() when visible.isEmpty => [
              EmptyState(
                icon: LucideIcons.mapPin,
                title: l10n.placesEmptyTitle,
                message: relay
                    ? l10n.placesEmptyRelay
                    : l10n.placesEmptyRecycling,
              ),
            ],
            AsyncData() => [
              for (final point in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: MapPointCard(
                    point: point,
                    distance: location == null
                        ? null
                        : point.distanceFrom(location!),
                    onTap: () => onFocus(point),
                    onDetails: () => onDetails(point),
                    onRoute: () => onRoute(point),
                  ),
                ),
            ],
          },
        ],
      ),
    );
  }
}
