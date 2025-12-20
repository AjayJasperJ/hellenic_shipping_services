import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/services/enteries_service.dart';

class EntriesProvider with ChangeNotifier {
  StateResponse _postEnteriesState = StateResponse.idle();
  StateResponse get postEnteriesState => _postEnteriesState;

  Future<StateResponse> postEnteries(
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
    _postEnteriesState = StateResponse.loading();
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

      return response.when(
        success: (res) {
          _postEnteriesState = StateResponse.success(
            null,
            message: "Task created successfully",
          );
          return _postEnteriesState;
        },
        failure: (error) {
          _postEnteriesState = StateResponse.failure(error);
          return _postEnteriesState;
        },
      );
    } catch (e) {
      _postEnteriesState = StateResponse.exception('Something went wrong');
      return _postEnteriesState;
    } finally {
      notifyListeners();
    }
  }

  StateResponse _applyLeaveState = StateResponse.idle();
  StateResponse get applyLeaveState => _applyLeaveState;

  Future<StateResponse> applyleave({
    required String status,
    required String leaveType,
    required String leaveReason,
  }) async {
    _applyLeaveState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await EnteriesService.applyleave(
        leaveReason: leaveReason,
        leaveType: leaveType,
        status: status,
      );
      return response.when(
        success: (data) {
          _applyLeaveState = StateResponse.success(
            data,
            message: 'leave applied successfully',
          );
          return _applyLeaveState;
        },
        failure: (error) {
          _applyLeaveState = StateResponse.failure(error);
          return _applyLeaveState;
        },
      );
    } catch (_) {
      _applyLeaveState = StateResponse.exception('Something went wrong');
      return _applyLeaveState;
    } finally {
      notifyListeners();
    }
  }

  StateResponse _applyAnnualLeaveState = StateResponse.idle();
  StateResponse get applyAnnualLeaveState => _applyAnnualLeaveState;

  Future<StateResponse> applyannualleave({
    required String endTime,
    required String startTime,
    required String leaveReason,
  }) async {
    _applyAnnualLeaveState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await EnteriesService.applyAnnualLeave(
        leaveReason: leaveReason,
        endDate: endTime,
        startDate: startTime,
      );
      return response.when(
        success: (data) {
          _applyAnnualLeaveState = StateResponse.success(
            data,
            message: 'leave applied successfully',
          );
          return _applyAnnualLeaveState;
        },
        failure: (error) {
          _applyAnnualLeaveState = StateResponse.failure(error);
          return _applyAnnualLeaveState;
        },
      );
    } catch (_) {
      _applyAnnualLeaveState = StateResponse.exception('Something went wrong');
      return _applyAnnualLeaveState;
    } finally {
      notifyListeners();
    }
  }

  void clearAllData() {
    _applyLeaveState = StateResponse.idle();
    _applyAnnualLeaveState = StateResponse.idle();
    notifyListeners();
  }
}
