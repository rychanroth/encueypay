import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/router/app_routes.dart';
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
          ..showSnackBar(SnackBar(content: Text(error.message)));
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
              Text('$error', textAlign: TextAlign.center),
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
            return const Center(child: Text('Your wishlist is empty.'));
          }
          if (cardBuilder != null) {
            final columns = switch (context.screenSize) {
              ScreenSize.expanded => 4,
              ScreenSize.medium => 3,
              ScreenSize.compact => 2,
            };
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.62,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => cardBuilder!(items[index]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
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
                  subtitle: Text(Money(item.priceMinor).format()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref
                        .read(wishlistControllerProvider.notifier)
                        .remove(productId: item.productId),
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
