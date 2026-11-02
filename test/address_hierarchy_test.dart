import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/profile/data/datasources/cambodia_geo_data_source.dart';
import 'package:encueypay/features/profile/data/datasources/cambodia_location_matcher.dart';
import 'package:encueypay/features/profile/domain/entities/address.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('official hierarchy assets load', () async {
    final data = CambodiaGeoDataSource();
    final provinces = await data.provinces();
    expect(provinces.length, 25);

    final phnomPenh = await data.province('12');
    expect(phnomPenh, isNotNull);
    expect(phnomPenh!.nameEn, 'Phnom Penh');
    expect(phnomPenh.children, isNotEmpty);
  });

  test('address drafts keep the official codes and coordinates', () {
    const draft = AddressDraft(
      label: 'Home',
      recipientName: 'Test',
      phone: '012',
      line1: 'Street 1',
      city: 'Boeng Keng Kang Ti Muoy, Boeng Keng Kang, Phnom Penh',
      provinceCode: '12',
      districtCode: '1213',
      communeCode: '121301',
      villageCode: '12130101',
      latitude: 11.5564,
      longitude: 104.9282,
    );

    final address = draft.toEntity('address-1');
    expect(address.provinceCode, '12');
    expect(address.districtCode, '1213');
    expect(address.communeCode, '121301');
    expect(address.villageCode, '12130101');
    expect(address.latitude, 11.5564);
  });

  test('Nominatim Phnom Penh address matches official codes', () async {
    final data = CambodiaGeoDataSource();
    final located = await CambodiaLocationMatcher(data).match({
      'address': {
        'village': 'Sangkat Boeng Keng Kang Ti Muoy',
        'town': 'Khan Boeng Keng Kang',
        'state': 'Phnom Penh',
        'ISO3166-2-lvl4': 'KH-12',
        'road': 'Independence Monument Roundabout',
      },
    });

    expect(located, isNotNull);
    expect(located!.provinceCode, '12');
    expect(located.districtCode, '1213');
    expect(located.communeCode, '121301');
    expect(located.line1, 'Independence Monument Roundabout');
  });
}
