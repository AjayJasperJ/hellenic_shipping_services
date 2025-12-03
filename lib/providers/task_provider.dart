import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/tasklist_model.dart';
import 'package:hellenic_shipping_services/services/essential_services.dart';

class TaskProvider with ChangeNotifier {
  // ---------------- LOADERS -----------------
  bool _tasklistloading = false;
  bool get tasklistloading => _tasklistloading;

  bool _edittaskloading = false;
  bool get edittaskloading => _edittaskloading;

  bool _deletetaskloading = false;
  bool get deletetaskloading => _deletetaskloading;

  // ---------------- DATA -----------------
  List<DutyItem> _tasklist = [];
  List<DutyItem> get tasklist => _tasklist;

  /// main backup
  List<DutyItem> _originalList = [];

  // ---------------- DATE FILTER VARIABLES -----------------
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  // ---------------- FETCH LIST -----------------
  Future<StatusResponse> getTaskList() async {
    _tasklistloading = true;
    notifyListeners();

    try {
      final response = await EssentialServices.gettaskHistory();

      if (response.statusCode == 200 || response.statusCode == 201) {
        _tasklist = DutyItem.listFromJson(jsonDecode(response.body));

        // backup master list
        _originalList = List.from(_tasklist);

        notifyListeners();
        return StatusResponse(
          status: 'success',
          message: 'task list retrieved',
        );
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expired', message: response.body);
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

  // ---------------- PARSERS -----------------
  DateTime _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      return DateTime(2000);
    }
  }

  DateTime _parseTime(String timeStr) {
    try {
      final p = timeStr.split(":");
      return DateTime(2000, 1, 1, int.parse(p[0]), int.parse(p[1]));
    } catch (_) {
      return DateTime(2000);
    }
  }

  // ---------------- SORTING METHODS -----------------
  void sortByStartTime() {
    _tasklist.sort(
      (a, b) => _parseTime(a.startTime).compareTo(_parseTime(b.startTime)),
    );
    notifyListeners();
  }

  void sortByEndTime() {
    _tasklist.sort(
      (a, b) => _parseTime(a.endTime).compareTo(_parseTime(b.endTime)),
    );
    notifyListeners();
  }

  void sortByDate() {
    _tasklist.sort((a, b) => _parseDate(a.date).compareTo(_parseDate(b.date)));
    notifyListeners();
  }

  // ---------------- RESET SORT -----------------
  void resetSort() {
    selectedStartDate = null;
    selectedEndDate = null;

    _tasklist = List.from(_originalList);
    notifyListeners();
  }

  // ---------------- DATE FILTERING -----------------
  void setStartDate(DateTime date) {
    selectedStartDate = date;
    _applyFilter();
  }

  void setEndDate(DateTime date) {
    selectedEndDate = date;
    _applyFilter();
  }

  void _applyFilter() {
    /// always start from master
    _tasklist = List.from(_originalList);

    if (selectedStartDate == null && selectedEndDate == null) {
      notifyListeners();
      return;
    }

    _tasklist = _tasklist.where((task) {
      final taskDate = _parseDate(task.date);

      bool ok = true;

      if (selectedStartDate != null) {
        ok =
            ok && taskDate.isAtSameMomentAs(selectedStartDate!) ||
            taskDate.isAfter(selectedStartDate!);
      }

      if (selectedEndDate != null) {
        ok =
            ok && taskDate.isAtSameMomentAs(selectedEndDate!) ||
            taskDate.isBefore(selectedEndDate!);
      }

      return ok;
    }).toList();

    notifyListeners();
  }

  // ---------------- EDIT TASK -----------------
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
        return StatusResponse(status: 'success', message: 'task updated');
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expired', message: response.body);
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

  // ---------------- DELETE TASK -----------------
  Future<StatusResponse> deletetaskdata(String id) async {
    _deletetaskloading = true;
    notifyListeners();

    try {
      final response = await EssentialServices.deletetaskHistory(id);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StatusResponse(status: 'success', message: 'task deleted');
      } else if (response.statusCode == 401) {
        return StatusResponse(status: 'token_expired', message: response.body);
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

  void clearAllData() {
    _tasklistloading = false;
    _edittaskloading = false;
    _deletetaskloading = false;

    _tasklist = [];
    _originalList = [];

    selectedStartDate = null;
    selectedEndDate = null;

    notifyListeners();
  }
}
