import 'network_error_matcher_stub.dart'
    if (dart.library.io) 'network_error_matcher_io.dart' as impl;

/// Whether [error] is a transport-level failure (DATA-05's socket class).
///
/// Split by platform because `SocketException` lives in `dart:io`, which does
/// not exist on web; the web build imports the stub and classifies nothing as
/// a socket error, leaving the default (logged `UnexpectedFailure`) intact.
bool isTransportError(Object error) => impl.isTransportError(error);
