import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/domain/entities/user_role.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/catalog/domain/entities/product.dart';
import '../../../features/catalog/presentation/widgets/product_card.dart';
import '../../../features/dashboard/presentation/widgets/dashboard_overview_panel.dart';
import '../../../features/wishlist/domain/entities/wishlist_item.dart';
import '../../../features/wishlist/presentation/controllers/wishlist_controller.dart';
import '../../../features/profile/domain/entities/address.dart';
import '../../../features/profile/presentation/screens/address_edit_screen.dart';
import '../../../features/profile/presentation/screens/addresses_screen.dart';
import '../../../features/profile/presentation/screens/profile_edit_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/profile/presentation/screens/settings_screen.dart';
import '../../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../app_routes.dart';
import '../product_card_actions.dart';


/// Wishlist row → the synthetic Product the shared ProductCard renders.
/// Brand + rating aggregates ride along so wishlist/dashboard cards match
/// catalog cards (the item → Product mapping stays here in the composition
/// root — features never import each other, ARCH-04).
Product _productFromWishlist(WishlistItem item) => Product(
      id: item.productId,
      categoryId: '',
      name: item.productName,
      basePriceMinor: item.priceMinor,
      stock: item.stock,
      fromPriceMinor: item.priceMinor,
      defaultVariantId: item.defaultVariantId,
      brandName: item.brandName,
      ratingAvg: item.ratingAvg,
      reviewCount: item.reviewCount,
      status: item.status == 'archived'
          ? ProductStatus.archived
          : ProductStatus.active,
      imageUrls: [
        if (item.imageUrl != null) item.imageUrl!,
      ],
    );

/// Shared tab — Profile (all roles). Nested routes of this tab are declared
/// here (ROUTE-04).
///
/// The composition root wires the auth feature into Settings via callback
/// and passes the role in, so features/profile never imports features/auth
/// (ARCH-04, ROUTE-08).
final profileBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.profile,
      path: '/profile',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) {
          final role = ref.watch(
            authControllerProvider.select(
              (auth) => auth.value?.activeRole ?? UserRole.customer,
            ),
          );
          // Section 8A: the Profile tab IS the account overview. The
          // wishlist rail's cards are built here in the composition root
          // (interactive ProductCards; ARCH-04).
          final wishlistItems =
              ref.watch(wishlistControllerProvider).value ?? const [];
          Widget wishlistCard(WishlistItem item) {
            final product = _productFromWishlist(item);
            return ProductCard(
              product: product,
              onTap: () => context.pushNamed(
                AppRoutes.productDetail,
                pathParameters: {'id': item.productId},
              ),
              actions: productCardActions(context, ref, product),
            );
          }

          final wishlistCards = [
            for (final item in wishlistItems.take(6)) wishlistCard(item),
          ];
          return ProfileScreen(
            isCustomer: role == UserRole.customer,
            overviewPanel: role == UserRole.customer
                ? DashboardOverviewPanel(wishlistCards: wishlistCards)
                : null,
          );
        },
      ),
      routes: [
        GoRoute(
          name: AppRoutes.profileEdit,
          path: 'edit',
          builder: (context, state) => const ProfileEditScreen(),
        ),
        GoRoute(
          name: AppRoutes.addresses,
          path: 'addresses',
          builder: (context, state) => const AddressesScreen(),
        ),
        GoRoute(
          name: AppRoutes.addressEdit,
          path: 'addresses/edit',
          builder: (context, state) =>
              AddressEditScreen(address: state.extra as Address?),
        ),
        GoRoute(
          name: AppRoutes.wishlist,
          path: 'wishlist',
          builder: (context, state) => Consumer(
          builder: (context, ref, _) => WishlistScreen(
            // Section 6: the shared catalog ProductCard with long-press
            // quick actions. The item → Product mapping happens here in
            // the composition root — features stay isolated (ARCH-04).
            cardBuilder: (item) {
              final product = _productFromWishlist(item);
              return ProductCard(
                product: product,
                onTap: () => context.pushNamed(
                  AppRoutes.productDetail,
                  pathParameters: {'id': item.productId},
                ),
                actions: productCardActions(context, ref, product),
              );
            },
          ),
          ),
        ),
        GoRoute(
          name: AppRoutes.settings,
          path: 'settings',
          builder: (context, state) => Consumer(
            builder: (context, ref, _) => SettingsScreen(
              onSignOut: () async {
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ),
        ),
      ],
    ),
  ],
);
