import 'package:go_router/go_router.dart';

import '../../../features/business/presentation/screens/business_transactions_screen.dart';
import '../app_routes.dart';

/// Business tab — TransactionHistory (ROUTE-04/05): realized profit per day.
final businessTransactionsBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.businessTransactions,
      path: '/business/transactions',
      builder: (context, state) => const BusinessTransactionsScreen(),
    ),
  ],
);
