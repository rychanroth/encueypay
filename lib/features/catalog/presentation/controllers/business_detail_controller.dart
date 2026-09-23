import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/catalog_repository_impl.dart';
import '../../domain/entities/business_detail.dart';

part 'business_detail_controller.g.dart';

@riverpod
class BusinessDetailController extends _$BusinessDetailController {
  @override
  Future<BusinessDetail> build(String businessId) async {
    return ref.watch(catalogRepositoryProvider).fetchBusinessDetail(businessId);
  }
}
