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
import '../../../../core/presentation/theme/app_typography.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';
import '../../domain/entities/admin.dart';
import '../controllers/admin_brands_controller.dart';
import '../controllers/admin_categories_controller.dart';
import '../controllers/admin_products_controller.dart';

/// Admin Products tab (DESIGN.md §5.2.2): inventory manager with server-side
/// search/filter/sort/paging (parity with the Orders tab), inventory quick
/// views, a filter sheet, bulk archive/restore, CSV export and the inline
/// [- Stock +] counters.
class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
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
      _searchController.text = ref
          .read(adminProductsQueryControllerProvider)
          .search;
      _applyRouteQuery();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  AdminProductQuery get _query =>
      ref.read(adminProductsQueryControllerProvider);

  void _update(AdminProductQuery query) {
    ref.read(adminProductsQueryControllerProvider.notifier).update(query);
  }

  /// External deep links (pasted URLs) update the query; in-app filter
  /// changes write the query back to the URL.
  void _applyRouteQuery() {
    final params = GoRouterState.of(context).uri.queryParameters;
    final signature = AdminProductQueryCodec.signature(params);
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    final decoded = AdminProductQueryCodec.decode(params);
    if (decoded == ref.read(adminProductsQueryControllerProvider)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _searchController.text = decoded.search;
      _update(decoded);
    });
  }

  void _syncUrl(AdminProductQuery query) {
    final params = AdminProductQueryCodec.encode(query);
    final signature = AdminProductQueryCodec.signature(params);
    if (_lastRouteSignature == signature) return;
    _lastRouteSignature = signature;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final current = GoRouterState.of(context).uri.queryParameters;
      if (AdminProductQueryCodec.signature(current) == signature) return;
      context.replaceNamed(
        AppRoutes.adminProducts,
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
    _update(const AdminProductQuery());
  }

  void _enterSelection(String productId) {
    setState(() {
      _selectionMode = true;
      _selected
        ..clear()
        ..add(productId);
    });
  }

  void _exitSelection() {
    setState(() {
      _selectionMode = false;
      _selected.clear();
    });
  }

  void _toggle(String productId) {
    setState(() {
      if (!_selected.add(productId)) _selected.remove(productId);
      if (_selected.isEmpty) _selectionMode = false;
    });
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(AppSnackBar(content: Text(message)));
  }

  /// Opens the edit form with a fresh server snapshot. The row rendered in
  /// the list can still be the pre-edit version while an image mutation's
  /// refetch is in flight; seeding the form from it would resurrect removed
  /// images and stale variant `image_path`s.
  Future<void> _editProduct(AdminProductSummary product) async {
    try {
      final fresh = await ref
          .read(adminProductsControllerProvider.notifier)
          .fetchProduct(product.id);
      if (!mounted) return;
      context.pushNamed(AppRoutes.adminProductForm, extra: fresh);
    } catch (error) {
      _snack(
        userMessageFor(error is Failure ? error : UnexpectedFailure(error)),
      );
    }
  }

  Future<void> _openFilterSheet(
    AdminProductQuery query,
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

  Future<AdminProductQuery?> _presentFilterSheet(
    AdminProductQuery query,
    List<AdminBrand> brands,
    List<AdminCategory> categories,
  ) {
    final sheet = _ProductFilterSheet(
      initial: query,
      brands: brands,
      categories: categories,
    );
    if (context.screenSize == ScreenSize.compact) {
      return showModalBottomSheet<AdminProductQuery>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => sheet,
      );
    }
    return showGeneralDialog<AdminProductQuery>(
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

  Future<void> _bulkSetArchived(bool archived) async {
    final ids = {..._selected};
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          '${archived ? 'Archive' : 'Restore'} ${ids.length} product(s)?',
        ),
        content: Text(
          archived
              ? 'Archived products stay visible here but disappear from the '
                    'customer catalog.'
              : 'Restored products become purchasable again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(archived ? 'Archive' : 'Restore'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final changed = await ref
          .read(adminProductsControllerProvider.notifier)
          .setArchivedSelected(ids, archived);
      if (!mounted) return;
      _exitSelection();
      _snack('${archived ? 'Archived' : 'Restored'} $changed product(s).');
    } catch (error) {
      _snack(
        userMessageFor(error is Failure ? error : UnexpectedFailure(error)),
      );
    }
  }

  Future<void> _exportCsv() async {
    try {
      final products = await ref
          .read(adminProductsControllerProvider.notifier)
          .fetchAllForExport();
      if (!mounted) return;
      final csv = _buildCsv(products);
      final uri = await FilePicker.saveFile(
        fileName: 'products_${_stamp(DateTime.now())}.csv',
        bytes: Uint8List.fromList(utf8.encode('\uFEFF$csv')),
        mimeType: 'text/csv',
        dialogTitle: 'Export products',
      );
      if (!mounted) return;
      if (uri != null) _snack('Exported ${products.length} product(s).');
    } catch (error) {
      _snack(
        userMessageFor(error is Failure ? error : UnexpectedFailure(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(adminProductsQueryControllerProvider);
    final productsAsync = ref.watch(adminProductsControllerProvider);
    // Kept warm so the filter sheet always offers the catalog facets.
    final brands =
        ref.watch(adminBrandsControllerProvider).value ?? const <AdminBrand>[];
    final categories =
        ref.watch(adminCategoriesControllerProvider).value ??
        const <AdminCategory>[];
    final theme = Theme.of(context);

    _applyRouteQuery();
    ref.listen(
      adminProductsQueryControllerProvider,
      (_, next) => _syncUrl(next),
    );
    ref.listen(adminProductsControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar(content: Text(userMessageFor(error))));
      }
    });

    final state = productsAsync.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
                  tooltip: 'Select products',
                  icon: const Icon(Icons.checklist_outlined),
                  onPressed: state == null || state.products.isEmpty
                      ? null
                      : () => setState(() {
                          _selectionMode = true;
                          _selected.clear();
                        }),
                ),
                IconButton(
                  tooltip: 'Refresh',
                  icon: const Icon(Icons.refresh),
                  onPressed: () => ref
                      .read(adminProductsControllerProvider.notifier)
                      .refresh(),
                ),
              ],
      ),
      floatingActionButton: _selectionMode
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.pushNamed(AppRoutes.adminProductForm),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
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
                      hintText: 'Name, brand, category, variant, ID…',
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
                      '${state.totalCount} product'
                      '${state.totalCount == 1 ? '' : 's'}'
                      ' · ${Money(state.totalStockValueMinor).formatUsd()}'
                      ' stock value',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  PopupMenuButton<AdminProductSort>(
                    tooltip: 'Sort',
                    initialValue: query.sort,
                    onSelected: (sort) => _update(query.copyWith(sort: sort)),
                    itemBuilder: (context) => [
                      for (final sort in AdminProductSort.values)
                        PopupMenuItem(value: sort, child: Text(sort.label)),
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
                            query.sort.label,
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _list(productsAsync, state, query)),
          if (_selectionMode && _selected.isNotEmpty)
            _BulkBar(
              count: _selected.length,
              onArchive: () => _bulkSetArchived(true),
              onRestore: () => _bulkSetArchived(false),
            ),
        ],
      ),
    );
  }

  Widget _list(
    AsyncValue<AdminProductsState> async,
    AdminProductsState? state,
    AdminProductQuery query,
  ) {
    if (state == null) {
      if (async.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userMessageFor(async.error!), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonal(
                onPressed: () => ref
                    .read(adminProductsControllerProvider.notifier)
                    .refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }
    if (state.products.isEmpty) {
      return query.hasFilters
          ? EmptyStateView(
              illustration: AppIllustrations.noSearch,
              title: 'No products match',
              description: 'Adjust the filters or clear them to see more.',
              actionLabel: 'Clear filters',
              onAction: _clearFilters,
            )
          : const EmptyStateView(
              illustration: AppIllustrations.noProducts,
              title: 'No products yet',
              description: 'Add a product to start building the catalog.',
            );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      itemCount: state.products.length + 1,
      itemBuilder: (context, index) {
        if (index == state.products.length) return _footer(state);
        final product = state.products[index];
        return _AdminProductTile(
          product: product,
          selectionMode: _selectionMode,
          selected: _selected.contains(product.id),
          onTap: () => _selectionMode
              ? _toggle(product.id)
              : _editProduct(product),
          onLongPress: () => _enterSelection(product.id),
          onToggle: () => _toggle(product.id),
          onEdit: () => _editProduct(product),
        );
      },
    );
  }

  Widget _footer(AdminProductsState state) {
    if (!state.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Center(
          child: Text(
            'All ${state.totalCount} product(s) shown',
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
                        .read(adminProductsControllerProvider.notifier)
                        .loadMore();
                  } catch (error) {
                    _snack(
                      userMessageFor(
                        error is Failure ? error : UnexpectedFailure(error),
                      ),
                    );
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
            'Load more (${state.products.length}/${state.totalCount})',
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- rows

class _AdminProductTile extends ConsumerStatefulWidget {
  const _AdminProductTile({
    required this.product,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.onToggle,
    required this.onEdit,
  });

  final AdminProductSummary product;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  ConsumerState<_AdminProductTile> createState() => _AdminProductTileState();
}

class _AdminProductTileState extends ConsumerState<_AdminProductTile> {
  bool _busy = false;

  Future<void> _adjustStock(int delta) async {
    if (_busy) return;
    final product = widget.product;
    setState(() => _busy = true);
    final error = await ref
        .read(adminProductsControllerProvider.notifier)
        .adjustStock(productId: product.id, newStock: product.stock + delta);
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) _showError(error);
  }

  Future<void> _toggleArchive() async {
    if (_busy) return;
    final product = widget.product;
    setState(() => _busy = true);
    final error = await ref
        .read(adminProductsControllerProvider.notifier)
        .setArchived(
          productId: product.id,
          archived: product.status != AdminCatalogStatus.archived,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) _showError(error);
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(AppSnackBar(content: Text(userMessageFor(error))));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArchived = widget.product.status == AdminCatalogStatus.archived;

    return Opacity(
      opacity: _busy ? 0.6 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.selected
              ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.4)
              : null,
          child: InkWell(
            borderRadius: AppRadii.br12,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              child: Row(
                children: [
                  if (widget.selectionMode) ...[
                    Checkbox(
                      value: widget.selected,
                      onChanged: (_) => widget.onToggle(),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: AppRadii.br12,
                      child: MonogramImage(
                        imageUrl: widget.product.images.isEmpty
                            ? null
                            : widget.product.images.first.url,
                        name: widget.product.name,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: isArchived
                                      ? theme.colorScheme.onSurfaceVariant
                                      : null,
                                ),
                              ),
                            ),
                            // §5.2.2 / §2d: archived products surface the
                            // "Unavailable" badge with a Restore action.
                            if (isArchived)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.errorContainer,
                                  borderRadius: AppRadii.br8,
                                ),
                                child: Text(
                                  'Unavailable',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: theme.colorScheme.onErrorContainer,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.product.categoryName}'
                          '${widget.product.brandName == null ? '' : ' · ${widget.product.brandName}'}'
                          ' · ${Money(widget.product.basePriceMinor).formatUsd()}'
                          ' · ${widget.product.variantCount == 0 ? 'Single price' : '${widget.product.variantCount} variant(s)'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // Quick inline [- Stock +] (§5.2.2), stock counter
                  // semantics preserved: low-stock tint when ≤5.
                  Container(
                    decoration: BoxDecoration(
                      color: widget.product.stock == 0
                          ? theme.colorScheme.errorContainer
                          : widget.product.stock <= 5
                          ? theme.colorScheme.tertiaryContainer
                          : theme.colorScheme.surfaceContainer,
                      borderRadius: AppRadii.brFull,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Decrease stock',
                          visualDensity: VisualDensity.compact,
                          onPressed:
                              _busy ||
                                  widget.selectionMode ||
                                  widget.product.stock <= 0
                              ? null
                              : () => _adjustStock(-1),
                          icon: const Icon(Icons.remove, size: 16),
                        ),
                        Text(
                          '${widget.product.stock}',
                          style: AppTypography.labelMedium.copyWith(
                            color: widget.product.stock == 0
                                ? theme.colorScheme.onErrorContainer
                                : widget.product.stock <= 5
                                ? theme.colorScheme.onTertiaryContainer
                                : null,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Increase stock',
                          visualDensity: VisualDensity.compact,
                          onPressed: _busy || widget.selectionMode
                              ? null
                              : () => _adjustStock(1),
                          icon: const Icon(Icons.add, size: 16),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Product actions',
                    enabled: !_busy && !widget.selectionMode,
                    onSelected: (action) {
                      switch (action) {
                        case 'edit':
                          widget.onEdit();
                        case 'toggle':
                          _toggleArchive();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Text(isArchived ? 'Restore' : 'Archive'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- bulk bar

class _BulkBar extends StatelessWidget {
  const _BulkBar({
    required this.count,
    required this.onArchive,
    required this.onRestore,
  });

  final int count;
  final VoidCallback onArchive;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text('$count selected', style: theme.textTheme.labelLarge),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: onRestore,
                icon: const Icon(Icons.unarchive_outlined, size: 18),
                label: const Text('Restore'),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton.icon(
                onPressed: onArchive,
                icon: const Icon(Icons.archive_outlined, size: 18),
                label: const Text('Archive'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------- quick views

class _QuickViews extends StatelessWidget {
  const _QuickViews({required this.query, required this.onSelected});

  final AdminProductQuery query;
  final ValueChanged<AdminProductQuery> onSelected;

  @override
  Widget build(BuildContext context) {
    final presets = <(String, AdminProductQuery)>[
      ('All', const AdminProductQuery()),
      ('Low stock', const AdminProductQuery(stock: {AdminProductStock.low})),
      ('Out of stock', const AdminProductQuery(stock: {AdminProductStock.out})),
      (
        'Archived',
        const AdminProductQuery(statuses: {AdminCatalogStatus.archived}),
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

  bool _presetSelected(AdminProductQuery query, AdminProductQuery preset) {
    if (preset == const AdminProductQuery()) return !query.hasFilters;
    return query.copyWith(sort: preset.sort) == preset;
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

  final AdminProductQuery query;
  final List<AdminBrand> brands;
  final List<AdminCategory> categories;
  final ValueChanged<AdminProductQuery> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (query.from != null || query.to != null) {
      final label = [
        if (query.from != null) _date(query.from!),
        if (query.to != null) _date(query.to!),
      ].join(' – ');
      chips.add(
        _chip('Added: $label', () {
          onChanged(query.copyWith(from: null, to: null));
        }),
      );
    }
    for (final status in query.statuses) {
      chips.add(
        _chip(_statusLabel(status), () {
          onChanged(
            query.copyWith(statuses: {...query.statuses}..remove(status)),
          );
        }),
      );
    }
    for (final bucket in query.stock) {
      chips.add(
        _chip(bucket.label, () {
          onChanged(query.copyWith(stock: {...query.stock}..remove(bucket)));
        }),
      );
    }
    if (query.minPriceMinor != null || query.maxPriceMinor != null) {
      final label = [
        if (query.minPriceMinor != null)
          '≥ ${Money(query.minPriceMinor!).formatUsd()}',
        if (query.maxPriceMinor != null)
          '≤ ${Money(query.maxPriceMinor!).formatUsd()}',
      ].join(' ');
      chips.add(
        _chip(label, () {
          onChanged(query.copyWith(minPriceMinor: null, maxPriceMinor: null));
        }),
      );
    }
    if (query.brandId != null) {
      final name = brands
          .where((brand) => brand.id == query.brandId)
          .map((brand) => brand.name)
          .firstOrNull;
      chips.add(
        _chip('Brand: ${name ?? 'selected'}', () {
          onChanged(query.copyWith(brandId: null));
        }),
      );
    }
    if (query.categoryId != null) {
      final name = categories
          .where((category) => category.id == query.categoryId)
          .map((category) => category.name)
          .firstOrNull;
      chips.add(
        _chip('Category: ${name ?? 'selected'}', () {
          onChanged(query.copyWith(categoryId: null));
        }),
      );
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

class _ProductFilterSheet extends StatefulWidget {
  const _ProductFilterSheet({
    required this.initial,
    required this.brands,
    required this.categories,
  });

  final AdminProductQuery initial;
  final List<AdminBrand> brands;
  final List<AdminCategory> categories;

  @override
  State<_ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<_ProductFilterSheet> {
  late AdminProductQuery _draft = widget.initial;
  late final _minController = TextEditingController(
    text: widget.initial.minPriceMinor == null
        ? ''
        : Money(widget.initial.minPriceMinor!).format(),
  );
  late final _maxController = TextEditingController(
    text: widget.initial.maxPriceMinor == null
        ? ''
        : Money(widget.initial.maxPriceMinor!).format(),
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
        minPriceMinor: _parseMinor(_minController.text),
        maxPriceMinor: _parseMinor(_maxController.text),
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
              _label('Date added'),
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
                            _day(
                              DateTime.now(),
                            ).subtract(const Duration(days: 6)) &&
                        _isSameDay(_draft.to, DateTime.now()),
                  ),
                  _dateChip(
                    '30 days',
                    _draft.from ==
                            _day(
                              DateTime.now(),
                            ).subtract(const Duration(days: 29)) &&
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
              _label('Status'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final status in AdminCatalogStatus.values)
                    FilterChip(
                      label: Text(_statusLabel(status)),
                      selected: _draft.statuses.contains(status),
                      onSelected: (selected) => setState(() {
                        final next = {..._draft.statuses};
                        selected ? next.add(status) : next.remove(status);
                        _draft = _draft.copyWith(statuses: next);
                      }),
                    ),
                ],
              ),
              _gap(),
              _label('Stock'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final bucket in AdminProductStock.values)
                    FilterChip(
                      label: Text(bucket.label),
                      selected: _draft.stock.contains(bucket),
                      onSelected: (selected) => setState(() {
                        final next = {..._draft.stock};
                        selected ? next.add(bucket) : next.remove(bucket);
                        _draft = _draft.copyWith(stock: next);
                      }),
                    ),
                ],
              ),
              _gap(),
              _label('Catalog'),
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
                onChanged: (value) =>
                    setState(() => _draft = _draft.copyWith(categoryId: value)),
              ),
              _gap(),
              _label('Price (USD)'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Minimum'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      controller: _maxController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Maximum'),
                    ),
                  ),
                ],
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
                    setState(() => _draft = const AdminProductQuery());
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

int _filterCount(AdminProductQuery query) {
  var count = 0;
  if (query.from != null || query.to != null) count++;
  count += query.statuses.length;
  count += query.stock.length;
  if (query.minPriceMinor != null || query.maxPriceMinor != null) count++;
  if (query.brandId != null) count++;
  if (query.categoryId != null) count++;
  return count;
}

String _statusLabel(AdminCatalogStatus status) => switch (status) {
  AdminCatalogStatus.active => 'Active',
  AdminCatalogStatus.archived => 'Archived',
};

String _date(DateTime value) {
  final day = value.toLocal();
  return '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}

String _stamp(DateTime value) =>
    '${_date(value).replaceAll('-', '')}_'
    '${value.hour.toString().padLeft(2, '0')}'
    '${value.minute.toString().padLeft(2, '0')}';

DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

bool _isSameDay(DateTime? a, DateTime b) =>
    a != null && a.year == b.year && a.month == b.month && a.day == b.day;

String _buildCsv(List<AdminProductSummary> products) {
  final rows = <List<String>>[
    ['Name', 'Category', 'Brand', 'Status', 'Price USD', 'Stock', 'Variants'],
    for (final product in products)
      [
        product.name,
        product.categoryName,
        product.brandName ?? '',
        product.status.name,
        Money(product.basePriceMinor).format(),
        '${product.stock}',
        product.variantCount == 0 ? 'Single price' : '${product.variantCount}',
      ],
  ];
  return rows.map((row) => row.map(_csvCell).join(',')).join('\r\n');
}

String _csvCell(String value) {
  final escaped = value.replaceAll('"', '""');
  return RegExp(r'[",\r\n]').hasMatch(escaped) ? '"$escaped"' : escaped;
}

/// URL codec for the product filters (shareable/deep-linkable state). Kept
/// compact: only non-default values are written.
abstract final class AdminProductQueryCodec {
  static Map<String, String> encode(AdminProductQuery query) {
    final params = <String, String>{};
    if (query.search.isNotEmpty) params['q'] = query.search;
    if (query.statuses.isNotEmpty) {
      params['status'] =
          (query.statuses.map((status) => status.name).toList()..sort()).join(
            ',',
          );
    }
    if (query.stock.isNotEmpty) {
      params['stock'] =
          (query.stock.map((bucket) => bucket.wireName).toList()..sort()).join(
            ',',
          );
    }
    if (query.brandId != null) params['brand'] = query.brandId!;
    if (query.categoryId != null) params['category'] = query.categoryId!;
    if (query.minPriceMinor != null) params['min'] = '${query.minPriceMinor}';
    if (query.maxPriceMinor != null) params['max'] = '${query.maxPriceMinor}';
    if (query.from != null) params['from'] = _date(query.from!);
    if (query.to != null) params['to'] = _date(query.to!);
    if (query.sort != AdminProductSort.newest) {
      params['sort'] = query.sort.wireName;
    }
    return params;
  }

  static AdminProductQuery decode(Map<String, String> params) {
    return AdminProductQuery(
      search: params['q'] ?? '',
      statuses: _set(params['status'])
          .map((name) => AdminCatalogStatus.values.asNameMap()[name])
          .whereType<AdminCatalogStatus>()
          .toSet(),
      stock: _set(
        params['stock'],
      ).map(AdminProductStock.fromWire).whereType<AdminProductStock>().toSet(),
      brandId: _nonEmpty(params['brand']),
      categoryId: _nonEmpty(params['category']),
      minPriceMinor: int.tryParse(params['min'] ?? ''),
      maxPriceMinor: int.tryParse(params['max'] ?? ''),
      from: _parseDate(params['from']),
      to: _parseDate(params['to']),
      sort: AdminProductSort.fromWire(params['sort']),
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
