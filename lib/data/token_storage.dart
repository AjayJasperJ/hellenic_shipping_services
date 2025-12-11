import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hellenic_shipping_services/core/utils/logger_service.dart';
import 'package:flutter/foundation.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    iOptions: const IOSOptions(),
  );

  static const _keyToken = 'key_token';
  static const _keyRefresh = 'key_Refresh';

  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _keyToken, value: token);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.saveToken error: $e');
      await LoggerService.logError(
        'TokenStorage.saveToken',
        error: e,
        stackTrace: s,
      );
    }
  }

  static Future<void> saveRefresh(String token) async {
    try {
      await _storage.write(key: _keyRefresh, value: token);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.saveRefresh error: $e');
      await LoggerService.logError(
        'TokenStorage.saveRefresh',
        error: e,
        stackTrace: s,
      );
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _keyToken);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.getToken error: $e');
      await LoggerService.logError(
        'TokenStorage.getToken',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  static Future<String?> getRefresh() async {
    try {
      return await _storage.read(key: _keyRefresh);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.getRefresh error: $e');
      await LoggerService.logError(
        'TokenStorage.getRefresh',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  static Future<void> deleteRefresh() async {
    try {
      await _storage.delete(key: _keyRefresh);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.deleteRefresh error: $e');
      await LoggerService.logError(
        'TokenStorage.deleteRefresh',
        error: e,
        stackTrace: s,
      );
    }
  }

  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _keyToken);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.deleteToken error: $e');
      await LoggerService.logError(
        'TokenStorage.deleteToken',
        error: e,
        stackTrace: s,
      );
    }
  }

  static Future<void> savedata(String data, String key) async {
    try {
      await _storage.write(key: key, value: data);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.savedata error: $e');
      await LoggerService.logError(
        'TokenStorage.savedata',
        error: e,
        stackTrace: s,
      );
    }
  }

  static Future<String?> getdata(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.getdata error: $e');
      await LoggerService.logError(
        'TokenStorage.getdata',
        error: e,
        stackTrace: s,
      );
      return null;
    }
  }

  static Future<void> deletedata(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, s) {
      if (kDebugMode) debugPrint('TokenStorage.deletedata error: $e');
      await LoggerService.logError(
        'TokenStorage.deletedata',
        error: e,
        stackTrace: s,
      );
    }
  }
}
