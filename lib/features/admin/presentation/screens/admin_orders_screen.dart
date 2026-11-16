import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/illustrations.dart';
import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_brands_controller.dart';
import '../controllers/admin_categories_controller.dart';
import '../controllers/admin_orders_controller.dart';
import '../widgets/admin_lifecycle_chip.dart';

/// Admin Orders tab (Section 3, spec §8 "manages Orders"): server-side
/// filtered/sorted/paginated order search with operational quick views,
/// bulk lifecycle actions and CSV export. The old bare list silently capped
/// at the newest 50 orders.
class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  String? _lastRouteSignature;
  bool _selectionMode = false;
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchController.text =
          ref.read(adminOrdersQueryControllerProvider).search;
      _applyRouteQuery();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  AdminOrderQuery get _query =>
      ref.read(adminOrdersQueryControllerProvider);

  void _update(AdminOrderQuery query) {
    ref.read(adminOrdersQueryControllerProvider.notifier).update(query);
  }

  /// External deep links (dashboard hero, pasted URLs) update the
  /// query; in-app filter changes write the query back to the URL.
  void _applyRouteQuery() {
    final params = GoRouterState.of(context).uri.queryParameters;
    final signature = AdminOrderQueryCodec.signature(params);
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    final decoded = AdminOrderQueryCodec.decode(params);
    if (decoded == ref.read(adminOrdersQueryControllerProvider)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchController.text = decoded.search;
      _update(decoded);
    });
  }

  void _syncUrl(AdminOrderQuery query) {
    final params = AdminOrderQueryCodec.encode(query);
    final signature = AdminOrderQueryCodec.signature(params);
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = GoRouterState.of(context).uri.queryParameters;
      if (AdminOrderQueryCodec.signature(current) == signature) return;
      context.replaceNamed(
        AppRoutes.adminOrders,
        queryParameters: Map<String, dynamic>.from(params),
      );
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      _update(_query.copyWith(search: value.trim()));
    });
  }

  void _clearFilters() {
    _searchController.clear();
    _update(const AdminOrderQuery());
  }

  void _enterSelection(String orderId) {
    setState(() {
      _selectionMode = true;
      _selected
        ..clear()
        ..add(orderId);
    });
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selected.clear();
    });
  }

  void _toggle(String orderId) {
    setState(() {
      if (!_selected.add(orderId)) _selected.remove(orderId);
      if (_selected.isEmpty) _selectionMode = false;
    });
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openFilterSheet(
    AdminOrderQuery query,
    List<AdminBrand> brands,
    List<AdminCategory> categories,
  ) async {
    final applied = await _presentFilterSheet(query, brands, categories);
    if (applied != null) {
      // Reset inside the sheet also clears the search term.
      _searchController.text = applied.search;
      _update(applied);
    }
  }

  Future<AdminOrderQuery?> _presentFilterSheet(
    AdminOrderQuery query,
    List<AdminBrand> brands,
    List<AdminCategory> categories,
  ) {
    final sheet = _OrderFilterSheet(
      initial: query,
      brands: brands,
      categories: categories,
    );
    if (context.screenSize == ScreenSize.compact) {
      return showModalBottomSheet<AdminOrderQuery>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => sheet,
      );
    }
    return showGeneralDialog<AdminOrderQuery>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Filters',
      barrierColor: const Color(0x660F172A),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, _, _) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Theme.of(dialogContext).colorScheme.surfaceContainerLowest,
          child: SizedBox(
            width: 420,
            height: double.infinity,
            child: SafeArea(child: sheet),
          ),
        ),
      ),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Future<void> _advanceSelected() async {
    final ids = {..._selected};
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Advance ${ids.length} order(s)?'),
        content: const Text(
          'Each selected order moves one lifecycle step. Orders that are '
          'already delivered or cancelled are skipped.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Advance'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final changed = await ref
          .read(adminOrdersControllerProvider.notifier)
          .advanceSelected(ids);
      if (!mounted) return;
      _exitSelection();
      _snack('Advanced $changed order(s).');
    } catch (error) {
      _snack(userMessageFor(error is Failure ? error : UnexpectedFailure(error)));
    }
  }

  Future<void> _cancelSelected() async {
    final ids = {..._selected};
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Cancel ${ids.length} order(s)?'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason (required)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep orders'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel orders'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (reason.isEmpty) {
      _snack('A cancellation reason is required.');
      return;
    }
    try {
      final changed = await ref
          .read(adminOrdersControllerProvider.notifier)
          .cancelSelected(ids, reason);
      if (!mounted) return;
      _exitSelection();
      _snack('Cancelled $changed order(s).');
    } catch (error) {
      _snack(userMessageFor(error is Failure ? error : UnexpectedFailure(error)));
    }
  }

  Future<void> _exportCsv() async {
    try {
      final orders = await ref
          .read(adminOrdersControllerProvider.notifier)
          .fetchAllForExport();
      if (!mounted) return;
      final csv = _buildCsv(orders);
      final uri = await FilePicker.saveFile(
        fileName: 'orders_${_stamp(DateTime.now())}.csv',
        bytes: Uint8List.fromList(utf8.encode('\uFEFF$csv')),
        mimeType: 'text/csv',
        dialogTitle: 'Export orders',
      );
      if (!mounted) return;
      if (uri != null) _snack('Exported ${orders.length} order(s).');
    } catch (error) {
      _snack(userMessageFor(error is Failure ? error : UnexpectedFailure(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(adminOrdersQueryControllerProvider);
    final ordersAsync = ref.watch(adminOrdersControllerProvider);
    // Kept warm so the filter sheet always offers the catalog facets.
    final brands =
        ref.watch(adminBrandsControllerProvider).value ?? const <AdminBrand>[];
    final categories = ref.watch(adminCategoriesControllerProvider).value ??
        const <AdminCategory>[];
    final theme = Theme.of(context);
    _applyRouteQuery();
    ref.listen(adminOrdersQueryControllerProvider, (_, next) => _syncUrl(next));
    ref.listen(adminOrdersControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(userMessageFor(error))));
      }
    });

    final state = ordersAsync.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: _selectionMode
            ? [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text('${_selected.length} selected'),
                  ),
                ),
                IconButton(
                  tooltip: 'Clear selection',
                  icon: const Icon(Icons.close),
                  onPressed: _exitSelection,
                ),
              ]
            : [
                IconButton(
                  tooltip: 'Export CSV',
                  icon: const Icon(Icons.download_outlined),
                  onPressed: _exportCsv,
                ),
                IconButton(
                  tooltip: 'Select orders',
                  icon: const Icon(Icons.checklist_outlined),
                  onPressed: state == null || state.orders.isEmpty
                      ? null
                      : () => setState(() {
                            _selectionMode = true;
                            _selected.clear();
                          }),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh),
                  onPressed: () =>
                      ref.read(adminOrdersControllerProvider.notifier).refresh(),
                ),
              ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Customer, phone, order ID, product…',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: query.search.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _update(query.copyWith(search: ''));
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => _openFilterSheet(query, brands, categories),
                  icon: const Icon(Icons.tune),
                  label: Text(
                    _filterCount(query) == 0
                        ? 'Filters'
                        : 'Filters (${_filterCount(query)})',
                  ),
                ),
              ],
            ),
          ),
          _QuickViews(
            query: query,
            onSelected: (preset) {
              _searchController.clear();
              _update(preset);
            },
          ),
          if (query.hasFilters)
            _ActiveFilters(
              query: query,
              brands: brands,
              categories: categories,
              onChanged: _update,
              onClear: _clearFilters,
            ),
          if (state != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xs,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${state.totalCount} order'
                      '${state.totalCount == 1 ? '' : 's'}'
                      ' · ${Money(state.totalMinor).formatUsd()}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  PopupMenuButton<AdminOrderSort>(
                    tooltip: 'Sort',
                    initialValue: query.sort,
                    onSelected: (sort) =>
                        _update(query.copyWith(sort: sort)),
                    itemBuilder: (context) => [
                      for (final sort in AdminOrderSort.values)
                        PopupMenuItem(
                          value: sort,
                          child: Text(_sortLabel(sort)),
                        ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sort, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            _sortLabel(query.sort),
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _list(ordersAsync, state, query)),
          if (_selectionMode && _selected.isNotEmpty)
            _BulkBar(
              count: _selected.length,
              onAdvance: _advanceSelected,
              onCancel: _cancelSelected,
            ),
        ],
      ),
    );
  }

  Widget _list(
    AsyncValue<AdminOrdersState> async,
    AdminOrdersState? state,
    AdminOrderQuery query,
  ) {
    if (state == null) {
      if (async.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userMessageFor(async.error!),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonal(
                onPressed: () =>
                    ref.read(adminOrdersControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    if (state.orders.isEmpty) {
      return query.hasFilters
          ? EmptyStateView(
              illustration: AppIllustrations.noSearch,
              title: 'No orders match',
              description: 'Adjust the filters or clear them to see more.',
              actionLabel: 'Clear filters',
              onAction: _clearFilters,
            )
          : const EmptyStateView(
              illustration: AppIllustrations.noOrders,
              title: 'No orders yet',
              description: 'Customer orders will appear here.',
            );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: state.orders.length + 1,
      itemBuilder: (context, index) {
        if (index == state.orders.length) return _footer(state);
        final order = state.orders[index];
        return _OrderRow(
          order: order,
          selectionMode: _selectionMode,
          selected: _selected.contains(order.id),
          onTap: () => _selectionMode
              ? _toggle(order.id)
              : context.pushNamed(
                  AppRoutes.adminOrderDetail,
                  pathParameters: {'id': order.id},
                ),
          onLongPress: () => _enterSelection(order.id),
          onToggle: () => _toggle(order.id),
        );
      },
    );
  }

  Widget _footer(AdminOrdersState state) {
    if (!state.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: Text(
            'All ${state.totalCount} order(s) shown',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: state.loadingMore
              ? null
              : () async {
                  try {
                    await ref
                        .read(adminOrdersControllerProvider.notifier)
                        .loadMore();
                  } catch (error) {
                    _snack(userMessageFor(
                      error is Failure ? error : UnexpectedFailure(error),
                    ));
                  }
                },
          icon: state.loadingMore
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.expand_more),
          label: Text(
            'Load more (${state.orders.length}/${state.totalCount})',
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- rows

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.order,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.onToggle,
  });

  final AdminOrderSummary order;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = [
      if (order.customerPhone.isNotEmpty) order.customerPhone,
      _paymentLabel(order),
      _dateTime(order.createdAt),
    ].where((part) => part.isNotEmpty).join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: selectionMode ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectionMode)
                Checkbox(
                  value: selected,
                  onChanged: (_) => onToggle(),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '#${_shortId(order.id)} · ${order.customerName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        AdminLifecycleChip(
                          wireName: order.status.wireName,
                          label: _statusLabel(order.status.wireName),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _itemsSummary(order),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          Money(order.totalMinor).formatUsd(),
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!selectionMode) const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulkBar extends StatelessWidget {
  const _BulkBar({
    required this.count,
    required this.onAdvance,
    required this.onCancel,
  });

  final int count;
  final VoidCallback onAdvance;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 4),
          child: Row(
            children: [
              Expanded(child: Text('$count selected')),
              OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: onAdvance,
                child: const Text('Advance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------- quick views etc.

class _QuickViews extends StatelessWidget {
  const _QuickViews({required this.query, required this.onSelected});

  final AdminOrderQuery query;
  final ValueChanged<AdminOrderQuery> onSelected;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final presets = <(String, AdminOrderQuery)>[
      ('All', const AdminOrderQuery()),
      ('Needs attention', const AdminOrderQuery(needsAttention: true)),
      ('Today', AdminOrderQuery(from: today, to: today)),
      (
        '7D',
        AdminOrderQuery(
          from: today.subtract(const Duration(days: 6)),
          to: today,
        ),
      ),
      (
        '30D',
        AdminOrderQuery(
          from: today.subtract(const Duration(days: 29)),
          to: today,
        ),
      ),
    ];
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          for (final (label, preset) in presets)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(label),
                selected: _presetSelected(query, preset),
                onSelected: (_) => onSelected(preset),
              ),
            ),
        ],
      ),
    );
  }

  bool _presetSelected(AdminOrderQuery query, AdminOrderQuery preset) {
    if (preset == const AdminOrderQuery()) return !query.hasFilters;
    if (preset.needsAttention) return query.needsAttention;
    return query.from == preset.from &&
        query.to == preset.to &&
        !query.needsAttention &&
        !query.excludeCancelled;
  }
}

class _ActiveFilters extends StatelessWidget {
  const _ActiveFilters({
    required this.query,
    required this.brands,
    required this.categories,
    required this.onChanged,
    required this.onClear,
  });

  final AdminOrderQuery query;
  final List<AdminBrand> brands;
  final List<AdminCategory> categories;
  final ValueChanged<AdminOrderQuery> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (query.needsAttention) {
      chips.add(_chip('Needs attention', () {
        onChanged(query.copyWith(needsAttention: false));
      }));
    }
    if (query.excludeCancelled) {
      chips.add(_chip('Excludes cancelled', () {
        onChanged(query.copyWith(excludeCancelled: false));
      }));
    }
    if (query.from != null || query.to != null) {
      final label = [
        if (query.from != null) _date(query.from!),
        if (query.to != null) _date(query.to!),
      ].join(' – ');
      chips.add(_chip('Date: $label', () {
        onChanged(query.copyWith(from: null, to: null));
      }));
    }
    for (final status in query.statuses) {
      chips.add(_chip(_statusLabel(status), () {
        onChanged(query.copyWith(statuses: {...query.statuses}..remove(status)));
      }));
    }
    for (final status in query.paymentStatuses) {
      chips.add(_chip(_paymentStatusLabel(status), () {
        onChanged(query.copyWith(
          paymentStatuses: {...query.paymentStatuses}..remove(status),
        ));
      }));
    }
    for (final method in query.paymentMethods) {
      chips.add(_chip(_methodLabel(method), () {
        onChanged(query.copyWith(
          paymentMethods: {...query.paymentMethods}..remove(method),
        ));
      }));
    }
    if (query.minTotalMinor != null || query.maxTotalMinor != null) {
      final label = [
        if (query.minTotalMinor != null)
          '≥ ${Money(query.minTotalMinor!).formatUsd()}',
        if (query.maxTotalMinor != null)
          '≤ ${Money(query.maxTotalMinor!).formatUsd()}',
      ].join(' ');
      chips.add(_chip(label, () {
        onChanged(query.copyWith(minTotalMinor: null, maxTotalMinor: null));
      }));
    }
    if (query.brandId != null) {
      final name = brands
          .where((brand) => brand.id == query.brandId)
          .map((brand) => brand.name)
          .firstOrNull;
      chips.add(_chip('Brand: ${name ?? 'selected'}', () {
        onChanged(query.copyWith(brandId: null));
      }));
    }
    if (query.categoryId != null) {
      final name = categories
          .where((category) => category.id == query.categoryId)
          .map((category) => category.name)
          .firstOrNull;
      chips.add(_chip('Category: ${name ?? 'selected'}', () {
        onChanged(query.copyWith(categoryId: null));
      }));
    }
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          ...chips.map(
            (chip) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: chip,
            ),
          ),
          TextButton(onPressed: onClear, child: const Text('Clear all')),
        ],
      ),
    );
  }

  Widget _chip(String label, VoidCallback onDeleted) {
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close, size: 16),
    );
  }
}

