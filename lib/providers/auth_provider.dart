import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/models/auth_model.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  bool _loginloading = false;
  bool get loginloading => _loginloading;

  LoginResponse? _logindata;
  LoginResponse? get logindata => _logindata;

  Future<StatusResponse> loginuser({
    required String identifier,
    required String password,
  }) async {
    _loginloading = true;
    _logindata = null;
    notifyListeners();
    try {
      final response = await AuthServices.login(identifier, password);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonbody = jsonDecode(response.body);
        _logindata = LoginResponse.fromJson(jsonbody);
        TokenStorage.saveToken(_logindata!.access);
        TokenStorage.saveRefresh(_logindata!.refresh);
        return StatusResponse(status: 'success', message: 'login successful');
      } else {
        return StatusResponse(
          status: 'failure',
          message: jsonDecode(response.body)['error'],
        );
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'app failed');
    } finally {
      _loginloading = false;
      notifyListeners();
    }
  }

  Future<StatusResponse> attendanceuser({required TimeOfDay time}) async {
    _loginloading = true;
    _logindata = null;
    notifyListeners();
    try {
      final response = await AuthServices.attendance(time);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(
          status: 'success',
          message: 'Logged successfully',
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
      _loginloading = false;
      notifyListeners();
    }
  }

  EmployeeInfo? _employeeInfo;
  EmployeeInfo? get employeeInfo => _employeeInfo;

  Future<StatusResponse> profile() async {
    _loginloading = true;
    _logindata = null;
    notifyListeners();
    try {
      final response = await AuthServices.profile();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonbody = jsonDecode(response.body);
        _employeeInfo = EmployeeInfo.fromJson(jsonbody);
        return StatusResponse(
          status: 'success',
          message: 'Profile retrived successfully',
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
      _loginloading = false;
      notifyListeners();
    }
  }

  Future<StatusResponse> logout() async {
    try {
      final result = await AuthServices.logout();
      if (result.statusCode == 200 || result.statusCode == 201) {
        return StatusResponse(
          status: 'success',
          message: 'Successfully loggedOut',
        );
      } else if (result.statusCode == 401) {
        return StatusResponse(
          status: 'token_expaired',
          message: 'token expaired',
        );
      } else {
        return StatusResponse(
          status: 'failure',
          message: jsonDecode(result.body)['error'],
        );
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'Network error');
    }
  }

  void clearAllData() {
    _loginloading = false;
    _logindata = null;
    _employeeInfo = null;

    notifyListeners();
  }
}
