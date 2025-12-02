import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  static File? _logFile;
  static Function(String, dynamic)? _errorCallback;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _logFile = File("${dir.path}/api_log.txt");

    if (!await _logFile!.exists()) {
      await _logFile!.create(recursive: true);
    }
  }

  /// Set a callback to handle errors globally (e.g., to update logger provider)
  static void setErrorCallback(Function(String, dynamic) callback) {
    _errorCallback = callback;
  }

  static Future<void> logger(String message) async {
    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'category': 'legacy',
      'action': message,
    };

    await _writeLine(jsonEncode(entry));
  }

  static Future<void> logEvent({
    required String category,
    required String action,
    Map<String, dynamic>? details,
  }) async {
    final entry = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'category': category,
      'action': action,
      if (details != null && details.isNotEmpty) 'details': details,
    };

    await _writeLine(jsonEncode(entry));
  }

  static Future<void> logUi(
    String action, {
    Map<String, dynamic>? details,
  }) async {
    await logEvent(category: 'ui', action: action, details: details);
  }

  static Future<void> logApi(String message, {required bool success}) async {
    // Implement your logging logic here, e.g. print or send to a logging backend
    debugPrint('[API LOG] $message | success: $success');

    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'category': 'api',
      'action': message,
      'success': success,
    };

    await _writeLine(jsonEncode(entry));
  }

  static Future<void> logError(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) async {
    final errorMessage =
        '''
Error: $message
Details: $error
${stackTrace != null ? 'Stack: $stackTrace' : ''}
''';

    debugPrint('❌ [ERROR] $errorMessage');

    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'category': 'error',
      'action': message,
      'error': error?.toString() ?? 'Unknown error',
      'stackTrace': stackTrace?.toString() ?? '',
    };

    await _writeLine(jsonEncode(entry));

    // Trigger callback if set
    _errorCallback?.call(message, error);
  }

  static Future<void> _writeLine(String line) async {
    if (_logFile != null) {
      await _logFile!.writeAsString('$line\n', mode: FileMode.append);
    }
  }

  static Future<void> clearLogs() async {
    if (_logFile != null && await _logFile!.exists()) {
      await _logFile!.writeAsString("");
    }
  }

  static Future<String> getLogPath() async {
    return _logFile?.path ?? "Log file not initialized";
  }

  static Future<String> readLogs() async {
    if (_logFile != null && await _logFile!.exists()) {
      return await _logFile!.readAsString();
    }
    return "";
  }
}
