import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/failures.dart';

/// DATA-05 error mapping, implemented once.
///
/// Repositories are the only layer that may catch raw exceptions (DATA-05),
/// and every catch site funnels through [mapRepositoryError] instead of
/// hand-rolling a two-way guess. Classification:
///
///   * recognized backend failures → [ServerFailure]
///   * socket-level failures       → [NetworkFailure]
///   * anything else is a CLIENT BUG — logged (error + stack, debug builds)
///     and thrown as [UnexpectedFailure] carrying the cause. Relabeling a
///     parse TypeError as "Network error" hid three real bugs before this
///     mapper existed; that is exactly what it exists to prevent.
///
/// Catch sites must capture the stack trace and pass it through:
/// ```dart
/// } catch (error, stackTrace) { // DATA-05: classify, don't guess
///   throw mapRepositoryError(error, stackTrace);
/// }
/// ```
Failure mapRepositoryError(Object error, [StackTrace? stackTrace]) {
  switch (error) {
    case final PostgrestException e:
      return ServerFailure(e.message);
    case final StorageException e:
      return ServerFailure(e.message);
    case final AuthException e:
      return ServerFailure(e.message);
    case final FunctionException e:
      return ServerFailure(
        e.reasonPhrase ?? e.details?.toString() ?? 'Edge function failed',
      );
    case final SocketException _:
      return const NetworkFailure();
    default:
      if (kDebugMode) {
        debugPrint(
          '[data-error] unexpected ${error.runtimeType} '
          '(relabeled as UnexpectedFailure, not NetworkFailure)\n'
          '$error\n'
          '${stackTrace ?? StackTrace.current}',
        );
      }
      return UnexpectedFailure(error);
  }
}

/// For DELIBERATE best-effort swallows (fire-and-forget cleanup, optional
/// capabilities): keeps the failure observable without changing control
/// flow. Not a substitute for mapping — throwing sites use
/// [mapRepositoryError].
void logSuppressedError(Object error, StackTrace stackTrace) {
  if (kDebugMode) {
    debugPrint(
      '[data-error] suppressed ${error.runtimeType} (deliberate best-effort '
      'swallow — see catch site)\n$error\n$stackTrace',
    );
  }
}
