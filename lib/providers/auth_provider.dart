import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/core/network/managers/auto_reconnect_mixin.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/redesigned_model/profile_model.dart';
import 'package:hellenic_shipping_services/services/auth_services.dart';

class AuthProvider with ChangeNotifier, AutoReconnectMixin {
  StateResponse _loginState = StateResponse.idle();
  StateResponse get loginState => _loginState;

  Future<StateResponse> loginuser({
    required String identifier,
    required String password,
  }) async {
    _loginState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await AuthServices.login(
        identifier: identifier,
        password: password,
      );
      return response.when(
        success: (data) {
          TokenStorage.saveToken(data.access);
          TokenStorage.saveRefresh(data.refresh);
          _loginState = StateResponse.success(
            data,
            message: 'login successful',
          );
          return _loginState;
        },
        failure: (error) {
          _loginState = StateResponse.failure(error);
          return _loginState;
        },
      );
    } catch (_) {
      _loginState = StateResponse.exception('Something went wrong');
      return _loginState;
    } finally {
      notifyListeners();
    }
  }

  StateResponse _attendanceState = StateResponse.idle();
  StateResponse get attendanceState => _attendanceState;

  Future<StateResponse> attendanceuser({required TimeOfDay time}) async {
    _attendanceState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await AuthServices.attendance(loginTime: time);
      return response.when(
        success: (data) {
          _attendanceState = StateResponse.success(
            data,
            message: 'Attendance logged successfully',
          );
          return _attendanceState;
        },
        failure: (error) {
          _attendanceState = StateResponse.failure(error);
          return _attendanceState;
        },
      );
    } catch (_) {
      _attendanceState = StateResponse.exception('Something went wrong');
      return _attendanceState;
    } finally {
      notifyListeners();
    }
  }

  ProfileResponse? _profileResponse;
  ProfileResponse? get profileResponse => _profileResponse;
  StateResponse _profileState = StateResponse.idle();
  StateResponse get profileState => _profileState;
  CancelToken? _cancelToken;

  Future<StateResponse> profile() async {
    cancelTokenNow(_cancelToken, 'cancel due to new request');
    _cancelToken = CancelToken();
    _profileState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await AuthServices.profile(cancelToken: _cancelToken);
      return response.when(
        success: (data) {
          _profileResponse = data;
          _profileState = StateResponse.success(
            data,
            message: 'Profile retrived successfully',
          );
          return _profileState;
        },
        failure: (error) {
          _profileState = StateResponse.failure(error);
          return _profileState;
        },
      );
    } catch (_) {
      _profileState = StateResponse.exception('Something went wrong');
      return _profileState;
    } finally {
      notifyListeners();
    }
  }

  StateResponse _logoutState = StateResponse.idle();
  StateResponse get logoutState => _logoutState;

  Future<StateResponse> logout() async {
    _logoutState = StateResponse.loading();
    notifyListeners();
    try {
      final result = await AuthServices.logout();
      return result.when(
        success: (data) {
          _logoutState = StateResponse.success(
            data,
            message: 'Successfully loggedOut',
          );
          return _logoutState;
        },
        failure: (error) {
          _logoutState = StateResponse.failure(error);
          return _logoutState;
        },
      );
    } catch (_) {
      _logoutState = StateResponse.exception('Something went wrong');
      return _logoutState;
    } finally {
      notifyListeners();
    }
  }

  void clearAllData() {
    _loginState = StateResponse.idle();
    _attendanceState = StateResponse.idle();
    _profileState = StateResponse.idle();
    _logoutState = StateResponse.idle();
    _profileResponse = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }

  void disposeCancelToken() {
    cancelTokenNow(_cancelToken, 'cancel due to navigation');
  }

  @override
  bool get shouldRetry => regularRetry(_profileState.state, _cancelToken);

  @override
  onReconnect() {
    profile();
  }
}
