import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:http/http.dart' as http;

class EnteriesService {
  static ApiService service = ApiService();

  static Future<http.Response> addenteries({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String status,
    required String jobId,
    required String description,
    required String shipNum,
    required String location,
  }) async {
    final response = await service.post(
      UriManager.workentries,
      withAuth: true,
      json: false,

      body: {
        "status": status,
        "description": description,
        "start_time": Helper.formatTime(startTime),
        "end_time": Helper.formatTime(endTime),
        "job_no": jobId,
        "ship_name": shipNum,
        "location": location,
      },
    );
    return response;
  }

  static Future<http.Response> applyleave({
    required String status,
    required String leaveType,
    required String leaveReason,
  }) async {
    final response = await service.post(
      UriManager.workentries,
      withAuth: true,
      body: {
        "status": status,
        "leave_type": leaveType,
        "leave_reason": leaveReason,
      },
    );
    print(response.body);
    return response;
  }
}
