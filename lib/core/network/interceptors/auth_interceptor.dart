import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_client.dart';
import 'package:hellenic_shipping_services/services/auth_services.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool withAuth = options.extra['withAuth'] ?? true;

    if (withAuth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        debugPrint("[AuthInterceptor] 401 Detected. Attempting refresh...");
        final refreshToken = await TokenStorage.getRefresh();
        if (refreshToken != null) {
          final result = await AuthServices.refresh(refreshToken: refreshToken);

          return await result.when(
            success: (response) async {
              final newToken = response.access;
              await TokenStorage.saveToken(newToken);

              final options = err.requestOptions;
              options.headers['Authorization'] = 'Bearer $newToken';

              final retryResponse = await dio.request(
                options.path,
                data: options.data,
                queryParameters: options.queryParameters,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                  responseType: options.responseType,
                  contentType: options.contentType,
                  extra: options.extra,
                ),
              );

              return handler.resolve(retryResponse);
            },
            failure: (_) async {
              await ApiClient.authguard(401);
              return handler.next(err);
            },
          );
        } else {
          await ApiClient.authguard(401);
          return handler.next(err);
        }
      } catch (e) {
        await ApiClient.authguard(401);
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
