import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../domain/entities/cart_delivery_address.dart';

/// Taobao-style cart header: where the order ships to. Tapping opens the
/// cart-scoped address list; the address itself is a preview only — checkout
/// chooses the authoritative address at placement.
class CartDeliveryHeader extends StatelessWidget {
  const CartDeliveryHeader({
    super.key,
    required this.address,
    required this.onTap,
    this.loading = false,
  });

  final CartDeliveryAddress? address;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final place = address;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.br8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                place == null
                    ? (loading
                        ? 'Loading delivery address…'
                        : 'Add a delivery address')
                    : 'Deliver to ${place.label} · ${place.city}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
