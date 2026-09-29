import 'package:flutter/material.dart';

import '../../../../core/domain/failures.dart';
import '../../../../core/domain/money.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';
import 'product_image_gallery.dart';

/// Taobao-style variant picker sheet: product image on top, dynamic price,
/// variant grid, quantity selector — one add-to-cart per invocation. Catalog
/// stays decoupled from cart (ARCH-04): [onAddToCart] is injected by the
/// composition root.
Future<void> showVariantPickerSheet(
  BuildContext context, {
  required Product product,
  required List<ProductVariant> variants,
  required Future<void> Function(String variantId, int quantity) onAddToCart,
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
      onAddToCart: onAddToCart,
    ),
  );
}

class _VariantPickerSheet extends StatefulWidget {
  const _VariantPickerSheet({
    required this.product,
    required this.variants,
    required this.onAddToCart,
  });

  final Product product;
  final List<ProductVariant> variants;
  final Future<void> Function(String variantId, int quantity) onAddToCart;

  @override
  State<_VariantPickerSheet> createState() => _VariantPickerSheetState();
}

class _VariantPickerSheetState extends State<_VariantPickerSheet> {
  static const _maxQuantity = 99;

  /// Products always have at least one variant (`create_product` auto-creates
  /// 'Default'), so a single-option product is preselected; multi-option
  /// products require an explicit choice.
  late String? _selectedVariantId =
      widget.variants.length == 1 ? widget.variants.first.id : null;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = _selected();
    // Base product price until a variant is chosen; the variant's own price
    // (falling back to the base price) once selected.
    final priceMinor =
        selected?.effectivePriceMinor(widget.product) ??
            widget.product.basePriceMinor;
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
                onTap: () => showProductImageGallery(
                  context,
                  imageUrls: widget.product.imageUrls,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 96,
                    height: 96,
                    child: headerImageUrl == null
                        ? ColoredBox(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.image_outlined,
                                color: theme.colorScheme.outline),
                          )
                        : Image.network(
                            headerImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => ColoredBox(
                              color:
                                  theme.colorScheme.surfaceContainerHighest,
                              child: Icon(Icons.image_outlined,
                                  color: theme.colorScheme.outline),
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
                      Text(
                        Money(priceMinor).format(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
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
                      onSelected: (isSelected) => setState(() =>
                          _selectedVariantId = isSelected ? variant.id : null),
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
                onPressed: _quantity < _maxQuantity
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
                  onPressed: selected == null ? null : () => _confirm(selected),
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
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
    }
  }
}
