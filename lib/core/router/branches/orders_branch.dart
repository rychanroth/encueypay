import 'package:go_router/go_router.dart';

import '../../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../../features/orders/presentation/screens/orders_screen.dart';
import '../../../features/returns/presentation/screens/return_request_screen.dart';
import '../../../features/reviews/presentation/screens/review_compose_screen.dart';
import '../app_routes.dart';

/// Customer tab 3 — Orders + detail/return/review nested routes (ROUTE-04).
/// The review target travels via a record in `extra`, so orders never
/// imports the reviews feature (ARCH-04).
final ordersBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.orders,
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.orderDetail,
          path: ':id',
          builder: (context, state) => OrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
          routes: [
            GoRoute(
              name: AppRoutes.returnRequest,
              path: 'return',
              builder: (context, state) => ReturnRequestScreen(
                orderId: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.reviewCompose,
          path: 'review',
          builder: (context, state) {
            final (orderItemId, productName) =
                state.extra! as (String, String);
            return ReviewComposeScreen(
              orderItemId: orderItemId,
              productName: productName,
            );
          },
        ),
      ],
    ),
  ],
);
