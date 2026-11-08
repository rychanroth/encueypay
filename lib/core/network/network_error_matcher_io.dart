import 'dart:io';

/// Native platforms: DATA-05 classifies socket failures as network errors.
bool isTransportError(Object error) => error is SocketException;
