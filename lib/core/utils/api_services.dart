import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/credential_storage_service.dart';
import 'package:hellenic_shipping_services/core/utils/internet_service.dart';
import 'package:hellenic_shipping_services/core/utils/logger_service.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/screens/widget/other_widgets.dart';
import 'package:hellenic_shipping_services/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ApiService {
  ApiService({String? baseUrl, http.Client? client, Duration? timeout})
    : _baseUrl = _normalizeBase(baseUrl ?? 'https://api.yashellenic.com'),
      _client = client ?? http.Client(),
      _timeout = timeout ?? const Duration(seconds: 20);

  final String _baseUrl;
  String get baseUrl => _baseUrl;
  final http.Client _client;
  final Duration _timeout;
  Future<Map<String, String>> Function()? customAuthHeaderBuilder;

  Uri buildUri(String path, {Map<String, dynamic>? query}) {
    final isAbsolute =
        path.startsWith('http://') || path.startsWith('https://');
    final base = isAbsolute
        ? path
        : '$_baseUrl${path.startsWith('/') ? '' : '/'}$path';
    final uri = Uri.parse(base);
    if (query == null || query.isEmpty) return uri;

    final sanitized = <String, String>{};
    query.forEach((key, value) {
      if (value == null) return;
      if (value is Iterable) {
        sanitized[key] = value
            .where((e) => e != null)
            .map((e) => e.toString())
            .join(',');
      } else {
        sanitized[key] = value.toString();
      }
    });
    return uri.replace(queryParameters: {...uri.queryParameters, ...sanitized});
  }

  Future<Map<String, String>> getHeaders({
    Map<String, String>? extra,
    bool withAuth = true,
    bool json = true,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (json) 'Content-Type': 'application/json',
    };
    if (withAuth) {
      final auth = await _authHeaders();
      headers.addAll(auth);
    }
    if (customAuthHeaderBuilder != null) {
      final custom = await customAuthHeaderBuilder!.call();
      headers.addAll(custom);
    }
    if (extra != null && extra.isNotEmpty) headers.addAll(extra);
    return headers;
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
  }) async {
    final uri = buildUri(path, query: query);
    final allHeaders = await getHeaders(
      extra: headers,
      withAuth: withAuth,
      json: false,
    );
    final started = DateTime.now();
    try {
      final res = await _client.get(uri, headers: allHeaders).timeout(_timeout);

      await _log('GET', uri, started, res, request: null);
      return res;
    } catch (e) {
      await _handleError('GET', uri, started, e);
    }
  }

  Future<http.Response> post(
    String path, {
    Map<String, String>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    bool json = true,
  }) async {
    final uri = buildUri(path, query: query);
    final allHeaders = await getHeaders(
      extra: headers,
      withAuth: withAuth,
      json: json,
    );
    final started = DateTime.now();
    final payload = json ? _encodeJsonIfNeeded(body) : body;
    try {
      final res = await _client
          .post(uri, headers: allHeaders, body: payload)
          .timeout(_timeout);
      await _log('POST', uri, started, res, request: payload);
      return res;
    } catch (e) {
      await _handleError('POST', uri, started, e);
    }
  }

  Future<http.Response> put(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
    bool json = true,
  }) async {
    final uri = buildUri(path, query: query);
    final allHeaders = await getHeaders(
      extra: headers,
      withAuth: withAuth,
      json: json,
    );
    final started = DateTime.now();
    final payload = json ? _encodeJsonIfNeeded(body) : body;
    try {
      final res = await _client
          .put(uri, headers: allHeaders, body: payload)
          .timeout(_timeout);
      await _log('PUT', uri, started, res, request: payload);
      return res;
    } catch (e) {
      await _handleError('PUT', uri, started, e);
    }
  }

  Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    bool withAuth = true,
  }) async {
    final uri = buildUri(path, query: query);
    final allHeaders = await getHeaders(extra: headers, withAuth: withAuth);
    final started = DateTime.now();
    try {
      final res = await _client
          .delete(uri, headers: allHeaders)
          .timeout(_timeout);
      await _log('DELETE', uri, started, res, request: null);
      return res;
    } catch (e) {
      await _handleError('DELETE', uri, started, e);
    }
  }

  Future<http.Response> multipart(
    String path, {
    Map<String, String>? fields,
    Map<String, String>? headers,
    Map<String, String>? filePaths, // fieldName -> filePath
    List<MultipartBytesFile>? files, // for web or custom bytes
    bool withAuth = true,
  }) async {
    final uri = buildUri(path);
    // For multipart, do not set Content-Type manually; the request sets it.
    final baseHeaders = await getHeaders(
      extra: headers,
      withAuth: withAuth,
      json: false,
    );

    final req = http.MultipartRequest('POST', uri);
    req.headers.addAll(baseHeaders);
    if (fields != null) req.fields.addAll(fields);

    if (filePaths != null && filePaths.isNotEmpty && !kIsWeb) {
      for (final entry in filePaths.entries) {
        final field = entry.key;
        final path = entry.value;
        // contentType optional; let http guess from path
        req.files.add(await http.MultipartFile.fromPath(field, path));
      }
    }

    if (files != null && files.isNotEmpty) {
      for (final f in files) {
        req.files.add(
          http.MultipartFile.fromBytes(
            f.field,
            f.bytes,
            filename: f.filename,
            contentType: f.contentType,
          ),
        );
      }
    }

    final started = DateTime.now();
    try {
      final streamed = await req.send().timeout(_timeout);
      final res = await http.Response.fromStream(streamed);
      await _log(
        'MULTIPART',
        uri,
        started,
        res,
        request: {
          'fields': fields,
          'fileCount': (filePaths?.length ?? 0) + (files?.length ?? 0),
        },
      );
      return res;
    } catch (e) {
      await _handleError('MULTIPART', uri, started, e);
    }
  }

  static String _normalizeBase(String base) {
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    return base;
  }

  Future<Map<String, String>> _authHeaders() async {
    try {
      final creds = await TokenStorage.getToken();
      if (creds == null || creds.isEmpty) return const {};
      final token = creds.trim();
      return <String, String>{'Authorization': 'Bearer $token'};
    } catch (_) {
      return const {};
    }
  }

  Object? _encodeJsonIfNeeded(Object? body) {
    if (body == null) return null;
    if (body is String) return body; // assume already JSON
    return jsonEncode(body);
  }

  Future<void> _log(
    String method,
    Uri uri,
    DateTime started,
    http.Response res, {
    Object? request,
  }) async {
    final durationMs = DateTime.now().difference(started).inMilliseconds;
    if (kDebugMode) {
      // Quick console hint in debug builds
      // ignore: avoid_print
      print(
        '[API] $method ${res.statusCode} ${uri.toString()} (${durationMs}ms)',
      );
    }
    await LoggerService.logApi(
      '$method ${uri.path}',
      success: res.statusCode >= 200 && res.statusCode < 300,
    );
  }

  Future<void> _logError(
    String method,
    Uri uri,
    DateTime started,
    Object error,
  ) async {
    final durationMs = DateTime.now().difference(started).inMilliseconds;
    if (kDebugMode) {
      // ignore: avoid_print
      print(
        '[API] $method ERROR ${uri.toString()} (${durationMs}ms) -> $error',
      );
    }
    await LoggerService.logApi('$method ${uri.path}', success: false);
  }

  Future<Never> _handleError(
    String method,
    Uri uri,
    DateTime started,
    Object error,
  ) async {
    await _logError(method, uri, started, error);
    if (_isNetworkOrTimeout(error)) {
      throw HttpRequestException('Network or timeout error', isNetwork: true);
    }
    // Default fallback for any other unexpected error
    throw HttpRequestException('Something went wrong');
  }

  bool _isNetworkOrTimeout(Object error) {
    return error is SocketException ||
        error is TimeoutException ||
        error is http.ClientException ||
        error is HandshakeException;
  }

  Future authguard(int successcode) async {
    if (successcode == 401) {
      final response = await AuthServices.refresh();
      TokenStorage.saveToken(jsonDecode(response.body)['access']);
    }
  }

  static void apiServiceStatus(
    BuildContext context,
    StatusResponse response,
    void Function(String)? todo, {
    bool disableSuccessToast = false,
    bool disableFailureToast = false,
    bool disableExceptionToast = false,
  }) {
    final connectivityProvider = Provider.of<InternetService>(
      context,
      listen: false,
    );
    switch (response.status) {
      case 'success':
        if (!disableSuccessToast) {
          ToastManager.showSingle(
            context,
            title: response.message,
            textcolor: Theme.of(context).colorScheme.onSurface,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
          );
        }
        if (todo != null) todo(response.status);
        break;
      case 'failure':
        if (!disableFailureToast) {
          ToastManager.showSingle(
            context,
            title: response.message,
            textcolor: Theme.of(context).colorScheme.onSurface,
            type: ToastificationType.warning,
            style: ToastificationStyle.flat,
          );
        }
        if (todo != null) todo(response.status);
        break;
      case 'exception':
        if (!disableExceptionToast) {
          if (!connectivityProvider.isConnected) {
            ToastManager.showSingle(
              context,
              title: 'No Internet Connection',
              textcolor: Theme.of(context).colorScheme.onSurface,
              type: ToastificationType.error,
              style: ToastificationStyle.flat,
            );
            if (todo != null) todo(response.status);
          } else {
            ToastManager.showSingle(
              context,
              title: response.message,
              textcolor: Theme.of(context).colorScheme.onSurface,
              type: ToastificationType.error,
              style: ToastificationStyle.flat,
            );
            if (todo != null) todo(response.status);
          }
        }
        break;
      default:
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  ApiException({required this.statusCode, this.message, this.body});
  final int statusCode;
  final String? message;
  final String? body;
  @override
  String toString() {
    final msg = message ?? 'HTTP $statusCode';
    return 'ApiException($msg)';
  }
}

class StatusResponse {
  String status;
  String message;
  StatusResponse({required this.status, required this.message});
  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
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
