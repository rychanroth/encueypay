import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/features/auth/data/dtos/user_dto.dart';
import 'package:encueypay/features/auth/domain/customer_onboarding.dart';
import 'package:encueypay/features/auth/domain/entities/app_user.dart';
import 'package:encueypay/features/auth/domain/entities/user_role.dart';

/// Pins the onboarding gate and the phone rules: only `customer` is onboarded,
/// completed users never see it again, and malformed numbers are rejected
/// before they reach the profile.
void main() {
  group('needsCustomerOnboarding', () {
    AppUser user({UserRole role = UserRole.customer, DateTime? onboardedAt}) {
      return AppUser(
        id: 'user-1',
        fullName: 'Dara',
        activeRole: role,
        onboardedAt: onboardedAt,
      );
    }

    test('a signed-out user never onboards', () {
      expect(needsCustomerOnboarding(null), isFalse);
    });

    test('an unfinished customer onboards', () {
      expect(needsCustomerOnboarding(user()), isTrue);
    });

    test('a completed customer is left alone', () {
      expect(
        needsCustomerOnboarding(user(onboardedAt: DateTime(2026, 11, 17))),
        isFalse,
      );
    });

    test('admins and legacy roles are never gated', () {
      expect(needsCustomerOnboarding(user(role: UserRole.admin)), isFalse);
      expect(needsCustomerOnboarding(user(role: UserRole.business)), isFalse);
      expect(needsCustomerOnboarding(user(role: UserRole.driver)), isFalse);
    });
  });

  group('normalizeCustomerPhone', () {
    test('accepts local digits and strips separators', () {
      expect(normalizeCustomerPhone('012 345 678'), '012345678');
      expect(normalizeCustomerPhone('(012) 345-678'), '012345678');
      expect(normalizeCustomerPhone('012.345.678'), '012345678');
    });

    test('preserves an international prefix', () {
      expect(normalizeCustomerPhone('+855 12 345 678'), '+85512345678');
    });

    test('enforces the 8–15 digit window', () {
      expect(normalizeCustomerPhone('1234567'), isNull);
      expect(normalizeCustomerPhone('12345678'), '12345678');
      expect(normalizeCustomerPhone('123456789012345'), '123456789012345');
      expect(normalizeCustomerPhone('1234567890123456'), isNull);
    });

    test('rejects empty input, letters and double plus signs', () {
      expect(normalizeCustomerPhone(''), isNull);
      expect(normalizeCustomerPhone('  '), isNull);
      expect(normalizeCustomerPhone('012ABC678'), isNull);
      expect(normalizeCustomerPhone('++85512345678'), isNull);
    });
  });

  test('UserDto parses the onboarding timestamp from the users row', () {
    final dto = UserDto.fromJson({
      'id': 'user-1',
      'full_name': 'Dara',
      'onboarded_at': '2026-11-17T08:30:00+00:00',
    });

    expect(dto.onboardedAt, DateTime.utc(2026, 11, 17, 8, 30));
  });
}
