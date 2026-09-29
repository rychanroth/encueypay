import 'package:go_router/go_router.dart';

import '../../../features/delivery/presentation/screens/driver_transactions_screen.dart';
import '../app_routes.dart';

/// Driver tab — TransactionHistory (ROUTE-04/05): realized earnings per day.
final driverTransactionsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.driverTransactions,
      path: '/driver/transactions',
      builder: (context, state) => const DriverTransactionsScreen(),
    ),
  ],
);
