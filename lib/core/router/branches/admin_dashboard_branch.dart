import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../features/admin/presentation/screens/audit_logs_screen.dart';
import '../../../features/admin/presentation/screens/brands_admin_screen.dart';
import '../../../features/admin/presentation/screens/categories_admin_screen.dart';
import '../../../features/admin/presentation/screens/platform_settings_screen.dart';
import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/notifications/data/push_notifications_service.dart';
import '../../../features/profile/presentation/controllers/profile_controller.dart';
import '../../../features/profile/presentation/screens/profile_edit_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/profile/presentation/screens/settings_screen.dart';
import '../../../features/promotions/presentation/screens/admin_promotions_screen.dart';
import '../../../features/promotions/presentation/screens/archived_coupons_screen.dart';
import '../../../features/promotions/presentation/screens/archived_sales_screen.dart';
import '../../presentation/widgets/profile_avatar_button.dart';
import '../app_routes.dart';

/// Admin tab 1 — Dashboard (DESIGN.md §5.2.1). The DESIGN.md 4-tab shell
/// removed the Categories/Promotions/Profile tabs; their screens stay
/// reachable as nested routes of this tab (ROUTE-04), surfaced through the
/// dashboard's quick actions.
final adminDashboardBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.adminDashboard,
      path: '/admin/dashboard',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) {
          final avatarUrl = ref.watch(
            profileControllerProvider.select(
              (profile) => profile.value?.avatarUrl,
            ),
          );
          return AdminDashboardScreen(
            profileAction: ProfileAvatarButton(
              avatarUrl: avatarUrl,
              onPressed: () => context.pushNamed(AppRoutes.profile),
            ),
          );
        },
      ),
      routes: [
        GoRoute(
          name: AppRoutes.adminAudit,
          path: 'audit',
          builder: (context, state) => const AuditLogsScreen(),
        ),
        GoRoute(
          name: AppRoutes.adminSettings,
          path: 'settings',
          builder: (context, state) => const PlatformSettingsScreen(),
        ),
        GoRoute(
          name: AppRoutes.adminCategories,
          path: 'categories',
          builder: (context, state) => const CategoriesAdminScreen(),
        ),
        // Brand management lives with the other catalog quick actions
        // (moved out of the Products app bar).
        GoRoute(
          name: AppRoutes.adminBrands,
          path: 'brands',
          builder: (context, state) => const BrandsAdminScreen(),
        ),
        GoRoute(
          name: AppRoutes.adminPromotions,
          path: 'promotions',
          builder: (context, state) => const AdminPromotionsScreen(),
          routes: [
            GoRoute(
              name: AppRoutes.adminArchivedCoupons,
              path: 'archive',
              builder: (context, state) => const ArchivedCouponsScreen(),
            ),
            GoRoute(
              name: AppRoutes.adminArchivedSales,
              path: 'sales-archive',
              builder: (context, state) => const ArchivedSalesScreen(),
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.profile,
          path: 'account',
          builder: (context, state) => Consumer(
            builder: (context, ref, _) => ProfileScreen(
              isCustomer: false,
              onSignOut: () async {
                await ref
                    .read(pushNotificationsServiceProvider)
                    .unregisterCurrentDevice();
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ),
          routes: [
            GoRoute(
              name: AppRoutes.profileEdit,
              path: 'edit',
              builder: (context, state) => const ProfileEditScreen(),
            ),
            GoRoute(
              name: AppRoutes.settings,
              path: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
