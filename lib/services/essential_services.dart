import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/uri_manager.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:http/http.dart' as http;

class EssentialServices {
  static ApiService service = ApiService();

  static Future<http.Response> getleaveBalance() async {
    final response = await service.get(UriManager.leavebalance, withAuth: true);
    debugPrint(response.body);
    return response;
  }

  static Future<http.Response> gettaskHistory() async {
    final response = await service.get(UriManager.taskhistory, withAuth: true);
    debugPrint(response.body);
    return response;
  }

  static Future<http.Response> edittaskHistory(
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
  }) async {
    final response = await service.put(
      "${UriManager.workentries}$id/",
      withAuth: true,
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
    );
    debugPrint(response.body);
    return response;
  }

  static Future<http.Response> deletetaskHistory(String id) async {
    final response = await service.delete(
      "${UriManager.workentries}$id/",
      withAuth: true,
    );
    debugPrint(response.body);
    return response;
  }
}
