import 'dart:convert';

class UserLoginCredentials {
  UserLoginCredentials({
    required this.tokentype,
    required this.accesstoken,
    required this.apikey,
    this.expiresin,
  });

  String tokentype;
  String accesstoken;
  String apikey;
  String? expiresin;

  bool get isComplete =>
      tokentype.isNotEmpty && accesstoken.isNotEmpty && apikey.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'token_type': tokentype,
    'access_token': accesstoken,
    'api_key': apikey,
    if (expiresin != null) 'expires_in': expiresin,
  };

  String toEncodedJson() => jsonEncode(toJson());

  factory UserLoginCredentials.fromJson(Map<String, dynamic> json) {
    String? sanitize(dynamic value) {
      if (value == null) return null;
      final result = value.toString().trim();
      return result.isEmpty ? null : result;
    }

    return UserLoginCredentials(
      tokentype: sanitize(json['token_type']) ?? '',
      accesstoken: sanitize(json['access_token']) ?? '',
      apikey: sanitize(json['api_key']) ?? '',
      expiresin: sanitize(json['expires_in']),
    );
  }

  factory UserLoginCredentials.fromEncodedJson(String encoded) {
    final dynamic decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid credential payload');
    }
    return UserLoginCredentials.fromJson(decoded);
  }

  UserLoginCredentials copyWith({
    String? tokentype,
    String? accesstoken,
    String? apikey,
    String? expiresin,
  }) {
    return UserLoginCredentials(
      tokentype: tokentype ?? this.tokentype,
      accesstoken: accesstoken ?? this.accesstoken,
      apikey: apikey ?? this.apikey,
      expiresin: expiresin ?? this.expiresin,
    );
  }
}
