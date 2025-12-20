import 'package:hellenic_shipping_services/core/network/api_services/api_error.dart';

class StateResponse<T> {
  final States state;
  final String message;
  final T? data;
  final ApiErrorType? errorType;
  final int? code;

  const StateResponse({
    required this.state,
    required this.message,
    this.data,
    this.errorType,
    this.code,
  });
  factory StateResponse.idle() => StateResponse(state: States.idle, message: 'Page idle');

  factory StateResponse.success(T data, {String? message}) =>
      StateResponse(state: States.success, message: message ?? "Success", data: data);

  factory StateResponse.failure(ApiError error) => StateResponse(
    state: States.failure,
    message: error.message,
    errorType: error.type,
    code: error.code,
  );

  factory StateResponse.exception(String message, {T? data}) =>
      StateResponse(state: States.exception, message: message, data: data);

  factory StateResponse.loading({String? message}) =>
      StateResponse(state: States.loading, message: message ?? "Loading...");

  bool get isSuccess => state == States.success;
  bool get isFailure => state == States.failure;
  bool get isLoading => state == States.loading;
  bool get isIdle => state == States.idle;
}

enum States { idle, loading, success, failure, exception }
