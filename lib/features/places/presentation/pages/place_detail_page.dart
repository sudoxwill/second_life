import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../core/extensions/navigation_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../shared/presentation/widgets/buttons/index.dart";
import "../../../../shared/presentation/widgets/others/app_card.dart";
import "../../../../shared/presentation/widgets/others/feedback_views.dart";
import "../../domain/entities/map_point.dart";
import "../providers/map_points_provider.dart";
import "../providers/user_location_provider.dart";
import "../widgets/map_point_card.dart";
import "../widgets/map_point_style.dart";

// Fiche d'un point relais ou d'un lieu de recyclage.
class PlaceDetailPage extends ConsumerWidget {
  const PlaceDetailPage({required this.id, super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final point = ref.watch(mapPointByIdProvider(id));
    return Scaffold(
      body: switch (point) {
        AsyncData(value: final p?) => _PlaceDetail(point: p),
        AsyncData() => const _Message(
          child: EmptyState(
            icon: LucideIcons.mapPin,
            title: "Point introuvable",
            message: "Ce point n’existe plus ou n’est plus actif.",
          ),
        ),
        AsyncError(:final error) => _Message(
          child: ErrorCard(
            error: error,
            onRetry: ref.read(mapPointsProvider.notifier).refresh,
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: context.popScreen,
            icon: const Icon(LucideIcons.arrowLeft),
          ),
          Expanded(
            child: Center(
              child: Padding(padding: const EdgeInsets.all(20), child: child),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceDetail extends ConsumerWidget {
  const _PlaceDetail({required this.point});
  final MapPoint point;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final location = ref.watch(userLocationProvider).value;
    final now = DateTime.now();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(
            point: point,
            distance: location == null ? null : point.distanceFrom(location),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          sliver: SliverList.list(
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            point.name,
                            style: AppTextStyles.heading(22),
                          ),
                        ),
                        if (point.hasHours) ...[
                          const SizedBox(width: 8),
                          OpenStatusPill(open: point.isOpenAt(now)),
                        ],
                      ],
                    ),
                    if (point.address.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _InfoLine(icon: LucideIcons.mapPin, text: point.address),
                    ],
                    if (point.phone case final phone?) ...[
                      const SizedBox(height: 8),
                      _InfoLine(
                        icon: LucideIcons.phone,
                        text: phone,
                        onTap: () => _launch(
                          context,
                          Uri(scheme: "tel", path: phone.replaceAll(" ", "")),
                        ),
                      ),
                    ],
                    if (point.description case final description?) ...[
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (point.hasAgentOn(now)) ...[
                      const SizedBox(height: 14),
                      _AgentBanner(),
                    ],
                  ],
                ),
              ),
              if (point.acceptedMaterials.isNotEmpty) ...[
                const SizedBox(height: 14),
                _MaterialsCard(point: point),
              ],
              if (point.hasHours) ...[
                const SizedBox(height: 14),
                _HoursCard(point: point),
              ],
              const SizedBox(height: 20),
              AppElevatedButton(
                onPressed: () => _launch(
                  context,
                  Uri.https("www.google.com", "/maps/dir/", {
                    "api": "1",
                    "destination": "${point.latitude},${point.longitude}",
                  }),
                ),
                icon: const Icon(LucideIcons.navigation, size: 18),
                text: "Ouvrir dans Maps (Itinéraire)",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launch(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      showAppSnackBar(
        context,
        "Impossible d’ouvrir cette application.",
        error: true,
      );
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.point, this.distance});
  final MapPoint point;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: point.softColor(context),
      child: Center(
        child: Icon(point.icon, size: 72, color: point.color(context)),
      ),
    );

    return SizedBox(
      height: 240,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (point.imageUrl case final url?)
            Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => placeholder,
            )
          else
            placeholder,
          // Assombrit le bas pour garder les pastilles lisibles.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0x66000000)],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: scheme.surface.withValues(alpha: 0.9),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: "Retour",
                    onPressed: context.popScreen,
                    icon: const Icon(LucideIcons.arrowLeft),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                Pill(
                  label: point.typeLabel,
                  icon: point.icon,
                  color: scheme.onPrimary,
                  background: point.color(context),
                ),
                if (distance != null)
                  Pill(
                    label: formatDistance(distance!),
                    color: scheme.onSurface,
                    background: scheme.surface,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text, this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.primaryText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, size: 18, color: context.primaryText),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Agent présent aujourd’hui (pesée certifiée immédiate)",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: context.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialsCard extends StatelessWidget {
  const _MaterialsCard({required this.point});
  final MapPoint point;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel("Types de déchets acceptés"),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final width = (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final material in point.acceptedMaterials)
                    Container(
                      width: width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            icon: LucideIcons.leaf,
                            color: scheme.onPrimary,
                            background: point.color(context),
                            size: 32,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              material.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard({required this.point});
  final MapPoint point;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.clock, size: 16, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              const SectionLabel("Horaires d’ouverture"),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.hoursLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: point.color(context),
                  ),
                ),
                if (point.hoursNote case final note?) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
