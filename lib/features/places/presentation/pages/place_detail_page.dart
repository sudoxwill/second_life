import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../core/extensions/build_context_extension.dart";
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
        AsyncData() => _Message(
          child: EmptyState(
            icon: LucideIcons.mapPin,
            title: context.l10n.placeDetailNotFound,
            message: context.l10n.placeDetailNotFoundMessage,
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
              child: Padding(padding: AppSpacing.insetXl, child: child),
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
    final scheme = context.colorScheme;
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxxl,
          ),
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
                            style: context.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (point.hasHours) ...[
                          AppSpacing.gapHSm,
                          OpenStatusPill(open: point.isOpenAt(now)),
                        ],
                      ],
                    ),
                    if (point.address.isNotEmpty) ...[
                      AppSpacing.gapVMd,
                      _InfoLine(icon: LucideIcons.mapPin, text: point.address),
                    ],
                    if (point.phone case final phone?) ...[
                      AppSpacing.gapVSm,
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
                      AppSpacing.gapVMd,
                      Text(
                        description,
                        style: context.textTheme.labelLarge!.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (point.hasAgentOn(now)) ...[
                      AppSpacing.gapVLg,
                      _AgentBanner(),
                    ],
                  ],
                ),
              ),
              if (point.acceptedMaterials.isNotEmpty) ...[
                AppSpacing.gapVLg,
                _MaterialsCard(point: point),
              ],
              if (point.hasHours) ...[
                AppSpacing.gapVLg,
                _HoursCard(point: point),
              ],
              AppSpacing.gapVXl,
              AppElevatedButton(
                onPressed: () => _launch(
                  context,
                  Uri.https("www.google.com", "/maps/dir/", {
                    "api": "1",
                    "destination": "${point.latitude},${point.longitude}",
                  }),
                ),
                icon: const Icon(LucideIcons.navigation, size: 18),
                text: context.l10n.placeDetailRoute,
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
        context.l10n.placeDetailLaunchError,
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
    final scheme = context.colorScheme;
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
                padding: AppSpacing.insetMd,
                child: Material(
                  color: scheme.surface.withValues(alpha: 0.9),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: context.l10n.commonBack,
                    onPressed: context.popScreen,
                    icon: const Icon(LucideIcons.arrowLeft),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
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
    final scheme = context.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedSm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: context.primaryText),
          AppSpacing.gapHSm,
          Expanded(
            child: Text(
              text,
              style: context.textTheme.labelLarge!.copyWith(
                color: scheme.onSurfaceVariant,
              ),
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
      padding: AppSpacing.insetMd,
      decoration: BoxDecoration(
        color: context.primarySoft,
        borderRadius: AppSpacing.roundedMd,
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.circleCheck,
            size: AppSpacing.iconSm,
            color: context.primaryText,
          ),
          AppSpacing.gapHSm,
          Expanded(
            child: Text(
              context.l10n.placeDetailAgentPresent,
              style: context.textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
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
    final scheme = context.colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionLabel(context.l10n.placeDetailMaterialsTitle),
          AppSpacing.gapVLg,
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = AppSpacing.sm;
              final width = (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final material in point.acceptedMaterials)
                    Container(
                      width: width,
                      padding: AppSpacing.insetSm,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: AppSpacing.roundedMd,
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          IconTile(
                            icon: LucideIcons.leaf,
                            color: scheme.onPrimary,
                            background: point.color(context),
                            size: AppSpacing.xxxl,
                          ),
                          AppSpacing.gapHSm,
                          Expanded(
                            child: Text(
                              material.label,
                              style: context.textTheme.labelLarge!.copyWith(
                                fontWeight: FontWeight.bold,
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
    final scheme = context.colorScheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.clock,
                size: AppSpacing.iconSm,
                color: scheme.onSurfaceVariant,
              ),
              AppSpacing.gapHSm,
              SectionLabel(context.l10n.placeDetailHoursTitle),
            ],
          ),
          AppSpacing.gapVMd,
          Container(
            width: double.infinity,
            padding: AppSpacing.insetMd,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  point.hoursLabel,
                  style: context.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: point.color(context),
                  ),
                ),
                if (point.hoursNote case final note?) ...[
                  AppSpacing.gapVXs,
                  Text(
                    note,
                    style: context.textTheme.labelMedium!.copyWith(
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
