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
