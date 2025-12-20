import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_error.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_response.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';

import '../interceptors/auth_interceptor.dart';
import '../interceptors/cache_interceptor.dart';
import '../interceptors/logger_interceptor.dart';
import '../interceptors/offline_sync_interceptor.dart';
import '../interceptors/performance_interceptor.dart';
import '../utils/connectivity_service.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl, Dio? dioOverride, Duration? timeout}) {
    _dio =
        dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: "https://api.yashellenic.com",
            connectTimeout: timeout ?? const Duration(seconds: 30),
            receiveTimeout: timeout ?? const Duration(seconds: 30),
            sendTimeout: timeout ?? const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

    Box? cacheBox;
    Box? queueBox;
    if (Hive.isBoxOpen('api_cache')) cacheBox = Hive.box('api_cache');
    if (Hive.isBoxOpen('offline_queue')) queueBox = Hive.box('offline_queue');
    _dio.interceptors.add(AuthInterceptor(dio: _dio));
    if (cacheBox != null) {
      _dio.interceptors.add(CacheInterceptor(cacheBox));
    }
    if (queueBox != null) {
      _dio.interceptors.add(
        OfflineSyncInterceptor(dio: _dio, queueBox: queueBox),
      );
    }
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: debugPrint,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
    _dio.interceptors.add(PerformanceInterceptor());
    _dio.interceptors.add(LoggerInterceptor());
    ConnectivityService().connectionChange.listen((hasConnection) async {
      if (hasConnection) {
        await Future.delayed(const Duration(seconds: 3));
        await syncOfflineData();
      }
    });
  }

  void addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  Future<ApiResult<Response>> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(headers: headers, extra: {'withAuth': withAuth}),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Unexpected error: $e", type: ApiErrorType.unknown),
      );
    }
  }

  Future<ApiResult<Response>> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: query,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: headers,
          extra: {'withAuth': withAuth},
          responseType: ResponseType.plain,
        ),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Unexpected error: $e", type: ApiErrorType.unknown),
      );
    }
  }

  Future<ApiResult<Response>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    bool isOfflineSync = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: headers,
          extra: {'withAuth': withAuth, 'isOfflineSync': isOfflineSync},
        ),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Unexpected error: $e", type: ApiErrorType.unknown),
      );
    }
  }

  Future<ApiResult<Response>> put(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    bool isOfflineSync = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: headers,
          extra: {'withAuth': withAuth, 'isOfflineSync': isOfflineSync},
        ),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Unexpected error: $e", type: ApiErrorType.unknown),
      );
    }
  }

  Future<ApiResult<Response>> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    bool isOfflineSync = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: body,
        queryParameters: query,
        cancelToken: cancelToken,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: headers,
          extra: {'withAuth': withAuth, 'isOfflineSync': isOfflineSync},
        ),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Unexpected error: $e", type: ApiErrorType.unknown),
      );
    }
  }

  Future<ApiResult<Response>> multipart(
    String path, {
    Map<String, String>? fields,
    Map<String, String>? filePaths,
    List<MultipartBytesFile>? files,
    Map<String, String>? headers,
    bool withAuth = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final formData = FormData();

      if (fields != null) {
        fields.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });
      }

      if (filePaths != null && !kIsWeb) {
        for (final entry in filePaths.entries) {
          formData.files.add(
            MapEntry(entry.key, await MultipartFile.fromFile(entry.value)),
          );
        }
      }

      if (files != null) {
        for (final f in files) {
          formData.files.add(
            MapEntry(
              f.field,
              MultipartFile.fromBytes(
                f.bytes,
                filename: f.filename,
                contentType: f.contentType,
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        path,
        data: formData,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: headers, extra: {'withAuth': withAuth}),
      );

      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(
        ApiError(message: "Unexpected error: $e", type: ApiErrorType.unknown),
      );
    }
  }

  // static String _normalizeBase(String base) {
  //   if (base.endsWith('/')) base = base.substring(0, base.length - 1);
  //   return base;
  // }

  static Future<void> authguard(
    int? statusCode, {
    bool forceLogout = false,
  }) async {
    if (forceLogout || statusCode == 401) {
      await TokenStorage.deleteToken();
    }
  }

  Future<void> syncOfflineData() async {
    for (final interceptor in _dio.interceptors) {
      if (interceptor is OfflineSyncInterceptor) {
        await interceptor.syncQueue();
      }
    }
  }

  void dispose() {
    _dio.close();
  }
}

class MultipartBytesFile {
  const MultipartBytesFile({
    required this.field,
    required this.bytes,
    required this.filename,
    this.contentType,
  });
  final String field;
  final List<int> bytes;
  final String filename;
  final MediaType? contentType;
}

class HttpRequestException implements Exception {
  HttpRequestException(this.message, {this.isNetwork = false});
  final String message;
  final bool isNetwork;
  @override
  String toString() => 'HttpRequestException($message)';
}
