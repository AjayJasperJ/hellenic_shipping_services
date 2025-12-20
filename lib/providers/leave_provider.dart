import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/redesigned_model/leave_model.dart';
import 'package:hellenic_shipping_services/services/essential_services.dart';

class LeaveProvider with ChangeNotifier {
  StateResponse _leaveListState = StateResponse.idle();
  StateResponse get leaveListState => _leaveListState;
  LeaveResponse? _listleavetype;
  LeaveResponse? get listleavetype => _listleavetype;

  Future<StateResponse> getleavelist() async {
    _leaveListState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await EssentialServices.getleaveBalance();
      return response.when(
        success: (data) {
          _listleavetype = data;
          _leaveListState = StateResponse.success(
            data,
            message: 'leave retrived successfully',
          );
          return _leaveListState;
        },
        failure: (error) {
          _leaveListState = StateResponse.failure(error);
          return _leaveListState;
        },
      );
    } catch (e) {
      _leaveListState = StateResponse.exception('Something went wrong');
      return _leaveListState;
    } finally {
      notifyListeners();
    }
  }

  LeaveItem? _leaveItem;
  LeaveItem? get leaveitem => _leaveItem;
  void updateleave(LeaveItem item) {
    _leaveItem = item;
    notifyListeners();
  }

  void clearAllData() {
    _leaveListState = StateResponse.idle();
    _listleavetype = null;
    _leaveItem = null;
    notifyListeners();
  }
}
