import 'package:go_router/go_router.dart';

import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../app_routes.dart';

/// Shared tab — Profile (all roles).
final profileBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.profile,
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
