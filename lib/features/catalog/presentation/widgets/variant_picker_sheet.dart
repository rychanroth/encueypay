import 'package:flutter/material.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/network/failure_mapping.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/active_promo.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import '../controllers/promo_chip_providers.dart';
import 'product_image_gallery.dart';

/// Taobao-style variant picker sheet: product image on top, dynamic price,
/// variant grid, quantity selector — one add-to-cart per invocation. Catalog
/// stays decoupled from cart (ARCH-04): [onAddToCart] is injected by the
/// composition root. [initialVariantId] preselects the variant chosen on the
/// product page, keeping the sheet and the page's variant rail in sync.
Future<void> showVariantPickerSheet(
  BuildContext context, {
  required Product product,
  required List<ProductVariant> variants,
  required Future<void> Function(String variantId, int quantity) onAddToCart,
  String? initialVariantId,
  ActivePromo? promo,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => _VariantPickerSheet(
      product: product,
      variants: variants,
      initialVariantId: initialVariantId,
      onAddToCart: onAddToCart,
      promo: promo,
    ),
  );
}

class _VariantPickerSheet extends StatefulWidget {
  const _VariantPickerSheet({
    required this.product,
    required this.variants,
    required this.onAddToCart,
    this.initialVariantId,
    this.promo,
  });

  final Product product;
  final List<ProductVariant> variants;
  final String? initialVariantId;

  /// The product's matched promotion — percent campaigns price the sheet at
  /// the real discounted amount, matching the page behind it.
  final ActivePromo? promo;
  final Future<void> Function(String variantId, int quantity) onAddToCart;

  @override
  State<_VariantPickerSheet> createState() => _VariantPickerSheetState();
}

class _VariantPickerSheetState extends State<_VariantPickerSheet> {
  static const _maxQuantity = 99;

  /// Preselection order: the product page's variant rail choice, then the
  /// product's default variant, then the sole variant of a one-option
  /// product. A multi-variant sheet therefore never opens with a disabled
  /// CTA (user feedback 2026-10-28).
  late String? _selectedVariantId = widget.initialVariantId ??
      widget.product.defaultVariantId ??
      (widget.variants.length == 1 ? widget.variants.first.id : null);
  int _quantity = 1;

  /// Product-wide stock (Section 2d) caps the quantity selector; the server
  /// re-validates authoritatively at add and at checkout.
  int get _stockCap => widget.product.stock < 1
      ? 0
      : (widget.product.stock < _maxQuantity
          ? widget.product.stock
          : _maxQuantity);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = _selected();
    // Base product price until a variant is chosen; the variant's own price
    // (falling back to the base price) once selected.
    final priceMinor =
        selected?.effectivePriceMinor(widget.product) ??
            widget.product.basePriceMinor;
    final discounted = discountedDisplayMinor(widget.promo, priceMinor);
    final headerImageUrl = selected?.imageUrl ??
        (widget.product.imageUrls.isEmpty
            ? null
            : widget.product.imageUrls.first);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                // Every product image + every variant image in one
                // full-screen gallery; a selected variant's own image opens
                // preselected (Section 9) instead of dropping the rest.
                onTap: () {
                  final urls = <String>{
                    ...widget.product.imageUrls,
                    for (final variant in widget.variants)
                      if (variant.imageUrl != null) variant.imageUrl!,
                  }.toList();
                  final variantImage = selected?.imageUrl;
                  final initialIndex = variantImage == null
                      ? 0
                      : urls.indexOf(variantImage).clamp(0, urls.length - 1);
                  showProductImageGallery(
                    context,
                    imageUrls: urls,
                    initialIndex: initialIndex,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: headerImageUrl == null
                        ? ColoredBox(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.image_outlined,
                                color: theme.colorScheme.onSurfaceVariant),
                          )
                        : Image.network(
                            headerImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => ColoredBox(
                              color:
                                  theme.colorScheme.surfaceContainerHighest,
                              child: Icon(Icons.image_outlined,
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            Money(discounted ?? priceMinor).format(),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          if (discounted != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              Money(priceMinor).format(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (selected != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Selected: ${selected.name}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final variant in widget.variants)
                    ChoiceChip(
                      label: Text(variant.name),
                      selected: _selectedVariantId == variant.id,
                      // Non-deselectable: a selection always exists (the
                      // CTA and the displayed price depend on it).
                      onSelected: (_) =>
                          setState(() => _selectedVariantId = variant.id),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Quantity', style: theme.textTheme.titleSmall),
              const Spacer(),
              if (widget.product.stock > 0)
                Text(
                  '${widget.product.stock} available',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                tooltip: 'Decrease',
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Increase',
                onPressed: _quantity < _stockCap
                    ? () => setState(() => _quantity++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  // Out-of-stock products cannot be purchased (Section 2d).
                  onPressed: selected == null || _stockCap < 1
                      ? null
                      : () => _confirm(selected),
                  child: const Text('Add to cart'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ProductVariant? _selected() {
    for (final variant in widget.variants) {
      if (variant.id == _selectedVariantId) return variant;
    }
    return null;
  }

  Future<void> _confirm(ProductVariant variant) async {
    final quantity = _quantity;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await widget.onAddToCart(variant.id, quantity);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Added to cart')));
    } on Failure catch (failure) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message)));
    } catch (error, stackTrace) {
      // DATA-05: presentation never sees raw exceptions — classify first.
      final failure = mapRepositoryError(error, stackTrace);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }
}
