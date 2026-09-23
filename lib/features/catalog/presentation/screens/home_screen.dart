import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/business.dart';
import '../../domain/entities/category.dart';
import '../controllers/categories_provider.dart';
import '../controllers/home_feed_providers.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';

/// Customer tab 1 — Home. Discovery entry point: search, categories,
/// businesses, newest products (spec §32).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = switch (context.screenSize) {
      ScreenSize.expanded => 4,
      ScreenSize.medium => 3,
      ScreenSize.compact => 2,
    };
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EncueYPay'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.pushNamed(AppRoutes.notifications),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => context.pushNamed(AppRoutes.products),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: theme.colorScheme.outline),
                    const SizedBox(width: 8),
                    Text(
                      'Search products',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _SectionTitle('Featured'),
          const _BannersStrip(),
          _SectionTitle('Categories'),
          _CategoriesStrip(onCategoryTap: (category) {
            context.pushNamed(
              AppRoutes.products,
              queryParameters: {'category': category.id},
            );
          }),
          _SectionTitle('Businesses'),
          _BusinessesStrip(onBusinessTap: (business) {
            context.pushNamed(
              AppRoutes.businessDetail,
              pathParameters: {'id': business.id},
            );
          }),
          _SectionTitle('New arrivals'),
          _HomeProductsGrid(columns: columns),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BannersStrip extends ConsumerWidget {
  const _BannersStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(homeBannersProvider);
    return bannersAsync.maybeWhen(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 120,
          child: PageView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 8,
                        child: Text(
                          banner.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Colors.white,
                                shadows: const [Shadow(blurRadius: 8)],
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _CategoriesStrip extends ConsumerWidget {
  const _CategoriesStrip({required this.onCategoryTap});

  final void Function(Category category) onCategoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.when(
      loading: () => const _StripLoading(),
      error: (error, _) => _StripError(
        message: '$error',
        onRetry: () => ref.invalidate(categoriesProvider),
      ),
      data: (categories) => SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 0),
          itemBuilder: (context, index) => CategoryChip(
            category: categories[index],
            selected: false,
            onTap: () => onCategoryTap(categories[index]),
          ),
        ),
      ),
    );
  }
}

class _BusinessesStrip extends ConsumerWidget {
  const _BusinessesStrip({required this.onBusinessTap});

  final void Function(Business business) onBusinessTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final businessesAsync = ref.watch(homeBusinessesProvider);
    return businessesAsync.when(
      loading: () => const _StripLoading(),
      error: (error, _) => _StripError(
        message: '$error',
        onRetry: () => ref.invalidate(homeBusinessesProvider),
      ),
      data: (businesses) {
        if (businesses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('No businesses yet.'),
          );
        }
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: businesses.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final business = businesses[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onBusinessTap(business),
                  child: SizedBox(
                    width: 140,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: business.imageUrl != null
                              ? Image.network(
                                  business.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) =>
                                      const _BusinessPlaceholder(),
                                )
                              : const _BusinessPlaceholder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            business.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _BusinessPlaceholder extends StatelessWidget {
  const _BusinessPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.storefront,
          size: 32, color: Theme.of(context).colorScheme.outline),
    );
  }
}

class _HomeProductsGrid extends ConsumerWidget {
  const _HomeProductsGrid({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(homeProductsProvider);
    return productsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => _StripError(
        message: '$error',
        onRetry: () => ref.invalidate(homeProductsProvider),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('No products yet.'),
          );
        }
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.62,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.pushNamed(
                AppRoutes.productDetail,
                pathParameters: {'id': product.id},
              ),
            );
          },
        );
      },
    );
  }
}

class _StripLoading extends StatelessWidget {
  const _StripLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _StripError extends StatelessWidget {
  const _StripError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(message, maxLines: 2)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
