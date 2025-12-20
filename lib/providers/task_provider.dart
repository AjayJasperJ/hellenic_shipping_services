import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/redesigned_model/tasklist_model.dart';
import 'package:hellenic_shipping_services/services/essential_services.dart';

class TaskProvider with ChangeNotifier {
  StateResponse _taskListState = StateResponse.idle();
  StateResponse get taskListState => _taskListState;
  List<DutyItem> _tasklist = [];
  List<DutyItem> get tasklist => _tasklist;
  List<DutyItem> _originalList = [];
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  Future<StateResponse> getTaskList() async {
    _taskListState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await EssentialServices.gettaskHistory();
      return response.when(
        success: (data) {
          _tasklist = data;
          _originalList = data;
          _taskListState = StateResponse.success(
            data,
            message: 'list retrieved successfully',
          );
          return _taskListState;
        },
        failure: (error) {
          _taskListState = StateResponse.failure(error);
          return _taskListState;
        },
      );
    } catch (_) {
      _taskListState = StateResponse.exception('Something went wrong');
      return _taskListState;
    } finally {
      notifyListeners();
    }
  }

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

  void resetSort() {
    selectedStartDate = null;
    selectedEndDate = null;
    _tasklist = List.from(_originalList);
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    selectedStartDate = date;
    _applyFilter();
  }

  void setEndDate(DateTime date) {
    selectedEndDate = date;
    _applyFilter();
  }

  void _applyFilter() {
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

  StateResponse _editTaskState = StateResponse.idle();
  StateResponse get editTaskState => _editTaskState;

  Future<StateResponse> edittaskdata(
    String id,
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
    _editTaskState = StateResponse.loading();
    notifyListeners();

    try {
      final response = await EssentialServices.edittaskHistory(
        id,
        idA,
        description: description,
        endTime: endTime,
        startTime: startTime,
        jobId: jobId,
        location: location,
        shipNum: shipNum,
        status: status,
        driv: driv,
        holiday: holiday,
        localSite: localSite,
        offStation: offStation,
      );
      return response.when(
        success: (data) {
          _editTaskState = StateResponse.success(
            data,
            message: 'Task updated successfully',
          );
          return _editTaskState;
        },
        failure: (error) {
          _editTaskState = StateResponse.failure(error);
          return _editTaskState;
        },
      );
    } catch (_) {
      _editTaskState = StateResponse.exception('Something went wrong');
      return _editTaskState;
    } finally {
      notifyListeners();
    }
  }

  StateResponse _deleteTaskState = StateResponse.idle();
  StateResponse get deleteTaskState => _deleteTaskState;

  Future<StateResponse> deletetaskdata(String id) async {
    _deleteTaskState = StateResponse.loading();
    notifyListeners();
    try {
      final response = await EssentialServices.deletetaskHistory(id);
      return response.when(
        success: (data) {
          _deleteTaskState = StateResponse.success(
            data,
            message: 'Task deleted successfully',
          );
          return _deleteTaskState;
        },
        failure: (error) {
          _deleteTaskState = StateResponse.failure(error);
          return _deleteTaskState;
        },
      );
    } catch (_) {
      _deleteTaskState = StateResponse.exception('Something went wrong');
      return _deleteTaskState;
    } finally {
      notifyListeners();
    }
  }

  void clearAllData() {
    _taskListState = StateResponse.idle();
    _editTaskState = StateResponse.idle();
    _deleteTaskState = StateResponse.idle();
    _tasklist = [];
    _originalList = [];
    selectedStartDate = null;
    selectedEndDate = null;
    notifyListeners();
  }
}
