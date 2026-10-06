import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";

import "../../../../core/theme/index.dart";

// QR code blanc sur fond vert foncé, avec l'identifiant en dessous.
// Sans [data], affiche un QR grisé en attendant la création du dépôt.
class TicketQrCard extends StatelessWidget {
  const TicketQrCard({
    required this.data,
    required this.caption,
    super.key,
    this.size = 150,
  });
  final String? data;
  final String caption;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = data == null;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF173A2D),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Opacity(
              opacity: placeholder ? 0.25 : 1,
              child: QrImageView(
                data: data ?? "recycling-ticket:en-attente",
                size: size,
                padding: EdgeInsets.zero,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: AppColors.primary,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            caption,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontFamily: "monospace",
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