// ----------------------------------------------------------- filter sheet

class _OrderFilterSheet extends StatefulWidget {
  const _OrderFilterSheet({
    required this.initial,
    required this.brands,
    required this.categories,
  });

  final AdminOrderQuery initial;
  final List<AdminBrand> brands;
  final List<AdminCategory> categories;

  @override
  State<_OrderFilterSheet> createState() => _OrderFilterSheetState();
}

class _OrderFilterSheetState extends State<_OrderFilterSheet> {
  late AdminOrderQuery _draft = widget.initial;
  late final _minController = TextEditingController(
    text: widget.initial.minTotalMinor == null
        ? ''
        : Money(widget.initial.minTotalMinor!).format(),
  );
  late final _maxController = TextEditingController(
    text: widget.initial.maxTotalMinor == null
        ? ''
        : Money(widget.initial.maxTotalMinor!).format(),
  );

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  int? _parseMinor(String text) {
    final value = text.trim();
    if (value.isEmpty) return null;
    try {
      return Money.parse(value).minorUnits;
    } on FormatException {
      return null;
    }
  }

  void _apply() {
    Navigator.of(context).pop(
      _draft.copyWith(
        minTotalMinor: _parseMinor(_minController.text),
        maxTotalMinor: _parseMinor(_maxController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text('Filters', style: theme.textTheme.titleMedium),
              ),
              IconButton(
                tooltip: 'Close',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _label('Date'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  _dateChip('Any', _draft.from == null && _draft.to == null),
                  _dateChip(
                    'Today',
                    _isSameDay(_draft.from, DateTime.now()) &&
                        _isSameDay(_draft.to, DateTime.now()),
                  ),
                  _dateChip(
                    '7 days',
                    _draft.from ==
                            _day(DateTime.now())
                                .subtract(const Duration(days: 6)) &&
                        _isSameDay(_draft.to, DateTime.now()),
                  ),
                  _dateChip(
                    '30 days',
                    _draft.from ==
                            _day(DateTime.now())
                                .subtract(const Duration(days: 29)) &&
                        _isSameDay(_draft.to, DateTime.now()),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.date_range, size: 16),
                    label: Text(
                      _draft.from == null && _draft.to == null
                          ? 'Custom…'
                          : '${_date(_draft.from!)} – ${_date(_draft.to!)}',
                    ),
                    onPressed: _pickRange,
                  ),
                ],
              ),
              _gap(),
              _label('Order status'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final status in AdminOrderStatus.values)
                    FilterChip(
                      label: Text(_statusLabel(status.wireName)),
                      selected: _draft.statuses.contains(status.wireName),
                      onSelected: (selected) => setState(() {
                        final next = {..._draft.statuses};
                        selected
                            ? next.add(status.wireName)
                            : next.remove(status.wireName);
                        _draft = _draft.copyWith(statuses: next);
                      }),
                    ),
                ],
              ),
              _gap(),
              _label('Payment status'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final status in _paymentStatuses)
                    FilterChip(
                      label: Text(_paymentStatusLabel(status)),
                      selected: _draft.paymentStatuses.contains(status),
                      onSelected: (selected) => setState(() {
                        final next = {..._draft.paymentStatuses};
                        selected ? next.add(status) : next.remove(status);
                        _draft = _draft.copyWith(paymentStatuses: next);
                      }),
                    ),
                ],
              ),
              _gap(),
              _label('Payment method'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final method in _paymentMethods)
                    FilterChip(
                      label: Text(_methodLabel(method)),
                      selected: _draft.paymentMethods.contains(method),
                      onSelected: (selected) => setState(() {
                        final next = {..._draft.paymentMethods};
                        selected ? next.add(method) : next.remove(method);
                        _draft = _draft.copyWith(paymentMethods: next);
                      }),
                    ),
                ],
              ),
              _gap(),
              _label('Catalog (order contains an item of…)'),
              _picker(
                label: 'Brand',
                value: _validBrand(_draft.brandId),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Any brand')),
                  for (final brand in widget.brands)
                    DropdownMenuItem(value: brand.id, child: Text(brand.name)),
                ],
                onChanged: (value) =>
                    setState(() => _draft = _draft.copyWith(brandId: value)),
              ),
              const SizedBox(height: AppSpacing.sm),
              _picker(
                label: 'Category',
                value: _validCategory(_draft.categoryId),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Any category'),
                  ),
                  for (final category in widget.categories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(
                        category.parentId == null
                            ? category.name
                            : '↳ ${category.name}',
                      ),
                    ),
                ],
                onChanged: (value) => setState(
                  () => _draft = _draft.copyWith(categoryId: value),
                ),
              ),
              _gap(),
              _label('Order total (USD)'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Minimum'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _maxController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Maximum'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Exclude cancelled orders'),
                subtitle: const Text(
                  'Hides cancelled and returned orders.',
                ),
                value: _draft.excludeCancelled,
                onChanged: (value) => setState(
                  () => _draft = _draft.copyWith(excludeCancelled: value),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    _minController.clear();
                    _maxController.clear();
                    setState(() => _draft = const AdminOrderQuery());
                  },
                  child: const Text('Reset'),
                ),
                const Spacer(),
                FilledButton(onPressed: _apply, child: const Text('Apply')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _validBrand(String? id) =>
      widget.brands.any((brand) => brand.id == id) ? id : null;

  String? _validCategory(String? id) =>
      widget.categories.any((category) => category.id == id) ? id : null;

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(text, style: Theme.of(context).textTheme.labelLarge),
      );

  /// Controlled picker so Reset (and any programmatic change) updates the
  /// displayed value — a FormField keeps its own initial value.
  Widget _picker({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String?>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: AppSpacing.md);

  Widget _dateChip(String label, bool selected) => ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {
          final now = DateTime.now();
          final today = _day(now);
          setState(() {
            _draft = switch (label) {
              'Any' => _draft.copyWith(from: null, to: null),
              'Today' => _draft.copyWith(from: today, to: today),
              '7 days' => _draft.copyWith(
                  from: today.subtract(const Duration(days: 6)),
                  to: today,
                ),
              _ => _draft.copyWith(
                  from: today.subtract(const Duration(days: 29)),
                  to: today,
                ),
            };
          });
        },
      );

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: _draft.from ?? now.subtract(const Duration(days: 6)),
        end: _draft.to ?? now,
      ),
    );
    if (picked != null) {
      setState(() {
        _draft = _draft.copyWith(
          from: _day(picked.start),
          to: _day(picked.end),
        );
      });
    }
  }
}

