import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:encueypay/core/domain/failures.dart';
import 'package:encueypay/core/network/failure_mapping.dart';

/// Pins DATA-05's classification: backend failures → ServerFailure, socket
/// failures → NetworkFailure, and — the reason this mapper exists — client
/// bugs (TypeError in DTO parsing et al.) → UnexpectedFailure with the
/// cause in the message, NEVER relabeled as "Network error".
void main() {
  test('PostgrestException → ServerFailure', () {
    final failure = mapRepositoryError(
      const PostgrestException(code: '23505', message: 'duplicate key'),
    );
    expect(failure, isA<ServerFailure>());
    expect(failure.message, 'duplicate key');
  });

  test('AuthException → ServerFailure', () {
    final failure =
        mapRepositoryError(const AuthException('Invalid login credentials'));
    expect(failure, isA<ServerFailure>());
    expect(failure.message, 'Invalid login credentials');
  });

  test('SocketException → NetworkFailure', () {
    final failure = mapRepositoryError(
      const SocketException('Connection refused', port: 54321),
    );
    expect(failure, isA<NetworkFailure>());
  });

  test('TypeError (fromJson shape bug) → UnexpectedFailure with the cause',
      () {
    final TypeError error;
    try {
      // The exact failure mode that broke the admin orders screen: a
      // one-to-one embed (Map) parsed into a List-typed DTO field.
      final value = <String, dynamic>{'payments': <String, dynamic>{}};
      final list = value['payments'] as List<dynamic>?;
      // ignore: avoid_dynamic_calls
      list!.length;
      fail('expected TypeError');
    } on TypeError catch (e) {
      error = e;
    }
    final failure = mapRepositoryError(error, StackTrace.current);
    expect(failure, isA<UnexpectedFailure>());
    expect(failure.message, contains('Unexpected error'));
    expect(failure.message, contains('not a subtype'));
  });

  test('StateError → UnexpectedFailure', () {
    final failure = mapRepositoryError(StateError('bad state: null'));
    expect(failure, isA<UnexpectedFailure>());
    expect(failure.message, contains('bad state: null'));
  });
}
