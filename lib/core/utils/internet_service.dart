import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetService with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // Track if we've shown the offline banner
  bool _showOfflineBanner = false;
  bool get showOfflineBanner => _showOfflineBanner;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<dynamic>? _subscription;

  // Singleton pattern
  static final InternetService _instance = InternetService._internal();
  factory InternetService() => _instance;
  InternetService._internal() {
    _init();
  }

  Future<void> _init() async {
    await _checkConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnection,
    );
  }

  Future<void> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnection(result);
  }

  void _updateConnection(dynamic result) {
    // Handle both older/newer versions of connectivity_plus where the
    // callback might provide a single ConnectivityResult or a list of
    // ConnectivityResult entries. Normalize to a boolean.
    bool newState;
    if (result is List<ConnectivityResult>) {
      newState = result.any((r) => r != ConnectivityResult.none);
    } else if (result is ConnectivityResult) {
      newState = result != ConnectivityResult.none;
    } else {
      // Unknown payload; don't change current state
      return;
    }

    if (newState != _isConnected) {
      _isConnected = newState;
      _showOfflineBanner = !_isConnected;
      notifyListeners();

      // Auto-hide banner after 3 seconds if reconnected
      if (_isConnected) {
        Future.delayed(const Duration(seconds: 3), () {
          _showOfflineBanner = false;
          notifyListeners();
        });
      }
    }
  }

  void hideBanner() {
    _showOfflineBanner = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
