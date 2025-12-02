import 'dart:convert';

class LoginResponse {
  final String refresh;
  final String access;
  final String username;
  final String role;
  final String category;

  const LoginResponse({
    this.refresh = "",
    this.access = "",
    this.username = "",
    this.role = "",
    this.category = "",
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      refresh: json['refresh']?.toString() ?? "",
      access: json['access']?.toString() ?? "",
      username: json['username']?.toString() ?? "",
      role: json['role']?.toString() ?? "",
      category: json['category']?.toString() ?? "",
    );
  }

  factory LoginResponse.fromEncodedJson(String encoded) {
    final dynamic decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid login response payload');
    }
    return LoginResponse.fromJson(decoded);
  }

  Map<String, String> toJson() {
    return {
      'refresh': refresh,
      'access': access,
      'username': username,
      'role': role,
      'category': category,
    };
  }
}
