import 'package:freezed_annotation/freezed_annotation.dart';

part 'administrative_unit.freezed.dart';

/// One node in the bundled official Cambodian administrative hierarchy.
/// A province's [children] are districts; a district's are communes; a
/// commune's are villages. Village nodes have no children.
@freezed
abstract class AdministrativeUnit with _$AdministrativeUnit {
  const factory AdministrativeUnit({
    required String code,
    required String nameEn,
    required String nameKm,
    @Default([]) List<AdministrativeUnit> children,
  }) = _AdministrativeUnit;

  const AdministrativeUnit._();

  /// `Boeng Keng Kang · បឹងកេងកង`
  String get label => '$nameEn · $nameKm';
}
