class DutyItem {
  final String id;
  final String employeeName;
  final Attendance attendance;
  final String status;
  final String description;
  final String startTime;
  final String endTime;
  final String jobNo;
  final String shipName;
  final String location;
  final String holidayWorked;
  final String offStation;
  final String localSite;
  final String driv;
  final String leaveType;
  final String leaveReason;
  final String date;
  final String day;
  final String createdAt;
  final String category;

  const DutyItem({
    this.id = "",
    this.employeeName = "",
    this.attendance = const Attendance(),
    this.status = "",
    this.description = "",
    this.startTime = "",
    this.endTime = "",
    this.jobNo = "",
    this.shipName = "",
    this.location = "",
    this.holidayWorked = "",
    this.offStation = "",
    this.localSite = "",
    this.driv = "",
    this.leaveType = "",
    this.leaveReason = "",
    this.date = "",
    this.day = "",
    this.createdAt = "",
    this.category = "",
  });

  factory DutyItem.fromJson(Map<String, dynamic> json) {
    return DutyItem(
      id: json["id"]?.toString() ?? "",
      employeeName: json["employee_name"]?.toString() ?? "",
      attendance: json["attendance"] is Map<String, dynamic>
          ? Attendance.fromJson(json["attendance"])
          : const Attendance(),
      status: json["status"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
      startTime: json["start_time"]?.toString() ?? "",
      endTime: json["end_time"]?.toString() ?? "",
      jobNo: json["job_no"]?.toString() ?? "",
      shipName: json["ship_name"]?.toString() ?? "",
      location: json["location"]?.toString() ?? "",
      holidayWorked: json["holiday_worked"]?.toString() ?? "",
      offStation: json["off_station"]?.toString() ?? "",
      localSite: json["local_site"]?.toString() ?? "",
      driv: json["driv"]?.toString() ?? "",
      leaveType: json["leave_type"]?.toString() ?? "",
      leaveReason: json["leave_reason"]?.toString() ?? "",
      date: json["date"]?.toString() ?? "",
      day: json["day"]?.toString() ?? "",
      createdAt: json["created_at"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "",
    );
  }

  static List<DutyItem> listFromJson(dynamic jsonList) {
    if (jsonList is List) {
      return jsonList.map((e) => DutyItem.fromJson(e)).toList();
    }
    return [];
  }
}

class Attendance {
  final String id;
  final String employeeName;
  final String loginTime;
  final String logoutTime;
  final String duration;

  const Attendance({
    this.id = "",
    this.employeeName = "",
    this.loginTime = "",
    this.logoutTime = "",
    this.duration = "",
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json["id"]?.toString() ?? "",
      employeeName: json["employee_name"]?.toString() ?? "",
      loginTime: json["login_time"]?.toString() ?? "",
      logoutTime: json["logout_time"]?.toString() ?? "",
      duration: json["duration"]?.toString() ?? "",
    );
  }
}
