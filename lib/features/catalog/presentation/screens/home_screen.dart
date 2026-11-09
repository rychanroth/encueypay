import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/failures.dart';

import '../../../../core/presentation/illustrations.dart';
import '../../../../core/presentation/motion.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/widgets/monogram_image.dart';
import '../../../../core/presentation/widgets/staggered_grid.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/brand.dart';
import '../../domain/entities/category.dart';
import '../controllers/brands_provider.dart';
import '../controllers/categories_provider.dart';
import '../controllers/home_feed_providers.dart';
import '../widgets/product_card.dart';
import '../widgets/product_grid.dart';

/// Customer tab 1 — Home. Discovery entry point: search, categories, banners,
/// newest products (spec §32). The businesses strip was removed for the
/// 2-Role Academic Prototype (living spec Part C L-04/L-05) — vendor
/// discovery is bypassed; the underlying data model is untouched.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.actionsBuilder, this.profileAction});

  /// Long-press quick actions per product (Section 6) — injected by the
  /// composition root; null keeps cards tap-only.
  final ProductCardActionsBuilder? actionsBuilder;

  /// Signed-in avatar action, injected by the composition root so the
  /// catalog feature never imports the profile feature (ARCH-04).
  final Widget? profileAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          ?profileAction,
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              // Deep-link into the Discover tab (DESIGN.md §5.1.2).
              onTap: () => context.goNamed(AppRoutes.discovery),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      'Search products',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
          _SectionTitle(
            'Shop by category',
            actionLabel: 'See all',
            onAction: () => context.goNamed(AppRoutes.discovery),
          ),
          _CategoryCardGrid(),
          _SectionTitle('Top brands'),
          _BrandRail(),
          _SectionTitle(
            'New arrivals',
            actionLabel: 'See all',
            onAction: () => context.goNamed(AppRoutes.discovery),
          ),
          _HomeProductsGrid(actionsBuilder: actionsBuilder),
        ],
      ),
    );
  }
}

/// Section header (DESIGN.md §5.1.1): titleLarge headline with optional
/// "See all" action deep-linking into the Discover tab.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

/// Hero promotion banner carousel (DESIGN.md §5.1.1): autoplaying PageView
/// with page indicators and a gradient scrim title. Monogram fallback keeps
/// the tile presentable when imagery is missing or offline.
class _BannersStrip extends ConsumerStatefulWidget {
  const _BannersStrip();

  @override
  ConsumerState<_BannersStrip> createState() => _BannersStripState();
}

class _BannersStripState extends ConsumerState<_BannersStrip> {
  final PageController _pageController = PageController();
  Timer? _autoplay;

  @override
  void initState() {
    super.initState();
    _autoplay = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final banners =
          ref.read(homeBannersProvider).value ?? const <CatalogBanner>[];
      if (banners.length < 2) return;
      final next = (_pageController.page ?? 0).floor() + 1;
      _pageController.animateToPage(
        next % banners.length,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoplay?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(homeBannersProvider);
    final theme = Theme.of(context);
    return bannersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => _SectionRetry(
        message: userMessageFor(error),
        onRetry: () => ref.invalidate(homeBannersProvider),
      ),
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();
        return Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                // Intrinsic height: wider banners grow into a hero up to a
                // bounded max (RESP-01) instead of becoming a thin strip.
                final height =
                    (constraints.maxWidth / AppWidths.bannerAspectRatio)
                        .clamp(
                          AppWidths.bannerMinHeight,
                          AppWidths.bannerMaxHeight,
                        )
                        .toDouble();
                return SizedBox(
                  height: height,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      // Targeted banners are CTAs (Section 9): tap-through to
                      // the Discovery feed pre-filtered to the configured brand
                      // or category — the same deep-link contract as the home
                      // category/brand cards. Untargeted banners stay inert.
                      final onTap = switch (banner.target) {
                        CatalogBannerTarget.brand ||
                        CatalogBannerTarget.category =>
                          banner.targetId == null
                              ? null
                              : () => context.goNamed(
                                    AppRoutes.discovery,
                                    queryParameters: {
                                      'kind': banner.target.name,
                                      'id': banner.targetId!,
                                      'name': banner.targetName ?? banner.name,
                                      'image': banner.imageUrl,
                                    },
                                  ),
                        // Store-wide campaign: the full Discovery feed (every
                        // card in scope carries the discount chip).
                        CatalogBannerTarget.platform => () => context.goNamed(
                              AppRoutes.discovery,
                              queryParameters: {
                                'name': banner.targetName ?? banner.name,
                                'image': banner.imageUrl,
                              },
                            ),
                        CatalogBannerTarget.none => null,
                      };
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: onTap,
                          borderRadius: AppRadii.br16,
                          child: ClipRRect(
                            borderRadius: AppRadii.br16,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                MonogramImage(
                                  imageUrl: banner.imageUrl,
                                  name: banner.name,
                                ),
                                // Gradient scrim — bottom-weighted title panel.
                                const DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.45, 1.0],
                                      colors: [
                                        Colors.transparent,
                                        Color(0xB30F172A)
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: AppSpacing.md,
                                  right: AppSpacing.md,
                                  bottom: AppSpacing.sm + 2,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          banner.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      if (onTap != null)
                                        const Icon(Icons.arrow_forward_ios,
                                            size: 14, color: Colors.white),
                                    ],
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
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < banners.length; i++)
                  AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, _) {
                      final current =
                          _pageController.hasClients
                              ? (_pageController.page ?? 0).round()
                              : 0;
                      final active = current == i;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        );
      },
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
    return categoriesAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => _SectionRetry(
        message: userMessageFor(error),
        onRetry: () => ref.invalidate(categoriesProvider),
      ),
      data: (categories) {
        // Section 2c: the hero grid browses the top-level taxonomy —
        // subcategory products aggregate under their parent in Discover.
        final topLevel =
            categories.where((category) => category.isTopLevel).toList();
        if (topLevel.isEmpty) return const SizedBox.shrink();
        // Bound each tile's width (RESP-01): extra room becomes more columns,
        // never a bigger card — the same rule as the product grid.
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: AppWidths.categoryTileMax,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 4 / 3,
          ),
          itemCount: topLevel.length,
          itemBuilder: (_, index) => _CategoryCard(category: topLevel[index]),
        );
      },
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
        onTap: () => context.goNamed(
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
              // Graceful imagery: skeleton while loading, monogram fallback
              // on null/error (DESIGN.md §6.1) — no blank tiles, ever.
              MonogramImage(
                imageUrl: category.imageUrl,
                name: category.name,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.55],
                      colors: [Colors.transparent, Color(0xB30F172A)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 14, 10, 8),
                    child: Text(
                      category.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: Colors.white),
                    ),
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

