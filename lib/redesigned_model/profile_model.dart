class ProfileResponse {
  final String username;
  final String employeeNo;
  final String category;
  final String categoryLabel;
  final String loginTime;
  final String selectedTime;

  ProfileResponse({
    required this.username,
    required this.employeeNo,
    required this.category,
    required this.categoryLabel,
    required this.loginTime,
    required this.selectedTime,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      username: json['username']?.toString() ?? "",
      employeeNo: json['employee_no']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
      categoryLabel: json['category_label']?.toString() ?? "",
      loginTime: json['login_time']?.toString() ?? "",
      selectedTime: json['selected_time']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'employee_no': employeeNo,
      'category': category,
      'category_label': categoryLabel,
      'login_time': loginTime,
      'selected_time': selectedTime,
    };
  }
}
