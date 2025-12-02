import 'dart:convert';

class LeaveItem {
  final String id;
  final String employee;
  final String employeeName;
  final String leaveType;
  final String totalAllocated;
  final String used;
  final String remaining;

  const LeaveItem({
    this.id = "",
    this.employee = "",
    this.employeeName = "",
    this.leaveType = "",
    this.totalAllocated = "",
    this.used = "",
    this.remaining = "",
  });

  factory LeaveItem.fromJson(Map<String, dynamic> json) {
    return LeaveItem(
      id: json["id"]?.toString() ?? "",
      employee: json["employee"]?.toString() ?? "",
      employeeName: json["employee_name"]?.toString() ?? "",
      leaveType: json["leave_type"]?.toString() ?? "",
      totalAllocated: json["total_allocated"]?.toString() ?? "",
      used: json["used"]?.toString() ?? "",
      remaining: json["remaining"]?.toString() ?? "",
    );
  }

  Map<String, String> toJson() {
    return {
      "id": id,
      "employee": employee,
      "employee_name": employeeName,
      "leave_type": leaveType,
      "total_allocated": totalAllocated,
      "used": used,
      "remaining": remaining,
    };
  }

  LeaveItem copyWith({
    String? id,
    String? employee,
    String? employeeName,
    String? leaveType,
    String? totalAllocated,
    String? used,
    String? remaining,
  }) {
    return LeaveItem(
      id: id ?? this.id,
      employee: employee ?? this.employee,
      employeeName: employeeName ?? this.employeeName,
      leaveType: leaveType ?? this.leaveType,
      totalAllocated: totalAllocated ?? this.totalAllocated,
      used: used ?? this.used,
      remaining: remaining ?? this.remaining,
    );
  }

  @override
  String toString() {
    return "LeaveItem(id: $id, employee: $employee, employeeName: $employeeName, leaveType: $leaveType, totalAllocated: $totalAllocated, used: $used, remaining: $remaining)";
  }
}

class LeaveResponse {
  final List<LeaveItem> items;

  const LeaveResponse({this.items = const []});

  /// Parse from decoded JSON list
  factory LeaveResponse.fromJsonList(dynamic jsonList) {
    if (jsonList is! List) return const LeaveResponse(items: []);

    return LeaveResponse(
      items: jsonList
          .whereType<Map<String, dynamic>>()
          .map((e) => LeaveItem.fromJson(e))
          .toList(),
    );
  }

  /// Parse from encoded JSON string
  factory LeaveResponse.fromEncodedJson(String encoded) {
    final dynamic decoded = jsonDecode(encoded);
    return LeaveResponse.fromJsonList(decoded);
  }

  Map<String, dynamic> toJson() {
    return {"items": items.map((e) => e.toJson()).toList()};
  }

  LeaveResponse copyWith({List<LeaveItem>? items}) {
    return LeaveResponse(items: items ?? this.items);
  }

  @override
  String toString() => items.toString();
}
