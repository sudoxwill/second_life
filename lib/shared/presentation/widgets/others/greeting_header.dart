import "package:flutter/material.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/index.dart";
import "../../../../core/utils/formatters.dart";

// En-tête des accueils : avatar à initiales, "Bonjour" au-dessus du nom.
// Le nom tient sur une ligne et se coupe proprement s'il est long ; un appui
// long l'affiche en entier.
class GreetingHeader extends StatelessWidget {
  const GreetingHeader({required this.name, super.key, this.onAvatarTap});

  final String name;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    return Row(
      children: [
        Tooltip(
          message: name,
          child: InkResponse(
            onTap: onAvatarTap,
            radius: 28,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: context.primarySoft,
              child: Text(
                Formatters.initials(name),
                style: textTheme.titleSmall!.copyWith(
                  color: context.primaryText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        AppSpacing.gapHMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.homeGreetingHello,
                style: textTheme.bodyMedium!.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Tooltip(
                message: name,
                triggerMode: TooltipTriggerMode.longPress,
                child: AnimatedSwitcher(
                  duration: AppSpacing.durationFast,
                  child: Text(
                    name,
                    key: ValueKey(name),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
