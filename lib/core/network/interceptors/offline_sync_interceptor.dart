import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineSyncInterceptor extends Interceptor {
  final Dio dio;
  final Box _queueBox;
  bool _isSyncing = false;

  OfflineSyncInterceptor({required this.dio, required Box queueBox})
    : _queueBox = queueBox {
    if (kDebugMode) print('[SYNC] Created.');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final bool isOfflineSync =
        err.requestOptions.extra['isOfflineSync'] ?? true;
    final bool isSyncRequest =
        err.requestOptions.extra['isSyncRequest'] ?? false;

    // Prevent recursive queueing: don't queue if it's already a sync request
    if (!isSyncRequest &&
        _isNetworkError(err) &&
        [
          'POST',
          'PUT',
          'DELETE',
          'PATCH',
        ].contains(err.requestOptions.method) &&
        isOfflineSync) {
      if (kDebugMode) {
        print(
          '[SYNC] Network error during mutation. Queuing request: ${err.requestOptions.uri}',
        );
      }

      await _queueRequest(err.requestOptions);

      return handler.resolve(
        Response(
          requestOptions: err.requestOptions,
          data: {'offline_queued': true, 'message': 'Request queued for sync'},
          statusCode: 200,
        ),
      );
    }
    super.onError(err, handler);
  }

  Future<void> _queueRequest(RequestOptions options) async {
    final task = {
      'path': options.path,
      'method': options.method,
      'data': options.data,
      'query': options.queryParameters,
      'headers': options.headers,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final exists = _queueBox.values.any((existing) {
      if (existing is! Map) return false;
      return existing['path'] == task['path'] &&
          existing['method'] == task['method'] &&
          existing['data'].toString() == task['data'].toString() &&
          existing['query'].toString() == task['query'].toString();
    });

    if (!exists) {
      if (kDebugMode) {
        print('[SYNC] Queuing offline processed request: ${options.path}');
      }
      await _queueBox.add(task);
    } else {
      if (kDebugMode) {
        print('[SYNC] Duplicate request ignored: ${options.path}');
      }
    }
  }

  bool _isNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        (err.error.toString().toLowerCase().contains('socket'));
  }

  Future<void> syncQueue() async {
    if (_isSyncing || _queueBox.isEmpty) return;
    _isSyncing = true;

    if (kDebugMode) {
      print('[SYNC] Starting sync of ${_queueBox.length} items...');
    }

    final keys = _queueBox.keys.toList();

    for (final key in keys) {
      final task = _queueBox.get(key);
      if (task == null) continue;

      try {
        if (kDebugMode) {
          print('[SYNC] Processing ${task['method']} ${task['path']}');
        }

        await dio.request(
          task['path'],
          data: task['data'],
          queryParameters: Map<String, dynamic>.from(task['query'] ?? {}),
          options: Options(
            method: task['method'],
            headers: Map<String, dynamic>.from(task['headers'] ?? {}),
            extra: {'isSyncRequest': true},
          ),
        );

        await _queueBox.delete(key);
      } catch (e) {
        if (kDebugMode) print('[SYNC] Failed to sync item $key: $e');
        if (e is DioException && e.response != null) {
          final code = e.response!.statusCode ?? 0;
          if (code >= 400 && code < 500 && code != 408 && code != 429) {
            await _queueBox.delete(key);
          }
        }
      }
    }

    _isSyncing = false;
    if (kDebugMode) print('[SYNC] Sync completed.');
  }

  Future<void> clearQueue() async {
    await _queueBox.clear();
    if (kDebugMode) {
      print('[SYNC] Queue cleared.');
    }
  }

  static Future<void> reset() async {
    if (Hive.isBoxOpen('offline_queue')) {
      await Hive.box('offline_queue').clear();
      if (kDebugMode) {
        print('[SYNC] Global queue reset.');
      }
    }
  }
}
