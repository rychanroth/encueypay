import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/catalog/data/dtos/product_dto.dart';
import 'package:encueypay/features/catalog/data/dtos/product_variant_dto.dart';
import 'package:encueypay/features/catalog/data/mappers/product_mapper.dart';
import 'package:encueypay/features/wishlist/data/dtos/wishlist_item_dto.dart';
import 'package:encueypay/features/wishlist/data/mappers/wishlist_item_mapper.dart';

void main() {
  ProductDto dto({
    required int basePriceMinor,
    required List<ProductVariantPriceDto> variants,
  }) => ProductDto(
    id: 'product-1',
    categoryId: 'category-1',
    name: 'Product',
    description: '',
    basePriceMinor: basePriceMinor,
    productVariants: variants,
  );

  test('all active variants are visible, including a named Default', () {
    final product = dto(
      basePriceMinor: 4000,
      variants: const [
        ProductVariantPriceDto(
          id: 'default',
          priceMinor: 4000,
          status: 'active',
        ),
        ProductVariantPriceDto(id: 'cheap', priceMinor: 5000, status: 'active'),
        ProductVariantPriceDto(id: 'dear', priceMinor: 7000, status: 'active'),
        ProductVariantPriceDto(
          id: 'archived',
          priceMinor: 100,
          status: 'archived',
        ),
      ],
    ).toDomain();

    // Cheapest active option wins the "from" price and default selection.
    expect(product.fromPriceMinor, 4000);
    expect(product.defaultVariantId, 'default');
  });

  test('archived rows never contribute to price or selection', () {
    final product = dto(
      basePriceMinor: 9000,
      variants: const [
        ProductVariantPriceDto(id: 'large', priceMinor: 6000, status: 'active'),
        ProductVariantPriceDto(
          id: 'retired',
          priceMinor: 100,
          status: 'archived',
        ),
      ],
    ).toDomain();

    expect(product.fromPriceMinor, 6000);
    expect(product.defaultVariantId, 'large');
  });

  test('equal prices fall back to a deterministic id tie-break', () {
    final product = dto(
      basePriceMinor: 9000,
      variants: const [
        ProductVariantPriceDto(id: 'b', priceMinor: 5000, status: 'active'),
        ProductVariantPriceDto(id: 'a', priceMinor: 5000, status: 'active'),
      ],
    ).toDomain();

    expect(product.defaultVariantId, 'a');
  });

  test('no variants falls back to the cached base price', () {
    final product = dto(basePriceMinor: 3200, variants: const []).toDomain();

    expect(product.fromPriceMinor, 3200);
    expect(product.defaultVariantId, isNull);
  });

  WishlistItemDto wishlistDto({
    required int basePriceMinor,
    required List<WishlistVariantJoinDto> variants,
  }) => WishlistItemDto(
    id: 'wishlist-1',
    productId: 'product-1',
    products: WishlistProductJoinDto(
      name: 'Product',
      basePriceMinor: basePriceMinor,
      productVariants: variants,
    ),
  );

  test('wishlist uses the same active-only variant rules as catalog', () {
    final item = wishlistDto(
      basePriceMinor: 4000,
      variants: const [
        WishlistVariantJoinDto(
          id: 'default',
          priceMinor: 4000,
          status: 'active',
        ),
        WishlistVariantJoinDto(id: 'cheap', priceMinor: 5000, status: 'active'),
        WishlistVariantJoinDto(
          id: 'archived',
          priceMinor: 100,
          status: 'archived',
        ),
      ],
    ).toDomain();

    expect(item.fromPriceMinor, 4000);
    expect(item.defaultVariantId, 'default');
  });

  test('wishlist with no active variants uses the cached base price', () {
    final item = wishlistDto(
      basePriceMinor: 4000,
      variants: const [
        WishlistVariantJoinDto(
          id: 'archived',
          priceMinor: 100,
          status: 'archived',
        ),
      ],
    ).toDomain();

    expect(item.fromPriceMinor, 4000);
    expect(item.defaultVariantId, isNull);
  });
}
