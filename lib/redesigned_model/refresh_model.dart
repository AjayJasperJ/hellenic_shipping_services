class RefreshResponse {
  final String access;

  RefreshResponse({required this.access});

  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(access: json['access']?.toString() ?? "");
  }

  Map<String, dynamic> toJson() {
    return {'access': access};
  }
}

class TokenExpiredResponse {
  final String detail;
  final String code;
  final String messages;

  TokenExpiredResponse({
    required this.detail,
    required this.code,
    required this.messages,
  });

  factory TokenExpiredResponse.fromJson(Map<String, dynamic> json) {
    return TokenExpiredResponse(
      detail: json['detail']?.toString() ?? "",
      code: json['code']?.toString() ?? "",
      messages: (json['messages'] != null) ? json['messages'].toString() : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'code': code,
      'messages': messages,
    };
  }
}
