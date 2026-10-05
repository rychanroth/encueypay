import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product_sort.dart';
import '../controllers/brands_provider.dart';
import '../controllers/categories_provider.dart';
import '../controllers/products_controller.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_grid.dart';

/// Product discovery (spec §32): search, category + brand filters (assignment
/// §2), sort, pagination. Route parameters seed the initial filter set.
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({
    super.key,
    this.categoryId,
    this.query,
    this.brandId,
  });

  final String? categoryId;
  final String? query;
  final String? brandId;

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  late final _searchController =
      TextEditingController(text: widget.query ?? '');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        ref.watch(productsControllerProvider(widget.categoryId, widget.query, widget.brandId));
    final categoriesAsync = ref.watch(categoriesProvider);
    final brandsAsync = ref.watch(brandsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products or brands',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => ref
                  .read(productsControllerProvider(widget.categoryId,
                          widget.query, widget.brandId)
                      .notifier)
                  .setQuery(value),
            ),
          ),
        ),
        actions: [
          PopupMenuButton<ProductSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            onSelected: (sort) => ref
                .read(productsControllerProvider(
                        widget.categoryId, widget.query, widget.brandId)
                    .notifier)
                .setSort(sort),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ProductSort.newest,
                child: Text('Newest'),
              ),
              const PopupMenuItem(
                value: ProductSort.priceAsc,
                child: Text('Price: low to high'),
              ),
              const PopupMenuItem(
                value: ProductSort.priceDesc,
                child: Text('Price: high to low'),
              ),
              const PopupMenuItem(
                value: ProductSort.name,
                child: Text('Name'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: categoriesAsync.maybeWhen(
              data: (categories) => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: controller.value?.categoryId == null,
                      onSelected: (_) => ref
                          .read(productsControllerProvider(widget.categoryId,
                                  widget.query, widget.brandId)
                              .notifier)
                          .setCategory(null),
                    ),
                  ),
                  ...categories.map(
                    (category) => CategoryChip(
                      category: category,
                      selected:
                          controller.value?.categoryId == category.id,
                      onTap: () => ref
                          .read(productsControllerProvider(widget.categoryId,
                                  widget.query, widget.brandId)
                              .notifier)
                          .setCategory(category.id),
                    ),
                  ),
                ],
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          SizedBox(
            height: 48,
            child: brandsAsync.maybeWhen(
              data: (brands) => brands.isEmpty
                  ? const SizedBox.shrink()
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: const Text('All brands'),
                            selected: controller.value?.brandId == null,
                            onSelected: (_) => ref
                                .read(productsControllerProvider(
                                        widget.categoryId, widget.query,
                                        widget.brandId)
                                    .notifier)
                                .setBrand(null),
                          ),
                        ),
                        ...brands.map(
                          (brand) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(brand.name),
                              selected:
                                  controller.value?.brandId == brand.id,
                              onSelected: (_) => ref
                                  .read(productsControllerProvider(
                                          widget.categoryId, widget.query,
                                          widget.brandId)
                                      .notifier)
                                  .setBrand(brand.id),
                            ),
                          ),
                        ),
                      ],
                    ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: controller.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$error', textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: () => ref.invalidate(
                        productsControllerProvider(widget.categoryId,
                            widget.query, widget.brandId),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (listState) => ProductGrid(
                listState: listState,
                onLoadMore: () => ref
                    .read(productsControllerProvider(widget.categoryId,
                            widget.query, widget.brandId)
                        .notifier)
                    .loadMore(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
