import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/core/network/managers/auto_reconnect_mixin.dart';
import 'package:hellenic_shipping_services/redesigned_model/leave_model.dart';
import 'package:hellenic_shipping_services/services/essential_services.dart';

class LeaveProvider with ChangeNotifier, AutoReconnectMixin {
  CancelToken? _cancelToken;
  LeaveProvider() {
    initAutoReconnect();
  }
  StateResponse _leaveListState = StateResponse.idle();
  StateResponse get leaveListState => _leaveListState;
  LeaveResponse? _listleavetype;
  LeaveResponse? get listleavetype => _listleavetype;

  Future<StateResponse> getleavelist() async {
    cancelTokenNow(_cancelToken, 'cancel due to new request');
    _cancelToken = CancelToken();
    _leaveListState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await EssentialServices.getleaveBalance(
        cancelToken: _cancelToken,
      );
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

  @override
  void dispose() {
    cancelTokenNow(_cancelToken, 'cancel due to dispose');
    super.dispose();
  }

  void disposeCancelToken() {
    cancelTokenNow(_cancelToken, 'cancel due to navigation');
  }

  @override
  bool get shouldRetry => regularRetry(_leaveListState.state, _cancelToken);

  @override
  onReconnect() {
    getleavelist();
  }
}
