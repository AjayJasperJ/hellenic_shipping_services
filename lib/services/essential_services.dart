import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_client.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_error.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_response.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/redesigned_model/leave_model.dart';
import 'package:hellenic_shipping_services/redesigned_model/tasklist_model.dart';

class EssentialServices {
  static ApiClient client = ApiClient();

  static Future<ApiResult<LeaveResponse>> getleaveBalance({
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.get(
      UriManager.leavebalance,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          return ApiResult.success(
            LeaveResponse.fromJson(jsonDecode(res.data)),
          );
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

  static Future<ApiResult<List<DutyItem>>> gettaskHistory({
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.get(
      UriManager.taskhistory,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          return ApiResult.success(DutyItem.listFromJson(jsonDecode(res.data)));
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

  static Future<ApiResult<dynamic>> edittaskHistory(
    String id,
    bool idA, {
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String status,
    required String? jobId,
    required String description,
    required String? shipNum,
    required String? location,
    required String holiday,
    required String offStation,
    required String localSite,
    required String driv,
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.put(
      "${UriManager.workentries}$id/",
      body: {
        "status": status,
        "description": description,
        "start_time": Helper.formatTime(startTime),
        "end_time": Helper.formatTime(endTime),
        if (idA && jobId != null) "job_no": jobId,
        if (idA && shipNum != null) "ship_name": shipNum,
        if (idA && location != null) "location": location,
        'holiday_worked': holiday,
        'off_station': offStation,
        'local_site': localSite,
        'driv': driv,
      },
      isOfflineSync: false,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          ApiClient.authguard(res.statusCode);
          return ApiResult.success(res.data);
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

  static Future<ApiResult<dynamic>> deletetaskHistory(
    String id, {
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.delete(
      "${UriManager.workentries}$id/",
      cancelToken: cancelToken,
      isOfflineSync: false,
      withAuth: false,
    );
    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          ApiClient.authguard(res.statusCode);
          return ApiResult.success(res.data);
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
