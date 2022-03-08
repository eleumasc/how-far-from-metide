import 'dart:io';

/// A contract for an information channel that communicates the device's
/// Internet connection status.
abstract class NetworkInfo {
  /// It returns true whether the device is connected to the Internet,
  /// false otherwise.
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected => _isConnected();

  /// It looks up for a well-known existing domain ("example.com") and
  /// returns true if the address has been found, false otherwise.
  Future<bool> _isConnected() async {
    try {
      final result = await InternetAddress.lookup("example.com");
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
