import 'business.dart';
import 'product.dart';

/// Composite read model for the business detail screen.
class BusinessDetail {
  const BusinessDetail({
    required this.business,
    required this.products,
  });

  final Business business;
  final List<Product> products;
}
