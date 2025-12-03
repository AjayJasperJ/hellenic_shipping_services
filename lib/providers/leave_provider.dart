import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/leave_model.dart';
import 'package:hellenic_shipping_services/services/essential_services.dart';

class LeaveProvider with ChangeNotifier {
  bool _leavelistloading = false;
  bool get leavelistloading => _leavelistloading;

  LeaveResponse? _listleavetype;
  LeaveResponse? get listleavetype => _listleavetype;

  Future<StatusResponse> getleavelist() async {
    _leavelistloading = true;
    notifyListeners();
    try {
      final response = await EssentialServices.getleaveBalance();
      if (response.statusCode == 200 || response.statusCode == 201) {
        _listleavetype = LeaveResponse.fromEncodedJson(response.body);
        return StatusResponse(
          status: 'success',
          message: 'data retrived successfully',
        );
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(status: 'failed', message: response.body);
      }
    } catch (e) {
      return StatusResponse(status: 'exception', message: 'app failed');
    } finally {
      _leavelistloading = false;
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
    _leavelistloading = false;
    _listleavetype = null;
    _leaveItem = null;

    notifyListeners();
  }
}
