import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/services/enteries_service.dart';

class EntriesProvider with ChangeNotifier {
  bool _entriesloading = false;
  bool get entriesloading => _entriesloading;

  Future<StatusResponse> postEnteries(
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
    _entriesloading = true;
    notifyListeners();
    try {
      final response = await EnteriesService.addenteries(
        idA,
        startTime: startTime,
        endTime: endTime,
        status: status,
        jobId: jobId,
        description: description,
        shipNum: shipNum,
        location: location,
        driv: driv,
        holiday: holiday,
        localSite: localSite,
        offStation: offStation,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(
          status: 'success',
          message: "Task created successfully",
        );
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(
          status: 'failure',
          message: jsonDecode(response.body)['error'],
        );
      }
    } catch (e) {
      return StatusResponse(status: 'exception', message: "Network error");
    } finally {
      _entriesloading = false;
      notifyListeners();
    }
  }

  bool _applyleaveloading = false;
  bool get applyleaveloading => _applyleaveloading;

  Future<StatusResponse> applyleave({
    required String status,
    required String leaveType,
    required String leaveReason,
  }) async {
    _applyleaveloading = true;
    notifyListeners();
    try {
      final response = await EnteriesService.applyleave(
        leaveReason: leaveReason,
        leaveType: leaveType,
        status: status,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(
          status: 'success',
          message: 'leave applied successfully',
        );
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(
          status: 'failure',
          message: jsonDecode(response.body)['error'],
        );
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'Network error');
    } finally {
      _applyleaveloading = false;
      notifyListeners();
    }
  }

  void clearAllData() {
    _entriesloading = false;
    _applyleaveloading = false;

    notifyListeners();
  }
}
