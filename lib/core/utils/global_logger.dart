import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:hellenic_shipping_services/core/utils/logger_service.dart';

enum GlobalLogLevel { debug, info, warning, error, fatal }

class GlobalLogger {
  static final GlobalLogger _instance = GlobalLogger._internal();
  final List<Map<String, dynamic>> _logQueue = [];
  bool _initialized = false;
  bool _isWriting = false;

  factory GlobalLogger() {
    return _instance;
  }

  GlobalLogger._internal();

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      _printToConsole('🚀 Initializing GlobalLogger...', GlobalLogLevel.info);
      _initialized = true;

      // Flush any queued logs immediately
      _flushQueue();

      _printToConsole('✅ GlobalLogger initialized', GlobalLogLevel.info);
    } catch (e) {
      _printToConsole(
        '❌ Error initializing GlobalLogger: $e',
        GlobalLogLevel.error,
      );
    }
  }

  Future<void> _flushQueue() async {
    if (_isWriting) return;
    _isWriting = true;

    try {
      while (_logQueue.isNotEmpty) {
        final entry = _logQueue.removeAt(0);
        await Future.delayed(
          const Duration(milliseconds: 10),
        ); // Small delay for file I/O
        await _writeSingleLog(entry);
      }
    } finally {
      _isWriting = false;
    }
  }

  void _log(
    String message,
    GlobalLogLevel level, {
    String? stackTrace,
    String? category,
  }) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'category': category ?? level.toString().split('.').last,
      'action': message,
      if (stackTrace != null) 'stackTrace': stackTrace,
    };

    // Print to console immediately
    _printToConsole(message, level);

    // Queue for file storage
    _logQueue.add(logEntry);

    // Try to write immediately if initialized
    if (_initialized && !_isWriting) {
      _writeSingleLog(logEntry).catchError((e) {
        _printToConsole('Failed to write log: $e', GlobalLogLevel.error);
      });
    }
  }

  Future<void> _writeSingleLog(Map<String, dynamic> entry) async {
    try {
      final jsonStr = jsonEncode(entry);
      await LoggerService.logger(jsonStr);
    } catch (e) {
      _printToConsole('Error writing log to file: $e', GlobalLogLevel.error);
    }
  }

  void _printToConsole(String message, GlobalLogLevel level) {
    final prefix = _getLevelPrefix(level);
    final time = DateTime.now()
        .toIso8601String()
        .split('T')
        .last
        .split('.')
        .first;
    debugPrint('$prefix [$time] $message');
  }

  String _getLevelPrefix(GlobalLogLevel level) {
    switch (level) {
      case GlobalLogLevel.debug:
        return '🔍';
      case GlobalLogLevel.info:
        return 'ℹ️';
      case GlobalLogLevel.warning:
        return '⚠️';
      case GlobalLogLevel.error:
        return '❌';
      case GlobalLogLevel.fatal:
        return '🔴';
    }
  }

  // Public logging methods
  void debug(String message, {String? stackTrace}) =>
      _log(message, GlobalLogLevel.debug, stackTrace: stackTrace);

  void info(String message, {String? stackTrace}) =>
      _log(message, GlobalLogLevel.info, stackTrace: stackTrace);

  void warning(String message, {String? stackTrace}) =>
      _log(message, GlobalLogLevel.warning, stackTrace: stackTrace);

  void error(String message, {String? stackTrace}) =>
      _log(message, GlobalLogLevel.error, stackTrace: stackTrace);

  void fatal(String message, {String? stackTrace}) =>
      _log(message, GlobalLogLevel.fatal, stackTrace: stackTrace);

  // Alias for convenience
  void log(String message, GlobalLogLevel level, {String? stackTrace}) =>
      _log(message, level, stackTrace: stackTrace);
}

final gLogger = GlobalLogger();