// ---------------------------------------------------------------- helpers

const _paymentStatuses = [
  'pending',
  'awaiting_payment_verification',
  'transaction_verified',
  'refund_required',
  'refunded',
];

const _paymentMethods = ['cod', 'qr', 'bank_transfer'];

int _filterCount(AdminOrderQuery query) {
  var count = 0;
  if (query.from != null || query.to != null) count++;
  count += query.statuses.length;
  count += query.paymentStatuses.length;
  count += query.paymentMethods.length;
  if (query.minTotalMinor != null || query.maxTotalMinor != null) count++;
  if (query.brandId != null) count++;
  if (query.categoryId != null) count++;
  if (query.excludeCancelled) count++;
  if (query.needsAttention) count++;
  return count;
}

String _sortLabel(AdminOrderSort sort) => switch (sort) {
      AdminOrderSort.newest => 'Newest',
      AdminOrderSort.oldest => 'Oldest',
      AdminOrderSort.totalDesc => 'Total: high → low',
      AdminOrderSort.totalAsc => 'Total: low → high',
    };

String _statusLabel(String wireName) {
  final words = wireName.replaceAll('_', ' ');
  return words.isEmpty
      ? words
      : '${words[0].toUpperCase()}${words.substring(1)}';
}

String _paymentStatusLabel(String wireName) => switch (wireName) {
      'pending' => 'Pending',
      'awaiting_payment_verification' => 'Awaiting verification',
      'transaction_verified' => 'Paid',
      'refund_required' => 'Refund required',
      'refunded' => 'Refunded',
      _ => _statusLabel(wireName),
    };

