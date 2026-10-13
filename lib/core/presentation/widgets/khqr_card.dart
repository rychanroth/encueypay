import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

/// NBC Bakong KHQR payment card (DESIGN.md §6.4): official red header bar,
/// EMV-compliant QR payload, merchant identity and the dynamic amount in the
/// dual-currency display (§1.4). Pure presentation — the payload and display
/// strings arrive resolved from the checkout feature; `core` holds no
/// feature imports (ARCH-05).
class KhqrCard extends StatelessWidget {
  const KhqrCard({
    super.key,
    required this.qrPayload,
    required this.amountUsd,
    required this.amountKhr,
    this.merchantName = 'EncueYPay Prototype',
  });

  /// EMVCo payload built by the checkout data layer (`KhqrGenerator`).
  final String qrPayload;
  final String amountUsd;
  final String amountKhr;
  final String merchantName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.khqrBg,
        borderRadius: AppRadii.br16,
        boxShadow: AppElevation.sheet,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Official KHQR red header bar.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            color: AppColors.khqrRed,
            child: Row(
              children: [
                Text(
                  'KHQR',
                  style: AppTypography.titleLarge.copyWith(
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'BAKONG',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Text(
                  merchantName,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  amountUsd,
                  style: AppTypography.priceHighlight.copyWith(
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '≈ $amountKhr',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: AppRadii.br8,
                  ),
                  child: QrImageView(
                    data: qrPayload,
                    size: 220,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Scan with any Bakong-connected banking app',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryLight,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
