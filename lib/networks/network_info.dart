import 'package:connectivity_plus/connectivity_plus.dart';

// Network connectivity checker
// Monitors internet connection status
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  // Check if device is connected to internet
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  // Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  // Helper to determine if connected
  bool _isConnected(List<ConnectivityResult> results) {
    // If any result is not none, we have connectivity
    return results.any((result) => result != ConnectivityResult.none);
  }

  // Check for specific connection types
  Future<bool> get isWifi async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.wifi);
  }

  Future<bool> get isMobile async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile);
  }

  Future<bool> get isEthernet async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.ethernet);
  }
}
