import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _keyToken = 'key_token';
  static const _keyRefresh = 'key_Refresh';

  /// Save JWT token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<void> saveRefresh(String token) async {
    await _storage.write(key: _keyRefresh, value: token);
  }

  /// Get JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<String?> getRefresh() async {
    return await _storage.read(key: _keyRefresh);
  }

  static Future<void> deleteRefresh() async {
    await _storage.delete(key: _keyRefresh);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  static Future<void> savedata(String data, String key) async {
    await _storage.write(key: key, value: data);
  }

  static Future<String?> getdata(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deletedata(String key) async {
    await _storage.delete(key: key);
  }
}
