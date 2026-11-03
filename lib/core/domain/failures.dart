/// Shared failure taxonomy (CORE-02 / DATA-05).
///
/// Repositories map raw exceptions to these at the repository boundary only;
/// nothing in `domain/` or `presentation/` ever sees a raw exception.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// A rejection that came from the backend: PostgREST errors, and auth
/// rejections (invalid credentials etc. — the auth server responded).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

/// Anything that failed before/at the network layer.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error']);
}

/// A client-side bug that no repository anticipated — a TypeError in DTO
/// parsing, a StateError, a FormatException. The message carries the
/// underlying cause verbatim so the real defect is visible where the
/// failure lands (prototype trade-off: raw cause is user-facing; the
/// original error and stack are also logged at the mapping site).
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(Object cause) : super('Unexpected error: $cause');
}

/// Presentation-safe copy for a caught error. Recognized failures keep
/// their actionable message; unexpected/client-bug failures never leak raw
/// types or stack details into the UI.
String userMessageFor(Object error) {
  if (error is UnexpectedFailure) {
    return 'Something went wrong. Please try again.';
  }
  if (error is Failure) return error.message;
  return 'Something went wrong. Please try again.';
}
