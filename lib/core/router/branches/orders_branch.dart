import 'package:go_router/go_router.dart';

import '../../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../../features/orders/presentation/screens/orders_screen.dart';
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
        // Static sibling FIRST: `review` must not be shadowed by the `:id`
        // detail route — `/orders/review` previously matched `:id` with
        // id="review" and crashed the detail fetch (22P02).
        GoRoute(
          name: AppRoutes.reviewCompose,
          path: 'review',
          builder: (context, state) {
            final (orderItemId, productId, productName) =
                state.extra! as (String, String, String);
            return ReviewComposeScreen(
              orderItemId: orderItemId,
              productId: productId,
              productName: productName,
            );
          },
        ),
        GoRoute(
          name: AppRoutes.orderDetail,
          path: ':id',
          builder: (context, state) => OrderDetailScreen(
            orderId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
