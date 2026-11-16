import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/async_value_widget.dart';
import '../../../../core/presentation/illustrations.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/theme/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/presentation/widgets/app_snack_bar.dart';
import '../controllers/wishlist_controller.dart';
import '../../domain/entities/wishlist_item.dart';

/// Builds the card widget for one wishlist item (Section 6): the
/// composition root renders the shared catalog ProductCard with quick
/// actions — features/wishlist never imports features/catalog (ARCH-04).
typedef WishlistCardBuilder = Widget Function(WishlistItem item);

/// Saved products (spec §38). With a [cardBuilder] the screen renders a
/// product-card grid (tap → detail, long-press → quick actions); otherwise
/// it falls back to the simple tile list. Adding/removing is wired through
/// the injected card actions, not here.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key, this.cardBuilder});

  final WishlistCardBuilder? cardBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistControllerProvider);

    ref.listen(wishlistControllerProvider, (previous, next) {
      final error = next.hasError ? next.error : null;
      if (error is Failure) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(AppSnackBar(content: Text(userMessageFor(error))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userMessageFor(error), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(wishlistControllerProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyStateView(
              illustration: AppIllustrations.emptyWishlist,
              title: 'Your wishlist is empty',
              description: 'Save products you want to come back to.',
              actionLabel: 'Browse products',
              onAction: () => context.goNamed(AppRoutes.home),
            );
          }
          if (cardBuilder != null) {
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: AppWidths.productCardMax,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.62,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => cardBuilder!(items[index]),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: item.imageUrl != null
                          ? Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.image_outlined),
                            )
                          : const Icon(Icons.image_outlined),
                    ),
                  ),
                  title: Text(item.productName, maxLines: 1),
                  subtitle: Text(Money(item.fromPriceMinor).format()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await ref
                            .read(wishlistControllerProvider.notifier)
                            .remove(productId: item.productId);
                      } catch (error) {
                        // Optimistic remove rolls back and rethrows (PRES-03
                        // exception) — surface the rejection here.
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            AppSnackBar(content: Text(userMessageFor(error))),
                          );
                      }
                    },
                  ),
                  onTap: () => context.pushNamed(
                    AppRoutes.productDetail,
                    pathParameters: {'id': item.productId},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
