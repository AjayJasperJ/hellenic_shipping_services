import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/network/api_services/api_error.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/core/network/utils/connectivity_service.dart';
import 'package:toastification/toastification.dart';

class UiBuilder<T> extends StatelessWidget {
  final StateResponse<dynamic>? response;
  final List<Widget> Function(T? data) onSuccess;
  final List<Widget> Function()? onLoading;
  final List<Widget> Function()? onIdle;
  final List<Widget> Function(ApiError error)? onFailure;
  final List<Widget> Function(String message)? onException;
  final void Function(StateResponse<dynamic>? response)? listener;

  const UiBuilder({
    super.key,
    this.response,
    required this.onSuccess,
    this.onLoading,
    this.onIdle,
    this.onFailure,
    this.onException,
    this.listener,
  });

  @override
  Widget build(BuildContext context) {
    if (listener != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listener!(response);
      });
    }
    return SliverMainAxisGroup(slivers: _buildSlivers());
  }

  List<Widget> _buildSlivers() {
    switch (response?.state) {
      case States.idle:
        return onIdle?.call() ?? [];
      case States.loading:
        return onLoading?.call() ?? [];
      case States.success:
        T? dataPayload;
        if (response?.data != null) {
          if (response!.data is T) {
            dataPayload = response!.data as T;
          } else {
            try {
              dataPayload = response!.data as T;
            } catch (_) {}
          }
        }
        return onSuccess(dataPayload);
      case States.failure:
        final error = ApiError(
          message: response?.message ?? "Unknown error",
          type: response?.errorType ?? ApiErrorType.unknown,
          code: response?.code,
        );
        return onFailure?.call(error) ?? [];
      case States.exception:
        return onException?.call(response?.message ?? "Unknown exception") ?? [];
      case null:
        return onIdle?.call() ?? [];
    }
  }
}

Future<void> updateNotifier(
  BuildContext context, {
  required StateResponse response,
  Future<void> Function(States state)? onInit,
  void Function(States state)? todo,
  bool disableSuccessToast = false,
  bool disableFailureToast = false,
  bool disableExceptionToast = false,
  bool disableCancelledToast = true,
  Map<States, String>? messageOverrides,
}) async {
  final connectivityService = ConnectivityService();
  if (onInit != null) {
    await onInit(response.state);
  }

  void showToast({required String message, required ToastificationType type}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: type,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 4),
      alignment: Alignment.bottomCenter,
    );
  }

  String resolveMessage(String defaultMsg, States state) {
    return messageOverrides != null && messageOverrides.containsKey(state)
        ? messageOverrides[state]!
        : defaultMsg;
  }

  switch (response.state) {
    case States.idle:
      todo?.call(States.idle);
      break;
    case States.loading:
      todo?.call(States.loading);
      break;
    case States.success:
      if (!disableSuccessToast) {
        showToast(
          message: resolveMessage(response.message, States.success),
          type: ToastificationType.success,
        );
      }
      todo?.call(States.success);
      break;

    case States.failure:
      if (!disableFailureToast) {
        if (response.errorType != ApiErrorType.cancelled) {
          showToast(
            message: resolveMessage(response.message, States.failure),
            type: ToastificationType.warning,
          );
        }
      }
      todo?.call(States.failure);
      break;

    case States.exception:
      if (!disableExceptionToast) {
        final message = connectivityService.hasConnection
            ? resolveMessage(response.message, States.exception)
            : 'No Internet Connection';
        showToast(message: message, type: ToastificationType.error);
      }
      todo?.call(States.exception);
      break;
  }
}
