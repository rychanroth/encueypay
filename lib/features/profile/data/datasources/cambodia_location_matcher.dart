import '../../domain/entities/administrative_unit.dart';
import '../../domain/entities/located_address.dart';
import 'cambodia_geo_data_source.dart';

/// Matches a Nominatim `address` object to the bundled official hierarchy.
/// Best-effort: each level is matched independently within its parent, and
/// uncertain levels stay null so the user can confirm/choose them.
class CambodiaLocationMatcher {
  CambodiaLocationMatcher(this._data);

  final CambodiaGeoDataSource _data;

  Future<LocatedAddress?> match(Map<String, dynamic> response) async {
    final raw = response['address'];
    if (raw is! Map) return null;
    final address = <String, String>{
      for (final entry in raw.entries)
        if (entry.key is String && entry.value is String)
          entry.key as String: entry.value as String,
    };

    final provinces = await _data.provinces();
    AdministrativeUnit? province;
    final iso = address['ISO3166-2-lvl4'];
    if (iso != null && iso.toUpperCase().startsWith('KH-')) {
      final code = iso.substring(3).padLeft(2, '0');
      for (final unit in provinces) {
        if (unit.code == code) {
          province = unit;
          break;
        }
      }
    }
    province ??= _best(
      provinces,
      _values(address, ['state', 'province', 'region']),
    );

    if (province == null) {
      return LocatedAddress(
        line1: _line1(address),
        city: _first(address, ['state', 'city', 'town', 'village', 'county']),
      );
    }

    final provinceNode = await _data.province(province.code);
    final districts = provinceNode?.children ?? const <AdministrativeUnit>[];
    final district = _best(
      districts,
      _values(address, [
        'city_district',
        'district',
        'county',
        'town',
        'municipality',
      ]),
    );

    final communes = district?.children ?? const <AdministrativeUnit>[];
    final commune = _best(
      communes,
      _values(address, [
        'suburb',
        'quarter',
        'village',
        'hamlet',
        'neighbourhood',
      ]),
    );

    final villages = commune?.children ?? const <AdministrativeUnit>[];
    final village = _best(
      villages,
      _values(address, ['village', 'hamlet', 'neighbourhood', 'quarter']),
    );

    return LocatedAddress(
      line1: _line1(address),
      city: province.nameEn,
      provinceCode: province.code,
      provinceName: province.nameEn,
      districtCode: district?.code,
      districtName: district?.nameEn,
      communeCode: commune?.code,
      communeName: commune?.nameEn,
      villageCode: village?.code,
      villageName: village?.nameEn,
    );
  }

  static String _line1(Map<String, String> address) {
    final number = address['house_number']?.trim();
    final road = _first(address, ['road', 'pedestrian', 'footway', 'path']);
    if (number != null &&
        number.isNotEmpty &&
        road != null &&
        road.isNotEmpty) {
      return '$number $road';
    }
    if (road != null && road.isNotEmpty) return road;
    return _first(address, ['name', 'display_name']) ?? '';
  }

  static String? _first(Map<String, String> address, List<String> keys) {
    for (final key in keys) {
      final value = address[key]?.trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  static List<String> _values(Map<String, String> address, List<String> keys) {
    return [
      for (final key in keys)
        if (address[key]?.trim().isNotEmpty == true) address[key]!.trim(),
    ];
  }

  static AdministrativeUnit? _best(
    List<AdministrativeUnit> units,
    List<String> candidates,
  ) {
    if (units.isEmpty || candidates.isEmpty) return null;
    AdministrativeUnit? best;
    var bestScore = 0;
    for (final unit in units) {
      for (final candidate in candidates) {
        final score = _score(candidate, unit);
        if (score > bestScore) {
          bestScore = score;
          best = unit;
        }
      }
    }
    // Weak substring hits are worse than leaving the level for the user.
    return bestScore >= 60 ? best : null;
  }

  static int _score(String candidate, AdministrativeUnit unit) {
    final value = _normalize(candidate);
    if (value.isEmpty) return 0;
    var best = 0;
    for (final name in [unit.nameEn, unit.nameKm]) {
      final target = _normalize(name);
      if (target.isEmpty) continue;
      if (value == target) return 100;
      if (value.contains(target) || target.contains(value)) {
        if (best < 85) best = 85;
      } else {
        final valueTokens = value.split(' ').toSet();
        final targetTokens = target.split(' ').toSet();
        final overlap = valueTokens.intersection(targetTokens).length;
        if (overlap > 0) {
          final score = 40 + overlap * 10;
          if (score > best) best = score.clamp(0, 79);
        }
      }
    }
    return best;
  }

  static String _normalize(String input) {
    var value = input.toLowerCase().trim();
    value = value.replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
    value = value.replaceAll(RegExp(r'[.,/()\-]'), ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    for (final prefix in _prefixes) {
      if (value == prefix) continue;
      if (value.startsWith('$prefix ')) {
        value = value.substring(prefix.length + 1).trim();
      } else if (value.startsWith(prefix) && _isKhmerPrefix(prefix)) {
        value = value.substring(prefix.length).trim();
      }
    }
    return value;
  }

  static bool _isKhmerPrefix(String prefix) =>
      prefix.runes.any((rune) => rune >= 0x1780 && rune <= 0x17FF);

  static const _prefixes = [
    'province',
    'capital',
    'municipality',
    'city',
    'district',
    'khan',
    'srok',
    'krong',
    'commune',
    'sangkat',
    'khum',
    'village',
    'phum',
    'រាជធានី',
    'ខេត្ត',
    'ក្រុង',
    'ខណ្ឌ',
    'ស្រុក',
    'សង្កាត់',
    'ឃុំ',
    'ភូមិ',
  ];
}
