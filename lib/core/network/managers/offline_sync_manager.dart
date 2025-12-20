import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_client.dart';
import 'package:hellenic_shipping_services/core/network/utils/connectivity_service.dart';

class OfflineSyncManager {
  static final OfflineSyncManager _instance = OfflineSyncManager._internal();
  factory OfflineSyncManager() => _instance;

  late final ApiClient _apiClient;
  StreamSubscription? _connectivitySubscription;

  OfflineSyncManager._internal() {
    _apiClient = ApiClient();
  }

  void init() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = ConnectivityService().connectionChange.listen((isConnected) {
      if (isConnected) {
        if (kDebugMode) print('[SYNC MANAGER] Connection restored. Triggering sync...');
        _apiClient.syncOfflineData();
      }
    });

    if (ConnectivityService().hasConnection) {
      _apiClient.syncOfflineData();
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _apiClient.dispose();
  }
}
