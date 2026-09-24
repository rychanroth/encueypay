import 'package:freezed_annotation/freezed_annotation.dart';

import 'business.dart';
import 'product.dart';

part 'business_detail.freezed.dart';

/// Composite read model for the business detail screen.
@freezed
abstract class BusinessDetail with _$BusinessDetail {
  const factory BusinessDetail({
    required Business business,
    required List<Product> products,
  }) = _BusinessDetail;
}