String _methodLabel(String method) => switch (method) {
      'cod' => 'Cash on delivery',
      'qr' => 'KHQR',
      'bank_transfer' => 'Bank transfer',
      _ => method,
    };

String _paymentLabel(AdminOrderSummary order) {
  final method = order.paymentMethod;
  final status = order.paymentStatus;
  if (method == null && status == null) return '';
  return [
    if (method != null) _methodLabel(method),
    if (status != null) _paymentStateLabel(order),
  ].where((part) => part.isNotEmpty).join(' · ');
}

/// Context-aware payment state for the queue's meta line. A bare "Pending"
/// next to a delivered or cancelled lifecycle chip reads as a contradiction;
/// the label now says what actually has to happen (collect cash, refund, …).
String _paymentStateLabel(AdminOrderSummary order) {
  final status = order.paymentStatus;
  if (status == null) return '';
  final terminal = order.status == AdminOrderStatus.cancelled ||
      order.status == AdminOrderStatus.returned;
  return switch (status) {
    'transaction_verified' => 'Paid',
    'awaiting_payment_verification' => 'Awaiting verification',
    'refund_required' => 'Refund required',
    'refunded' => 'Refunded',
    'pending' => switch (order.paymentMethod) {
        'cod' => terminal
            ? 'Not collected'
            : order.status == AdminOrderStatus.delivered
                ? 'Cash pending'
                : 'Pay on delivery',
        'qr' => terminal ? 'Unpaid' : 'Awaiting payment',
        'bank_transfer' => 'Awaiting verification',
        _ => 'Unpaid',
      },
    _ => _statusLabel(status),
  };
}

