import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/others/app_divider.dart";

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Column(
      spacing: AppSpacing.lg,
      children: [
        /// Main Card
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.roundedLg,
          ),
          color: AppColors.grassCourt,
          margin: .zero,
          child: Container(
            padding: AppSpacing.insetMd,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text("Mes points", style: textTheme.titleMedium),
                    InkWell(
                      borderRadius: AppSpacing.roundedXxl,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: AppSpacing.roundedXxl,
                          color: AppColors.neutral50.withValues(alpha: .2),
                        ),
                        child: Row(
                          spacing: AppSpacing.xs,
                          children: [
                            const Icon(
                              LucideIcons.gift,
                              size: AppSpacing.iconSm,
                            ),
                            Text(
                              "Échanger",
                              style: textTheme.bodySmall!.copyWith(
                                color: AppColors.neutral50,
                              ),
                            ),
                            const Icon(
                              LucideIcons.arrowUpRight,
                              size: AppSpacing.iconMd,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // FilledButton.icon(
                    //   style: FilledButton.styleFrom(
                    //     backgroundColor: AppColors.neutral50
                    //     .withValues(alpha: .2),
                    //     padding: EdgeInsets
                    //     .symmetric(horizontal: AppSpacing.sm),
                    //     iconColor: AppColors.neutral50,
                    //   ),
                    //   icon: const Icon(LucideIcons.gift),
                    //   label: const Text("Échanger", style: TextStyle(
                    //     color: AppColors.neutral50,
                    //   ),),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
                AppSpacing.gapVSm,
                Text(
                  "350 pts",
                  style: textTheme.headlineMedium!.copyWith(fontWeight: .bold),
                ),
                AppSpacing.gapVSm,
                Chip(
                  side: BorderSide.none,
                  backgroundColor: colorScheme.secondary.withValues(alpha: .2),
                  avatar: Icon(
                    LucideIcons.rotateCcwClock,
                    color: colorScheme.secondary,
                    size: AppSpacing.iconSm,
                  ),
                  label: Text(
                    "+80 pts en attende de validation",
                    style: TextStyle(color: colorScheme.secondary),
                    overflow: .ellipsis,
                  ),
                ),
                AppSpacing.gapVXs,
                Text(
                  "Non convertie en argent liquide. Échangeable contre des bons chez le partenaire.",
                  style: textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),

        /// Waiting deposit
        // Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: .spaceBetween,
        //       children: [
        //         Row(
        //           spacing: AppSpacing.sm,
        //           children: [
        //             const Text("Dépôts en attente"),
        //             Badge(
        //               label: Text(
        //                 "2",
        //                 style: TextStyle(color: colorScheme.onSecondary),
        //               ),
        //               backgroundColor: colorScheme.secondary,
        //             ),
        //           ],
        //         ),
        //         TextButton(onPressed: () {}, child: const Text("Voir plus")),
        //       ],
        //     ),
        //     ListView.builder(
        //       shrinkWrap: true,
        //       itemCount: 3,
        //       itemBuilder: (context, index) {
        //         return ListTile(
        //           contentPadding: AppSpacing.insetVXs,
        //           leading: Container(
        //             width: AppSpacing.mega,
        //             height: AppSpacing.mega,
        //             padding: AppSpacing.insetSm,
        //             decoration: BoxDecoration(
        //               color: colorScheme.secondary.withValues(alpha: .2),
        //               borderRadius: AppSpacing.roundedLg,
        //             ),
        //             child: Icon(
        //               LucideIcons.bottleWine,
        //               color: colorScheme.secondary,
        //             ),
        //           ),
        //           title: Text("Bouteille", style: textTheme.bodyLarge),
        //           trailing: Text(
        //             "+50 pts",
        //             style: textTheme.labelLarge!.copyWith(
        //               color: colorScheme.secondary,
        //             ),
        //           ),
        //           // subtitle: Text(
        //           //   "+50 pts",
        //           //   style: textTheme.labelLarge!.copyWith(
        //           //     color: colorScheme.secondary,
        //           //   ),
        //           // ),
        //         );
        //       },
        //     ),
        //   ],
        // ),
        Container(
          padding: AppSpacing.insetSm,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: .5),
            ),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              ListTile(
                leading: Container(
                  width: AppSpacing.mega,
                  height: AppSpacing.mega,
                  padding: AppSpacing.insetSm,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: .2),
                    borderRadius: AppSpacing.roundedLg,
                  ),
                  child: Icon(LucideIcons.clock, color: colorScheme.secondary),
                ),
                title: Row(
                  spacing: AppSpacing.md,
                  children: [
                    const Text("Dépôts en attente"),
                    Badge(
                      label: Text(
                        "2",
                        style: TextStyle(color: colorScheme.onSecondary),
                      ),
                      backgroundColor: colorScheme.secondary,
                    ),
                  ],
                ),
                trailing: const Icon(
                  LucideIcons.chevronRight,
                  size: AppSpacing.iconSm,
                ),
              ),
              const AppDivider(),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  Chip(
                    label: RichText(
                      text: TextSpan(
                        text: "Bouteille ",
                        style: textTheme.labelLarge,
                        children: [
                          TextSpan(
                            text: "+50 pts",
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Chip(
                    label: RichText(
                      text: TextSpan(
                        text: "Fer ",
                        style: textTheme.labelLarge,
                        children: [
                          TextSpan(
                            text: "+80 pts",
                            style: TextStyle(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        //
        Container(
          padding: AppSpacing.insetXs,
          decoration: BoxDecoration(
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: .5),
            ),
          ),
          child: ListTile(
            leading: Container(
              width: AppSpacing.mega,
              height: AppSpacing.mega,
              padding: AppSpacing.insetSm,
              decoration: BoxDecoration(
                borderRadius: AppSpacing.roundedLg,
                color: colorScheme.onSurface,
              ),
              child: Icon(LucideIcons.badgeInfo, color: colorScheme.surface),
            ),
            title: Text(
              "Chaque geste compte pour la planète.",
              style: textTheme.labelMedium,
            ),
            subtitle: Text(
              "Recyclez vos déchets plastiques et métalliques et récupérez "
              "des bons avec vos points de recyclage",
              style: textTheme.labelSmall,
            ),
          ),
        ),
      ],
    );
  }
}
