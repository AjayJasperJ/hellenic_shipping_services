import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/services/enteries_service.dart';

class EntriesProvider with ChangeNotifier {
  bool _entriesloading = false;
  bool get entriesloading => _entriesloading;

  Future<StatusResponse> postEnteries({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String status,
    required String jobId,
    required String description,
    required String shipNum,
    required String location,
  }) async {
    _entriesloading = true;
    notifyListeners();
    try {
      final response = await EnteriesService.addenteries(
        startTime: startTime,
        endTime: endTime,
        status: status,
        jobId: jobId,
        description: description,
        shipNum: shipNum,
        location: location,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(
          status: 'success',
          message: "successfully onduty registered",
        );
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(status: 'failure', message: response.body);
      }
    } catch (e) {
      return StatusResponse(status: 'exception', message: "app error");
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
          message: 'successfully applied',
        );
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(status: 'failed', message: response.body);
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'app failed');
    } finally {
      _applyleaveloading = false;
      notifyListeners();
    }
  }
}
