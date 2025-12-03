import 'dart:convert';

class EmployeeInfo {
  final String username;
  final String employeeNo;
  final String category;
  final String categoryLabel;

  const EmployeeInfo({
    this.username = "",
    this.employeeNo = "",
    this.category = "",
    this.categoryLabel = "",
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      username: json['username']?.toString() ?? "",
      employeeNo: json['employee_no']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
      categoryLabel: json['category_label']?.toString() ?? "",
    );
  }

  factory EmployeeInfo.fromEncodedJson(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException("Invalid profile payload");
    }
    return EmployeeInfo.fromJson(decoded);
  }

  Map<String, String> toJson() {
    return {
      "username": username,
      "employee_no": employeeNo,
      "category": category,
      "category_label": categoryLabel,
    };
  }
}
