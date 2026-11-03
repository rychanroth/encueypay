import 'package:flutter_test/flutter_test.dart';

import 'package:encueypay/core/domain/failures.dart';

void main() {
  test('recognized failures keep their actionable message', () {
    expect(
      userMessageFor(const ServerFailure('Coupon expired')),
      'Coupon expired',
    );
    expect(userMessageFor(const NetworkFailure()), 'Network error');
  });

  test('unexpected and raw errors never leak implementation detail', () {
    expect(
      userMessageFor(const UnexpectedFailure('type Null is not String')),
      'Something went wrong. Please try again.',
    );
    expect(
      userMessageFor(StateError('bad state')),
      'Something went wrong. Please try again.',
    );
  });
}