String _itemsSummary(AdminOrderSummary order) {
  if (order.items.isEmpty) return 'No items';
  final first = order.items.first;
  final name = first.variantName == null
      ? first.productName
      : '${first.productName} (${first.variantName})';
  final rest = order.items.length - 1;
  return rest > 0 ? '$name ×${first.quantity} +$rest more' : '$name ×${first.quantity}';
}

String _shortId(String id) =>
    id.length <= 8 ? id : id.substring(0, 8);

String _date(DateTime value) {
  final day = value.toLocal();
  return '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}

String _dateTime(DateTime value) {
  final local = value.toLocal();
  return '${_date(local)} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

String _stamp(DateTime value) =>
    '${_date(value).replaceAll('-', '')}_'
    '${value.hour.toString().padLeft(2, '0')}'
    '${value.minute.toString().padLeft(2, '0')}';

DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

bool _isSameDay(DateTime? a, DateTime b) =>
    a != null && a.year == b.year && a.month == b.month && a.day == b.day;

String _buildCsv(List<AdminOrderSummary> orders) {
  final rows = <List<String>>[
    [
      'Order ID',
      'Created',
      'Customer',
      'Phone',
      'Recipient',
      'Shipping phone',
      'City',
      'Address',
      'Status',
      'Payment method',
      'Payment status',
      'Subtotal USD',
      'Discount USD',
      'Delivery USD',
      'Total USD',
      'Items',
    ],
    for (final order in orders)
      [
        order.id,
        _dateTime(order.createdAt),
        order.customerName,
        order.customerPhone,
        order.shippingRecipientName,
        order.shippingPhone,
        order.shippingCity,
        [
          order.shippingLine1,
          order.shippingLine2 ?? '',
        ].where((part) => part.isNotEmpty).join(', '),
        order.status.wireName,
        order.paymentMethod ?? '',
        order.paymentStatus ?? '',
        Money(order.subtotalMinor).format(),
        Money(order.discountMinor).format(),
        Money(order.deliveryFeeMinor).format(),
        Money(order.totalMinor).format(),
        [
          for (final item in order.items)
            '${item.productName}'
                '${item.variantName == null ? '' : ' (${item.variantName})'}'
                ' x${item.quantity}',
        ].join('; '),
      ],
  ];
  return rows.map((row) => row.map(_csvCell).join(',')).join('\r\n');
}

String _csvCell(String value) {
  final escaped = value.replaceAll('"', '""');
  return RegExp(r'[",\r\n]').hasMatch(escaped) ? '"$escaped"' : escaped;
}

/// URL codec for the order filters (shareable/deep-linkable state). Kept
/// compact: only non-default values are written.
abstract final class AdminOrderQueryCodec {
  static Map<String, String> encode(AdminOrderQuery query) {
    final params = <String, String>{};
    if (query.search.isNotEmpty) params['q'] = query.search;
    if (query.from != null) params['from'] = _date(query.from!);
    if (query.to != null) params['to'] = _date(query.to!);
    if (query.statuses.isNotEmpty) {
      params['status'] = (query.statuses.toList()..sort()).join(',');
    }
    if (query.paymentStatuses.isNotEmpty) {
      params['pay'] = (query.paymentStatuses.toList()..sort()).join(',');
    }
    if (query.paymentMethods.isNotEmpty) {
      params['method'] = (query.paymentMethods.toList()..sort()).join(',');
    }
    if (query.brandId != null) params['brand'] = query.brandId!;
    if (query.categoryId != null) params['category'] = query.categoryId!;
    if (query.minTotalMinor != null) {
      params['min'] = '${query.minTotalMinor}';
    }
    if (query.maxTotalMinor != null) {
      params['max'] = '${query.maxTotalMinor}';
    }
    if (query.excludeCancelled) params['ex'] = '1';
    if (query.needsAttention) params['attention'] = '1';
    if (query.sort != AdminOrderSort.newest) {
      params['sort'] = query.sort.wireName;
    }
    return params;
  }

  static AdminOrderQuery decode(Map<String, String> params) {
    final sort = AdminOrderSort.values.firstWhere(
      (value) => value.wireName == params['sort'],
      orElse: () => AdminOrderSort.newest,
    );
    return AdminOrderQuery(
      search: params['q'] ?? '',
      from: _parseDate(params['from']),
      to: _parseDate(params['to']),
      statuses: _set(params['status']),
      paymentStatuses: _set(params['pay']),
      paymentMethods: _set(params['method']),
      brandId: _nonEmpty(params['brand']),
      categoryId: _nonEmpty(params['category']),
      minTotalMinor: int.tryParse(params['min'] ?? ''),
      maxTotalMinor: int.tryParse(params['max'] ?? ''),
      excludeCancelled: params['ex'] == '1',
      needsAttention: params['attention'] == '1',
      sort: sort,
    );
  }

  static String signature(Map<String, String> params) {
    final keys = params.keys.toList()..sort();
    return [for (final key in keys) '$key=${params[key]}'].join('&');
  }

  static Set<String> _set(String? value) {
    if (value == null || value.isEmpty) return const {};
    return value.split(',').where((part) => part.isNotEmpty).toSet();
  }

  static String? _nonEmpty(String? value) =>
      value == null || value.isEmpty ? null : value;

  static DateTime? _parseDate(String? value) =>
      value == null ? null : DateTime.tryParse(value);
}
