import 'package:flutter/material.dart';

import '../../domain/money.dart';
import '../theme/app_dimensions.dart';

/// Honest store-promise rows (HANDOFF-UX-VISUAL §2): only verifiable facts —
/// the platform delivery fee, supported payment methods and the
/// single-seller identity. Shared by product detail and the cart, which
/// additionally appends a Help & support row when [onSupportTap] is set.
///
/// No warranty, ETA, returns or social-proof claims: the reference app's
/// marketing copy is deliberately not reproduced.
class StorePromisesCard extends StatelessWidget {
  const StorePromisesCard({
    super.key,
    required this.deliveryFeeMinor,
    this.onSupportTap,
  });

  /// Null while loading or on failure — the row falls back to "calculated at
  /// checkout" rather than inventing a fee.
  final int? deliveryFeeMinor;

  /// When provided, a Help & support row is appended and tapping it invokes
  /// this callback. Product detail leaves it null (3 rows); the cart passes
  /// the router push.
  final VoidCallback? onSupportTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final delivery = switch (deliveryFeeMinor) {
      null => 'Calculated at checkout',
      0 => 'Free delivery',
      final fee => '${Money(fee).formatUsd()} platform delivery fee',
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          PromiseRow(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery',
            subtitle: delivery,
          ),
          Divider(
            height: AppSpacing.md,
            color: theme.colorScheme.outlineVariant,
          ),
          const PromiseRow(
            icon: Icons.qr_code_2,
            title: 'Secure payment',
            subtitle: 'Cash on delivery or KHQR',
          ),
          Divider(
            height: AppSpacing.md,
            color: theme.colorScheme.outlineVariant,
          ),
          const PromiseRow(
            icon: Icons.storefront_outlined,
            title: 'Sold by R67',
            subtitle: 'Official single-seller storefront',
          ),
          if (onSupportTap != null) ...[
            Divider(
              height: AppSpacing.md,
              color: theme.colorScheme.outlineVariant,
            ),
            PromiseRow(
              icon: Icons.headset_mic_outlined,
              title: 'Help & support',
              subtitle: 'Talk to us about an order or payment',
              onTap: onSupportTap,
            ),
          ],
        ],
      ),
    );
  }
}

/// One compact promise row — icon, title, supporting line, optional chevron.
class PromiseRow extends StatelessWidget {
  const PromiseRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
    if (onTap == null) return content;
    return InkWell(onTap: onTap, borderRadius: AppRadii.br8, child: content);
  }
}
