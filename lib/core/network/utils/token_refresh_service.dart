import 'dart:async';
import 'package:synchronized/synchronized.dart';

class TokenRefreshService {
  static final TokenRefreshService _instance = TokenRefreshService._internal();
  factory TokenRefreshService() => _instance;
  TokenRefreshService._internal();
  final _lock = Lock();
  Future<String?> refreshToken() async {
    return _lock.synchronized(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    });
  }
}
