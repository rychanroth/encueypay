import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../controllers/brands_provider.dart';
import '../controllers/categories_provider.dart';
import '../controllers/home_feed_providers.dart';
import '../widgets/product_card.dart';

/// Customer tab 1 — Home. Discovery entry point: search, categories, banners,
/// newest products (spec §32). The businesses strip was removed for the
/// 2-Role Academic Prototype (living spec Part C L-04/L-05) — vendor
/// discovery is bypassed; the underlying data model is untouched.
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
          // Section 2c: card-based discovery navigation (assignment §2
          // "intuitive Search Bar and navigation for rapid discovery") —
          // categories as an image card grid, brands as a logo rail, both
          // tapping into the discovery screen. The chips remain in the
          // products screen's filter bar.
          _SectionTitle('Shop by category'),
          _CategoryCardGrid(),
          _SectionTitle('Top brands'),
          _BrandRail(),
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

/// Category discovery cards (Section 2c): image tile + scrim name. Parent
/// categories aggregate their sub-category products in the discovery screen.
class _CategoryCardGrid extends ConsumerWidget {
  const _CategoryCardGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    return categoriesAsync.maybeWhen(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width >= 840
                ? 4
                : width >= 600
                    ? 3
                    : 2;
            final tileWidth =
                (width - (crossAxisCount - 1) * 8) / crossAxisCount;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in categories)
                  SizedBox(
                    width: tileWidth,
                    child: _CategoryCard(category: category),
                  ),
              ],
            );
          }),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.discovery,
          queryParameters: {
            'kind': 'category',
            'id': category.id,
            'name': category.name,
            if (category.imageUrl != null) 'image': category.imageUrl!,
          },
        ),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (category.imageUrl != null)
                Image.network(
                  category.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _CategoryFallback(),
                )
              else
                const _CategoryFallback(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryFallback extends StatelessWidget {
  const _CategoryFallback();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.primaryContainer,
      child: Icon(Icons.category_outlined,
          size: 36, color: theme.colorScheme.onPrimaryContainer),
    );
  }
}

/// Brand discovery rail (Section 2c): rounded logo cards in a horizontal
/// scroll, tapping into the brand's discovery page.
class _BrandRail extends ConsumerWidget {
  const _BrandRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);
    return brandsAsync.maybeWhen(
      data: (brands) {
        if (brands.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return _BrandCard(brand: brand);
            },
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.brand});

  final Brand brand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 108,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => context.pushNamed(
                AppRoutes.discovery,
                queryParameters: {
                  'kind': 'brand',
                  'id': brand.id,
                  'name': brand.name,
                  if (brand.imageUrl != null) 'image': brand.imageUrl!,
                },
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: brand.imageUrl != null
                    ? Image.network(
                        brand.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const _BrandFallback(),
                      )
                    : const _BrandFallback(),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            brand.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _BrandFallback extends StatelessWidget {
  const _BrandFallback();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(Icons.sell_outlined,
          size: 32, color: theme.colorScheme.outline),
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
