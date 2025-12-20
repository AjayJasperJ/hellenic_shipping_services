import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/core/network/utils/connectivity_service.dart';

mixin AutoReconnectMixin on ChangeNotifier {
  StreamSubscription<bool>? _connectivitySubscription;
  void onReconnect();
  bool get shouldRetry => false;

  void initAutoReconnect() {
    _connectivitySubscription = ConnectivityService().connectionChange.listen((hasConnection) {
      if (hasConnection && shouldRetry) {
        onReconnect();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  bool regularRetry(States? state, CancelToken? cancelToken) {
    return (state == States.failure || state == States.exception) &&
        cancelToken?.isCancelled != true &&
        cancelToken != null;
  }

  void cancelTokenNow(CancelToken? cancelToken, String? message) {
    if (cancelToken?.isCancelled == true || cancelToken == null) {
      cancelToken?.cancel(message ?? "Request cancelled");
    }
  }
}
