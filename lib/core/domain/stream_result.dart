import 'dart:async';

import 'failures.dart';

/// Wrapper for repository streams (DATA-06): failures are surfaced as
/// [StreamError] *data* events so consumers switch on the result type and
/// an error never terminates the stream.
sealed class StreamResult<T> {
  const StreamResult();
}

class StreamData<T> extends StreamResult<T> {
  const StreamData(this.data);

  final T data;
}

class StreamError<T> extends StreamResult<T> {
  const StreamError(this.failure);

  final Failure failure;
}

extension StreamResultGuardX<T> on Stream<T> {
  /// Converts a raw repository stream into a [StreamResult] stream.
  ///
  /// Uses `StreamTransformer.fromHandlers` instead of `handleError` because
  /// `handleError` can only swallow errors — it cannot emit the required
  /// [StreamError] data event. The subscription stays alive after an error
  /// (DATA-06: "errors never terminate the stream").
  Stream<StreamResult<T>> asStreamResult(
    Failure Function(Object error) mapError,
  ) {
    return transform(
      StreamTransformer.fromHandlers(
        handleData: (T data, EventSink<StreamResult<T>> sink) {
          sink.add(StreamData(data));
        },
        handleError: (
          Object error,
          StackTrace stackTrace,
          EventSink<StreamResult<T>> sink,
        ) {
          sink.add(StreamError(mapError(error)));
        },
      ),
    );
  }
}
