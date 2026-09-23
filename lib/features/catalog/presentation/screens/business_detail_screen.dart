import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/responsive/screen_size.dart';
import '../../../../core/router/app_routes.dart';
import '../controllers/business_detail_controller.dart';
import '../widgets/product_card.dart';

/// Business discovery (spec §32): store header + its active products.
class BusinessDetailScreen extends ConsumerWidget {
  const BusinessDetailScreen({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync =
        ref.watch(businessDetailControllerProvider(businessId));
    final columns = switch (context.screenSize) {
      ScreenSize.expanded => 4,
      ScreenSize.medium => 3,
      ScreenSize.compact => 2,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Business')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => ref
                    .invalidate(businessDetailControllerProvider(businessId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (detail) => ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: detail.business.imageUrl != null
                  ? Image.network(
                      detail.business.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const _BusinessHeaderPlaceholder(),
                    )
                  : const _BusinessHeaderPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.business.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (detail.business.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(detail.business.description),
                  ],
                ],
              ),
            ),
            if (detail.products.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('This business has no products yet.'),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.62,
                ),
                itemCount: detail.products.length,
                itemBuilder: (context, index) {
                  final product = detail.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => context.pushNamed(
                      AppRoutes.productDetail,
                      pathParameters: {'id': product.id},
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _BusinessHeaderPlaceholder extends StatelessWidget {
  const _BusinessHeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.storefront,
          size: 48, color: Theme.of(context).colorScheme.outline),
    );
  }
}
