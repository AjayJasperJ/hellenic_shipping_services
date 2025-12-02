import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static ApiService service = ApiService();

  static Future<http.Response> login(String identifier, String password) async {
    final response = await service.post(
      UriManager.login,
      withAuth: false,
      json: false,
      body: {'username': identifier, 'password': password},
    );
    return response;
  }

  static Future<http.Response> attendance(TimeOfDay loginTime) async {
    final response = await service.post(
      UriManager.attendance,
      withAuth: true,
      json: false,
      body: {'selected_time': Helper.formatTime(loginTime)},
    );
    return response;
  }

  static Future<http.Response> refresh() async {
    final refreshToken = await TokenStorage.getRefresh();
    final response = await service.post(
      UriManager.refresh,
      body: {'refresh': refreshToken ?? ''},
    );
    return response;
  }
}
