import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/domain/entities/user_role.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/profile/domain/entities/address.dart';
import '../../../features/profile/presentation/screens/address_edit_screen.dart';
import '../../../features/profile/presentation/screens/addresses_screen.dart';
import '../../../features/profile/presentation/screens/profile_edit_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/profile/presentation/screens/settings_screen.dart';
import '../../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../app_routes.dart';

// 2-Role Academic Prototype: the role-application route (`/profile/apply`,
// living spec Part C L-03) is removed — customers can no longer apply to
// become business owners or drivers. features/role_applications stays in the
// repository; restore the GoRoute below to bring the flow back.

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
          return ProfileScreen(isCustomer: role == UserRole.customer);
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
          builder: (context, state) => const WishlistScreen(),
        ),
        // Customer dashboard (Section 5, assignment §1).
        GoRoute(
          name: AppRoutes.dashboard,
          path: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
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
