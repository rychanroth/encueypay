import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/catalog/presentation/controllers/product_detail_controller.dart';
import '../../../features/orders/presentation/controllers/order_detail_controller.dart';
import '../../../features/orders/presentation/controllers/orders_controller.dart';
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
          builder: (context, state) => Consumer(
            builder: (context, ref, _) {
              final (orderId, orderItemId, productId, productName) =
                  state.extra! as (String, String, String, String);
              return ReviewComposeScreen(
                orderItemId: orderItemId,
                productId: productId,
                productName: productName,
                onSubmitted: () {
                  ref.invalidate(orderDetailControllerProvider(orderId));
                  ref.invalidate(ordersControllerProvider);
                  if (productId.isNotEmpty) {
                    ref.invalidate(productDetailControllerProvider(productId));
                  }
                },
              );
            },
          ),
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
