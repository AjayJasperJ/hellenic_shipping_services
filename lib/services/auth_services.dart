import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_client.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_error.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_response.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/redesigned_model/login_model.dart';
import 'package:hellenic_shipping_services/redesigned_model/profile_model.dart';
import 'package:hellenic_shipping_services/redesigned_model/refresh_model.dart';

class AuthServices {
  static ApiClient client = ApiClient();

  static Future<ApiResult<LoginResponse>> login({
    required String identifier,
    required String password,
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.post(
      UriManager.login,
      body: {'username': identifier, 'password': password},
      isOfflineSync: false,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          final data = LoginResponse.fromJson(res.data);
          return ApiResult.success(data);
        } catch (e) {
          return ApiResult.failure(
            ApiError(
              message: "Data parsing failed",
              type: ApiErrorType.parsing,
            ),
          );
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  static Future<ApiResult<ProfileResponse>> profile({
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.get(
      UriManager.profile,
      cancelToken: cancelToken,
      withAuth: true,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          final data = ProfileResponse.fromJson(jsonDecode(res.data));
          return ApiResult.success(data);
        } catch (e) {
          return ApiResult.failure(
            ApiError(
              message: "Data parsing failed",
              type: ApiErrorType.parsing,
            ),
          );
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  static Future<ApiResult<AttendanceLoginResponse>> attendance({
    required TimeOfDay loginTime,
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.post(
      UriManager.attendance,
      body: {'selected_time': Helper.formatTime(loginTime)},
      isOfflineSync: false,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          final data = AttendanceLoginResponse.fromJson(res.data);
          return ApiResult.success(data);
        } catch (e) {
          return ApiResult.failure(
            ApiError(
              message: "Data parsing failed",
              type: ApiErrorType.parsing,
            ),
          );
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  static Future<ApiResult<RefreshResponse>> refresh({
    required String refreshToken,
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.post(
      UriManager.refresh,
      body: {'refresh': refreshToken},
      isOfflineSync: true,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          final data = RefreshResponse.fromJson(res.data);
          return ApiResult.success(data);
        } catch (e) {
          return ApiResult.failure(
            ApiError(
              message: "Data parsing failed",
              type: ApiErrorType.parsing,
            ),
          );
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }

  static Future<ApiResult<LogoutResponse>> logout({
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.post(
      UriManager.logout,
      isOfflineSync: false,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          final data = LogoutResponse.fromJson(res.data);
          return ApiResult.success(data);
        } catch (e) {
          return ApiResult.failure(
            ApiError(
              message: "Data parsing failed",
              type: ApiErrorType.parsing,
            ),
          );
        }
      },
      failure: (error) => ApiResult.failure(error),
    );
  }
}
