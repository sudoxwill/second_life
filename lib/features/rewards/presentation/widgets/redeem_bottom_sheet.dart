import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

import "../../../../core/extensions/build_context_extension.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/buttons/app_elevated_button.dart";
import "../../../../shared/presentation/widgets/inputs/app_text_form_field.dart";
import "../../domain/entities/points_conversion.dart";
import "../../domain/entities/redemption_voucher.dart";
import "../../domain/entities/reward_card.dart";
import "../../domain/entities/reward_category.dart";
import "../../domain/entities/reward_tier.dart";
import "../providers/rewards_provider.dart";

/// Feuille modale guidant l'utilisateur pour l'échange de ses points.
class RedeemBottomSheet extends ConsumerStatefulWidget {
  const RedeemBottomSheet({required this.card, this.initialTier, super.key});

  final RewardCard card;
  final RewardTier? initialTier;

  /// Ouvre la modale d'échange.
  static Future<void> show(
    BuildContext context, {
    required RewardCard card,
    RewardTier? initialTier,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          RedeemBottomSheet(card: card, initialTier: initialTier),
    );
  }

  @override
  ConsumerState<RedeemBottomSheet> createState() => _RedeemBottomSheetState();
}

class _RedeemBottomSheetState extends ConsumerState<RedeemBottomSheet> {
  late RewardTier _selectedTier;
  final _recipientController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  RedemptionVoucher? _generatedVoucher;

  @override
  void initState() {
    super.initState();
    _selectedTier = widget.initialTier ?? widget.card.lowestTier;
  }

  @override
  void dispose() {
    _recipientController.dispose();
    super.dispose();
  }

  Future<void> _confirmRedemption() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recipient = _recipientController.text.trim().isNotEmpty
          ? _recipientController.text.trim()
          : null;

