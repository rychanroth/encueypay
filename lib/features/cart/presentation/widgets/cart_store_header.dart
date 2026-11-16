import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';

/// Single-seller store header above the cart lines. The app has no shop
/// model (single-seller retirement, 2026-10-13), so the group header is the
/// official storefront — tapping returns to the storefront home.
class CartStoreHeader extends StatelessWidget {
  const CartStoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.storefront_outlined,
          size: 18,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'R67 Official Store',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => context.goNamed(AppRoutes.home),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          child: const Text('Visit store'),
        ),
      ],
    );
  }
}
