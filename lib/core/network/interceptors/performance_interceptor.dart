import 'package:dio/dio.dart';
import 'package:hellenic_shipping_services/core/network/utils/logger_services.dart';

class PerformanceInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now().millisecondsSinceEpoch;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _checkPerformance(response.requestOptions, response.statusCode);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _checkPerformance(err.requestOptions, err.response?.statusCode);
    super.onError(err, handler);
  }

  void _checkPerformance(RequestOptions options, int? statusCode) {
    final startTime = options.extra['startTime'] as int?;
    if (startTime == null) return;

    final duration = DateTime.now().millisecondsSinceEpoch - startTime;
    final path = options.uri.toString();

    // Threshold: 2 seconds
    if (duration > 2000) {
      LoggerService.log(
        level: LogLevel.warning,
        category: 'performance',
        message: 'Slow API detected: $path',
        details: {
          'duration_ms': duration,
          'method': options.method,
          'status': statusCode,
          'suggestion': 'Check internet connection or server status',
        },
      );

      // Note: To show a UI toast here, we would need a global BuildContext or similar.
      // For now, it is logged as a warning which appears in the Logger Screen.
    }
  }
}
