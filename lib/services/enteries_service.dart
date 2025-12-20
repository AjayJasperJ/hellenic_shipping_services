import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_client.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_error.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_response.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';

class EnteriesService {
  static ApiClient client = ApiClient();

  static Future<ApiResult<dynamic>> addenteries(
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

    final result = await service.post(
      UriManager.workentries,
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

  static Future<ApiResult<dynamic>> applyleave({
    required String status,
    required String leaveType,
    required String leaveReason,
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.post(
      UriManager.workentries,
      body: {
        "status": status,
        "leave_type": leaveType,
        "leave_reason": leaveReason,
      },
      isOfflineSync: false,
      cancelToken: cancelToken,
      withAuth: false,
    );

    return result.when(
      success: (res) {
        try {
          ApiClient.authguard(res.statusCode);
          // final data = AttendanceLoginResponse.fromJson(res.data);
          ApiClient.authguard(res.statusCode);
          // final data = AttendanceLoginResponse.fromJson(res.data);
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

  static Future<ApiResult<dynamic>> applyAnnualLeave({
    required String leaveReason,
    required String startDate,
    required String endDate,
    CancelToken? cancelToken,
  }) async {
    final ApiClient service = ApiClient();

    final result = await service.post(
      UriManager.annualLeave,
      body: {
        "leave_type": 'annual',
        "start_date": startDate,
        "end_date": endDate,
        "reason": leaveReason,
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
}
