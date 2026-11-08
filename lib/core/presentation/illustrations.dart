import 'package:flutter/material.dart';

/// Ledger-line state illustrations (docs/brand/BRAND.md §8).
///
/// Each entry carries a light and a dark export so empty states stay legible
/// on both surface tokens without runtime color filters.
@immutable
class AppIllustration {
  const AppIllustration({required this.light, required this.dark});

  final String light;
  final String dark;

  String resolve(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

/// Asset paths for the shared empty-state vocabulary. Use with
/// `EmptyStateView(illustration: ...)`.
abstract final class AppIllustrations {
  static const emptyCart = AppIllustration(
    light: 'assets/illustrations/empty-cart.png',
    dark: 'assets/illustrations/dark/empty-cart.png',
  );

  static const noOrders = AppIllustration(
    light: 'assets/illustrations/no-orders.png',
    dark: 'assets/illustrations/dark/no-orders.png',
  );

  static const emptyWishlist = AppIllustration(
    light: 'assets/illustrations/empty-wishlist.png',
    dark: 'assets/illustrations/dark/empty-wishlist.png',
  );

  static const noSearch = AppIllustration(
    light: 'assets/illustrations/no-search.png',
    dark: 'assets/illustrations/dark/no-search.png',
  );

  static const noNotifications = AppIllustration(
    light: 'assets/illustrations/no-notifications.png',
    dark: 'assets/illustrations/dark/no-notifications.png',
  );

  static const noProducts = AppIllustration(
    light: 'assets/illustrations/no-products.png',
    dark: 'assets/illustrations/dark/no-products.png',
  );

  static const offline = AppIllustration(
    light: 'assets/illustrations/offline.png',
    dark: 'assets/illustrations/dark/offline.png',
  );

  static const error = AppIllustration(
    light: 'assets/illustrations/error.png',
    dark: 'assets/illustrations/dark/error.png',
  );

  static const verified = AppIllustration(
    light: 'assets/illustrations/verified.png',
    dark: 'assets/illustrations/dark/verified.png',
  );
}
