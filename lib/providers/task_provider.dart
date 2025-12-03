import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/tasklist_model.dart';
import 'package:hellenic_shipping_services/services/essential_services.dart';

class TaskProvider with ChangeNotifier {
  bool _tasklistloading = false;
  bool get tasklistloading => _tasklistloading;

  List<DutyItem> _tasklist = [];
  List<DutyItem> get tasklist => _tasklist;

  Future<StatusResponse> getTaskList() async {
    _tasklistloading = true;
    notifyListeners();
    try {
      final response = await EssentialServices.gettaskHistory();
      if (response.statusCode == 200 || response.statusCode == 201) {
        _tasklist = DutyItem.listFromJson(jsonDecode(response.body));
        return StatusResponse(status: 'success', message: 'task list retrived');
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(status: 'failed', message: response.body);
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'app failed');
    } finally {
      _tasklistloading = false;
      notifyListeners();
    }
  }

  bool _edittaskloading = false;
  bool get edittaskloading => _edittaskloading;

  Future<StatusResponse> edittaskdata(
    String id, {
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    _edittaskloading = true;
    notifyListeners();
    try {
      final response = await EssentialServices.edittaskHistory(
        id,
        description: description,
        endTime: endTime,
        startTime: startTime,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(status: 'success', message: 'task list retrived');
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(status: 'failed', message: response.body);
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'app failed');
    } finally {
      _edittaskloading = false;
      notifyListeners();
    }
  }

  bool _deletetaskloading = false;
  bool get deletetaskloading => _deletetaskloading;

  Future<StatusResponse> deletetaskdata(String id) async {
    _deletetaskloading = true;
    notifyListeners();
    try {
      final response = await EssentialServices.deletetaskHistory(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(status: 'success', message: 'task list retrived');
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expaired', message: response.body);
      } else {
        return StatusResponse(status: 'failed', message: response.body);
      }
    } catch (_) {
      return StatusResponse(status: 'exception', message: 'app failed');
    } finally {
      _deletetaskloading = false;
      notifyListeners();
    }
  }
}
