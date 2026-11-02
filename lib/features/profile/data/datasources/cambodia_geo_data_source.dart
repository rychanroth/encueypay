import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/entities/administrative_unit.dart';

/// Read-only access to the bundled official 2025 Cambodian hierarchy
/// (`assets/geo`, sourced from MEF). No network and no persistence.
class CambodiaGeoDataSource {
  static const _provincesAsset = 'assets/geo/provinces.json';

  Future<List<AdministrativeUnit>> provinces() async {
    final raw = jsonDecode(await rootBundle.loadString(_provincesAsset));
    if (raw is! List) return const [];
    return [
      for (final row in raw)
        if (row is Map<String, dynamic>)
          AdministrativeUnit(
            code: row['code'] as String? ?? '',
            nameEn: row['name_en'] as String? ?? '',
            nameKm: row['name_km'] as String? ?? '',
          ),
    ];
  }

  /// The province node with nested districts → communes → villages.
  Future<AdministrativeUnit?> province(String provinceCode) async {
    // Official province codes are exactly two digits; reject anything else
    // before using the code in an asset path.
    if (!RegExp(r'^\d{2}$').hasMatch(provinceCode)) return null;
    final raw = jsonDecode(
      await rootBundle.loadString('assets/geo/provinces/$provinceCode.json'),
    );
    if (raw is! Map<String, dynamic>) return null;
    return _unit(raw, childrenKey: 'districts');
  }

  Future<List<AdministrativeUnit>> districts(String provinceCode) async {
    return (await province(provinceCode))?.children ?? const [];
  }

  Future<List<AdministrativeUnit>> communes(
    String provinceCode,
    String districtCode,
  ) async {
    final provinceNode = await province(provinceCode);
    final district = _find(provinceNode?.children, districtCode);
    return district?.children ?? const [];
  }

  Future<List<AdministrativeUnit>> villages(
    String provinceCode,
    String districtCode,
    String communeCode,
  ) async {
    final provinceNode = await province(provinceCode);
    final district = _find(provinceNode?.children, districtCode);
    final commune = _find(district?.children, communeCode);
    return commune?.children ?? const [];
  }

  static AdministrativeUnit? _find(
    List<AdministrativeUnit>? units,
    String? code,
  ) {
    if (units == null || code == null) return null;
    for (final unit in units) {
      if (unit.code == code) return unit;
    }
    return null;
  }

  static AdministrativeUnit _unit(
    Map<String, dynamic> row, {
    required String childrenKey,
  }) {
    final rows = row[childrenKey] is List ? row[childrenKey] as List : const [];
    final childKey = switch (childrenKey) {
      'districts' => 'communes',
      'communes' => 'villages',
      _ => null,
    };
    return AdministrativeUnit(
      code: row['code'] as String? ?? '',
      nameEn: row['name_en'] as String? ?? '',
      nameKm: row['name_km'] as String? ?? '',
      children: [
        for (final child in rows)
          if (child is Map<String, dynamic>)
            childKey == null
                ? AdministrativeUnit(
                    code: child['code'] as String? ?? '',
                    nameEn: child['name_en'] as String? ?? '',
                    nameKm: child['name_km'] as String? ?? '',
                  )
                : _unit(child, childrenKey: childKey),
      ],
    );
  }
}
