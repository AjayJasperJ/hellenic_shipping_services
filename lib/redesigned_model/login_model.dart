class LoginResponse {
  final String refresh;
  final String access;
  final String username;
  final String role;
  final String category;
  final String currentDate;

  LoginResponse({
    required this.refresh,
    required this.access,
    required this.username,
    required this.role,
    required this.category,
    required this.currentDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      refresh: json['refresh']?.toString() ?? "",
      access: json['access']?.toString() ?? "",
      username: json['username']?.toString() ?? "",
      role: json['role']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
      currentDate: json['current_date']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
      'username': username,
      'role': role,
      'category': category,
      'current_date': currentDate,
    };
  }
}

class AttendanceLoginResponse {
  final String message;
  final String attendanceId;
  final String selectedTime;

  AttendanceLoginResponse({
    required this.message,
    required this.attendanceId,
    required this.selectedTime,
  });

  factory AttendanceLoginResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceLoginResponse(
      message: json['message']?.toString() ?? "",
      attendanceId: json['attendance_id']?.toString() ?? "",
      selectedTime: json['selected_time']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'attendance_id': attendanceId,
      'selected_time': selectedTime,
    };
  }
}

class ErrorResponse {
  final String error;

  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(error: json['error']?.toString() ?? "");
  }

  Map<String, dynamic> toJson() {
    return {'error': error};
  }
}

class LogoutResponse {
  final String message;
  final String duration;
  final String logoutTime;

  const LogoutResponse({
    this.message = "",
    this.duration = "",
    this.logoutTime = "",
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message']?.toString() ?? "",
      duration: json['duration']?.toString() ?? "",
      logoutTime: json['logout_time']?.toString() ?? "",
    );
  }

  Map<String, String> toJson() {
    return {
      "message": message,
      "duration": duration,
      "logout_time": logoutTime,
    };
  }
}
