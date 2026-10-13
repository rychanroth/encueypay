import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/catalog/presentation/screens/discovery_screen.dart';
import '../app_routes.dart';
import '../product_card_actions.dart';

/// Customer tab 2 — Discover (DESIGN.md §5.1.2): the full search/filter/
/// sort browse experience lives in this tab. Home deep-links into it with
/// `kind`/`id` query parameters to pre-filter a brand or category; with no
/// parameters the tab renders the unfiltered catalog.
///
/// Route parameters seed the products controller family's initial filter
/// set; in-tab chip/sort interactions mutate that controller instance.
final discoveryBranch = StatefulShellBranch(
  routes: [
    GoRoute(
      name: AppRoutes.discovery,
      path: '/discovery',
      builder: (context, state) => Consumer(
        builder: (context, ref, _) => DiscoveryScreen(
          kind: state.uri.queryParameters['kind'],
          id: state.uri.queryParameters['id'],
          name: state.uri.queryParameters['name'],
          imageUrl: state.uri.queryParameters['image'],
          query: state.uri.queryParameters['q'],
          actionsBuilder: (product) => productCardActions(context, ref, product),
        ),
      ),
    ),
  ],
);