/// Brand discovery rail (Section 2c): rounded logo cards in a horizontal
/// scroll, tapping into the brand's discovery page.
class _BrandRail extends ConsumerWidget {
  const _BrandRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsProvider);
    return brandsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => _SectionRetry(
        message: userMessageFor(error),
        onRetry: () => ref.invalidate(brandsProvider),
      ),
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
              onTap: () => context.goNamed(
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
                // Graceful imagery (§6.1): monogram fallback when the brand
                // has no logo or the network fails.
                child: MonogramImage(
                  imageUrl: brand.imageUrl,
                  name: brand.name,
                  icon: Icons.sell_outlined,
                ),
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

class _HomeProductsGrid extends ConsumerWidget {
  const _HomeProductsGrid({this.actionsBuilder});

  final ProductCardActionsBuilder? actionsBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(homeProductsProvider);
    final child = productsAsync.when(
      // Skeleton matches the final grid shape (§4) — no centered spinner.
      loading: () => const _HomeProductsSkeleton(),
      error: (error, _) => _StripError(
        message: userMessageFor(error),
        onRetry: () => ref.invalidate(homeProductsProvider),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const EmptyStateView(
            illustration: AppIllustrations.noProducts,
            title: 'No products yet',
            description: 'New arrivals will appear here.',
          );
        }
        return StaggeredGrid(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: AppWidths.productCardMax,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
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
              actions: actionsBuilder?.call(product),
            );
          },
        );
      },
    );
    // Cross-fade skeleton → content (§3.2).
    final stateKey = productsAsync.hasError
        ? 'error'
        : productsAsync.isLoading && !productsAsync.hasValue
            ? 'loading'
            : 'data';
    return AnimatedSwitcher(
      duration: AppMotion.duration(context, AppMotion.enter),
      switchInCurve: AppMotion.enterCurve,
      switchOutCurve: AppMotion.exitCurve,
      child: KeyedSubtree(key: ValueKey(stateKey), child: child),
    );
  }
}

/// Loading skeleton for the Home product shelf — same geometry as the grid.
class _HomeProductsSkeleton extends StatelessWidget {
  const _HomeProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: AppWidths.productCardMax,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.62,
      ),
      // Matches the home feed's 8-product limit at any column count.
      itemCount: 8,
      itemBuilder: (_, _) => const _HomeProductSkeletonCard(),
    );
  }
}

class _HomeProductSkeletonCard extends StatelessWidget {
  const _HomeProductSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: AppRadii.br16,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SkeletonBox(
              height: double.infinity,
              radius: BorderRadius.zero,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm + 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 90),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(width: 56),
              ],
            ),
          ),
        ],
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

/// Compact inline failure for a home strip: keeps the section visible with a
/// retry instead of silently collapsing it to blank space.
class _SectionRetry extends StatelessWidget {
  const _SectionRetry({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined,
              size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