      final voucher = await ref
          .read(rewardsNotifierProvider.notifier)
          .redeemCard(
            card: widget.card,
            tier: _selectedTier,
            recipient: recipient,
          );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _generatedVoucher = voucher;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().replaceFirst("Exception: ", "");
        });
      }
    }
  }

  void _copyVoucherCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Code $code copié dans le presse-papiers"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final rewardsState = ref.watch(rewardsNotifierProvider);
    final userPoints = rewardsState.userPoints;

    final hasEnoughPoints = userPoints >= _selectedTier.pointsCost;
    final missingPoints = _selectedTier.pointsCost - userPoints;

    return Container(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.viewInsetsOf(context).bottom +
            AppSpacing.bottomSheetPadding.bottom,
        left: AppSpacing.bottomSheetPadding.left,
        right: AppSpacing.bottomSheetPadding.right,
        top: AppSpacing.bottomSheetPadding.top,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppSpacing.roundedTopLg,
      ),
      child: AnimatedSwitcher(
        duration: AppSpacing.durationBase,
        child: _generatedVoucher != null
            ? _buildSuccessView(context, _generatedVoucher!)
            : _buildFormView(
                context,
                userPoints: userPoints,
                hasEnoughPoints: hasEnoughPoints,
                missingPoints: missingPoints,
              ),
      ),
    );
  }

  Widget _buildFormView(
    BuildContext context, {
    required int userPoints,
    required bool hasEnoughPoints,
    required int missingPoints,
  }) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final String recipientLabel;
    final String recipientHint;
    final IconData recipientIcon;

    switch (widget.card.category) {
      case RewardCategory.education:
        recipientLabel = "Nom de l'élève & classe (optionnel)";
        recipientHint = "Ex: Koffi Mensah — CM2";
        recipientIcon = LucideIcons.graduationCap;
      case RewardCategory.health:
        recipientLabel = "Nom du patient (optionnel)";
        recipientHint = "Ex: Patient ou membre du foyer";
        recipientIcon = LucideIcons.heartPulse;
      case RewardCategory.food:
      case RewardCategory.hygieneWater:
      case RewardCategory.all:
        recipientLabel = "Nom du foyer bénéficiaire (optionnel)";
        recipientHint = "Ex: Famille Mensah";
        recipientIcon = LucideIcons.users;
    }

    return Column(
      key: const ValueKey("form_view"),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: AppSpacing.roundedFull,
            ),
          ),
        ),
        AppSpacing.gapVLg,

        // Titre de la récompense
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: AppSpacing.roundedMd,
              ),
              child: Icon(
                widget.card.category.icon,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.card.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.card.brand,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.gapVLg,

        // Sélection du palier de montant
        Text(
          "Choisissez votre montant :",
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        AppSpacing.gapVSm,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: widget.card.tiers.map((tier) {
            final isSelected = tier.id == _selectedTier.id;
            return ChoiceChip(
              label: Text("${tier.name} (${tier.pointsCost} pts)"),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedTier = tier;
                  });
                }
              },
              selectedColor: colorScheme.primary,
              backgroundColor: colorScheme.surfaceContainer,
              labelStyle: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppSpacing.roundedMd,
                side: BorderSide(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                ),
              ),
            );
          }).toList(),
        ),
        AppSpacing.gapVLg,

        // Champ destinataire optionnel selon le type
        AppTextFormField(
          controller: _recipientController,
          labelText: recipientLabel,
          hintText: recipientHint,
          prefixIconData: recipientIcon,
        ),
        AppSpacing.gapVLg,

        // Récapitulatif du solde
        Container(
          padding: AppSpacing.cardPaddingCompact,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: AppSpacing.roundedMd,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Votre solde actuel", style: textTheme.bodySmall),
                  Text(
                    PointsConversion.formatPoints(userPoints),
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapVXs,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Coût de l'échange", style: textTheme.bodySmall),
                  Text(
                    "- ${PointsConversion.formatPoints(_selectedTier.pointsCost)}",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Solde restant",
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    hasEnoughPoints
                        ? PointsConversion.formatPoints(
                            userPoints - _selectedTier.pointsCost,
                          )
                        : "Insuffisant",
                    style: textTheme.bodyMedium?.copyWith(
                      color: hasEnoughPoints
                          ? colorScheme.primary
                          : colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (!hasEnoughPoints) ...[
          AppSpacing.gapVMd,
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.5),
              borderRadius: AppSpacing.roundedSm,
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  size: 16,
                  color: colorScheme.error,
                ),
                AppSpacing.gapHSm,
                Expanded(
                  child: Text(
                    "Il vous manque $missingPoints points pour cet échange. Continuez à trier pour en gagner !",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (_errorMessage != null) ...[
          AppSpacing.gapVMd,
          Text(
            _errorMessage!,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
          ),
        ],

        AppSpacing.gapVXl,

        // Bouton de confirmation
        AppElevatedButton(
          text: "Confirmer l'échange",
          isLoading: _isLoading,
          onPressed: hasEnoughPoints && !_isLoading ? _confirmRedemption : null,
        ),
      ],
    );
  }

  Widget _buildSuccessView(BuildContext context, RedemptionVoucher voucher) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      key: const ValueKey("success_view"),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icône de félicitations
        Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.checkCheck,
              size: 44,
              color: colorScheme.primary,
            ),
          ),
        ),
        AppSpacing.gapVLg,

        Center(
          child: Text(
            "Félicitations !",
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        AppSpacing.gapVXs,
        Center(
          child: Text(
            "Votre récompense a été débloquée avec succès.",
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppSpacing.gapVXl,

        // Boîte du code de bon généré
        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: AppSpacing.roundedLg,
            border: Border.all(
              color: colorScheme.secondary.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                "${voucher.rewardTitle} — ${voucher.tierName}",
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapVMd,
              SelectableText(
                voucher.voucherCode,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: colorScheme.primary,
                ),
              ),
              AppSpacing.gapVMd,
              InkWell(
                onTap: () => _copyVoucherCode(voucher.voucherCode),
                borderRadius: AppSpacing.roundedFull,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs + 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: AppSpacing.roundedFull,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.copy,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      AppSpacing.gapHSm,
                      Text(
                        "Copier le code",
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapVLg,

        Text(
          "Ce bon d'achat a été enregistré dans votre espace « Mes Cartes ».",
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapVXl,

        AppElevatedButton(
          text: "Terminer",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
