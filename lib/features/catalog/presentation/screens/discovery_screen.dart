import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product_sort.dart';
import '../controllers/brands_provider.dart';
import '../controllers/categories_provider.dart';
import '../controllers/products_controller.dart';
import '../widgets/product_grid.dart';

/// Discover tab (DESIGN.md §5.1.2) — the app's unified browse experience:
/// keyword search over product *and* brand names, category + brand filter
/// chips, sort, and the 2-column `ProductCard` grid.
///
/// Deep links from Home arrive with `kind` (`category`|`brand`), `id`,
/// `name` and optional `image`/`q` query parameters; the dimension renders
/// as a removable context banner so landing on a brand and free browsing
/// are the same surface (§5.1.2, replacing the old per-dimension screen).
///
/// The products controller family is seeded from the route parameters;
/// in-tab chip/sort/search interactions mutate that instance, so filter
/// state survives scroll pagination and tab switches.
class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({
    super.key,
    this.kind,
    this.id,
    this.name,
    this.imageUrl,
    this.query,
    this.actionsBuilder,
  });

  /// `'category'` or `'brand'`; null renders the unfiltered catalog.
  final String? kind;
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? query;

  /// Long-press quick actions per product — injected by the composition
  /// root; null keeps cards tap-only (Section 6).
  final ProductCardActionsBuilder? actionsBuilder;

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  late final _searchController = TextEditingController(text: widget.query ?? '');
  bool get _hasDimension =>
      widget.id != null && widget.id!.isNotEmpty && widget.kind != null;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryId = widget.kind == 'category' ? widget.id : null;
    final brandId = widget.kind == 'brand' ? widget.id : null;
    final provider = productsControllerProvider(categoryId, widget.query, brandId);
    final controller = ref.watch(provider);

    final categoriesAsync = ref.watch(categoriesProvider);
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Search field (§5.1.2: keyword over product/brand names) ----
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search products or brands',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          ref.read(provider.notifier).setQuery('');
                        },
                      ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (value) => ref.read(provider.notifier).setQuery(value),
            ),
          ),

          // --- Dimension context banner (deep links from Home) -------------
          if (_hasDimension)
            _DimensionBanner(
              kind: widget.kind!,
              name: widget.name ?? '',
              imageUrl: widget.imageUrl,
              onClear: () => context.goNamed(AppRoutes.discovery),
            ),

          // --- Category filter chips ----------------------------------------
          SizedBox(
            height: 44,
            child: categoriesAsync.maybeWhen(
              data: (categories) {
                // 2-level taxonomy (§2c): top-level chips in name order, each
                // immediately followed by its subcategories (indent glyph) —
                // the strip mirrors the hierarchy, and filtering by a child
                // aggregates through the same controller.
                final chips = <(Category, bool)>[];
                for (final parent in categories.where((c) => c.isTopLevel)) {
                  chips.add((parent, false));
                  for (final child
                      in categories.where((c) => c.parentId == parent.id)) {
                    chips.add((child, true));
                  }
                }
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: controller.value?.categoryId == null,
                      onTap: () =>
                          ref.read(provider.notifier).setCategory(null),
                    ),
                    for (final (category, isChild) in chips)
                      _FilterChip(
                        label: isChild ? '↳ ${category.name}' : category.name,
                        imageUrl: category.imageUrl,
                        selected: controller.value?.categoryId == category.id,
                        onTap: () => ref
                            .read(provider.notifier)
                            .setCategory(category.id),
                      ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // --- Brand filter chips --------------------------------------------
          SizedBox(
            height: 44,
            child: brandsAsync.maybeWhen(
              data: (brands) => brands.isEmpty
                  ? const SizedBox.shrink()
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      children: [
                        _FilterChip(
                          label: 'All brands',
                          selected: controller.value?.brandId == null,
                          onTap: () => ref.read(provider.notifier).setBrand(null),
                        ),
                        for (final brand in brands)
                          _FilterChip(
                            label: brand.name,
                            imageUrl: brand.imageUrl,
                            selected: controller.value?.brandId == brand.id,
                            onTap: () =>
                                ref.read(provider.notifier).setBrand(brand.id),
                          ),
                      ],
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),

          // --- Sort + result count toolbar ------------------------------------
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
                    switch (controller.value?.items.length) {
                      null => '',
                      0 => 'No products',
                      final n => '$n product${n == 1 ? '' : 's'}',
                    },
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                PopupMenuButton<ProductSort>(
                  tooltip: 'Sort',
                  onSelected: (sort) => ref.read(provider.notifier).setSort(sort),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: ProductSort.newest, child: Text('Newest')),
                    PopupMenuItem(
                      value: ProductSort.priceAsc,
                      child: Text('Price: low to high'),
                    ),
                    PopupMenuItem(
                      value: ProductSort.priceDesc,
                      child: Text('Price: high to low'),
                    ),
                    PopupMenuItem(value: ProductSort.name, child: Text('Name')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm + 2,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      borderRadius: AppRadii.br8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sort, size: 16, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          _sortLabel(controller.value?.sort),
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Product grid ----------------------------------------------------
          Expanded(
            child: AsyncValueWidget(
              value: controller,
              retry: () => ref.invalidate(provider),
              data: (listState) => listState.items.isEmpty
                  ? EmptyStateView(
                      icon: Icons.search_off_outlined,
                      title: 'No products match',
                      description: 'Try a different keyword or clear a filter.',
                      actionLabel: _hasDimension ||
                              controller.value!.query?.isNotEmpty == true ||
                              controller.value!.categoryId != null ||
                              controller.value!.brandId != null
                          ? 'Clear filters'
                          : null,
                      onAction: _hasDimension
                          ? () => context.goNamed(AppRoutes.discovery)
                          : () {
                              _searchController.clear();
                              setState(() {});
                              ref.read(provider.notifier).setQuery('');
                              if (controller.value!.categoryId != null) {
                                ref.read(provider.notifier).setCategory(null);
                              }
                              if (controller.value!.brandId != null) {
                                ref.read(provider.notifier).setBrand(null);
                              }
                            },
                    )
                  : ProductGrid(
                      listState: listState,
                      onLoadMore: () => ref.read(provider.notifier).loadMore(),
                      actionsBuilder: widget.actionsBuilder,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  static String _sortLabel(ProductSort? sort) => switch (sort) {
        ProductSort.priceAsc => 'Price ↑',
        ProductSort.priceDesc => 'Price ↓',
        ProductSort.name => 'Name',
        _ => 'Newest',
      };
}

/// Pre-filtered landing banner (brand or category): monogram imagery +
/// removable context (§6.1 "graceful" treatment — no blank heroes).
class _DimensionBanner extends StatelessWidget {
  const _DimensionBanner({
    required this.kind,
    required this.name,
    required this.imageUrl,
    required this.onClear,
  });

  final String kind;
  final String name;
  final String? imageUrl;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBrand = kind == 'brand';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: AppRadii.br16,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: ClipRRect(
                borderRadius: AppRadii.br12,
                child: MonogramImage(
                  imageUrl: imageUrl,
                  name: name,
                  icon: isBrand ? Icons.sell_outlined : Icons.category_outlined,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBrand ? 'Brand' : 'Category',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Clear filter',
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClear,
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter chip with a monogram avatar — brand/category imagery rendered
/// gracefully whether or not the row has an image.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.imageUrl,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        selected: selected,
        onSelected: (_) => onTap(),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imageUrl != null) ...[
              SizedBox(
                width: 22,
                height: 22,
                child: ClipRRect(
                  borderRadius: AppRadii.br8,
                  child: MonogramImage(imageUrl: imageUrl, name: label),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label),
          ],
        ),
        labelStyle: theme.textTheme.labelMedium,
        showCheckmark: false,
      ),
    );
  }
}
