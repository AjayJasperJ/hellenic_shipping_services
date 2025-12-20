import 'package:dio/dio.dart';
import 'package:hellenic_shipping_services/core/network/utils/connectivity_service.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class CacheInterceptor extends Interceptor {
  final Box _cacheBox;

  CacheInterceptor(this._cacheBox);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Only cache GET requests
    if (options.method != 'GET') {
      return handler.next(options);
    }

    // If we have internet, proceed to network
    bool isOnline = ConnectivityService().hasConnection;
    if (isOnline) {
      return handler.next(options);
    }

    // If offline, check cache
    final key = options.uri.toString();
    final cachedData = _cacheBox.get(key);

    if (cachedData != null) {
      if (kDebugMode) {
        print('[CACHE] Serving offline data for: $key');
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
          statusMessage: 'OK (Cached)',
        ),
      );
    } else {
      // No cache and no internet
      return handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Network-first, fallback to cache strategy
    if (err.requestOptions.method == 'GET' && _isNetworkError(err)) {
      final key = err.requestOptions.uri.toString();
      final cachedData = _cacheBox.get(key);

      if (kDebugMode) {
        print('[CACHE DEBUG] Network Error Type: ${err.type}');
        print('[CACHE DEBUG] Error Message: ${err.message}');
        print('[CACHE DEBUG] Key: $key');
        print('[CACHE DEBUG] Cache Exists: ${cachedData != null}');
      }

      if (cachedData != null) {
        if (kDebugMode) {
          print('[CACHE] Network failed. Serving cached data for: $key');
        }

        // Hive often returns Map<dynamic, dynamic>, but Dio/Freezed expects Map<String, dynamic>
        final castData = _castToMapStringDynamic(cachedData);

        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            data: castData,
            statusCode: 200,
            statusMessage: 'OK (Cached Fallback)',
          ),
        );
      } else {
        if (kDebugMode) print('[CACHE] No cache found for $key');
      }
    } else {
      if (kDebugMode)
        print(
          '[CACHE DEBUG] Fallback skipped. Method: ${err.requestOptions.method}, IsNetworkError: ${_isNetworkError(err)}',
        );
    }
    super.onError(err, handler);
  }

  // Recursive casting helper
  dynamic _castToMapStringDynamic(dynamic data) {
    if (data is Map) {
      return data.map<String, dynamic>(
        (key, value) => MapEntry(key.toString(), _castToMapStringDynamic(value)),
      );
    } else if (data is List) {
      return data.map((e) => _castToMapStringDynamic(e)).toList();
    }
    return data;
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.unknown ||
        (err.error != null && err.error.toString().toLowerCase().contains('socket'));
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Save successful GET responses to cache
    if (response.requestOptions.method == 'GET' &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final key = response.requestOptions.uri.toString();
      _cacheBox.put(key, response.data);
    }
    super.onResponse(response, handler);
  }
}
