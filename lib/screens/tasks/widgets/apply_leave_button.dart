import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_manager.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_widgets.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:provider/provider.dart';

class ApplyLeaveButton extends StatelessWidget {
  final TextEditingController reasonController;
  final DateTime? startDate;
  final DateTime? endDate;
  const ApplyLeaveButton({
    super.key,
    required this.reasonController,
    required this.startDate,
    required this.endDate,
  });

  Future<StateResponse> applyleave(
    EntriesProvider entriesProvider,
    LeaveProvider value,
  ) async {
    final result = await entriesProvider.applyleave(
      status: 'leave',
      leaveType: value.leaveitem?.leaveType ?? '',
      leaveReason: reasonController.text,
    );
    return result;
  }

  Future<StateResponse> applyannualleave(
    EntriesProvider entriesProvider,
  ) async {
    final result = await entriesProvider.applyannualleave(
      endTime: Helper.formatDate(endDate!),
      startTime: Helper.formatDate(startDate!),
      leaveReason: reasonController.text,
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: Consumer<LeaveProvider>(
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: (value.listleavetype?.items ?? []).isEmpty
                ? null
                : () async {
                    if (value.leaveitem == null) {
                      ToastManager.showSingleCustom(
                        child: FieldValidation(
                          message: 'Leave type not selected',
                          icon: Icons.text_fields_rounded,
                        ),
                      );
                      return;
                    }
                    if (value.leaveitem?.leaveType == 'annual') {
                      if (startDate == null) {
                        ToastManager.showSingleCustom(
                          child: FieldValidation(
                            message: 'Start date is empty',
                            icon: Icons.timer_sharp,
                          ),
                        );
                        return;
                      }
                      if (endDate == null) {
                        ToastManager.showSingleCustom(
                          child: FieldValidation(
                            message: 'End date is empty',
                            icon: Icons.timer_sharp,
                          ),
                        );
                        return;
                      }
                    }
                    if (reasonController.text.isEmpty) {
                      ToastManager.showSingleCustom(
                        child: FieldValidation(
                          message: 'Reason is empty',
                          icon: Icons.text_fields_rounded,
                        ),
                      );
                      return;
                    }

                    openDialog(context);
                    final entriesProvider = context.read<EntriesProvider>();

                    final response =
                        await ((value.leaveitem?.leaveType == 'annual')
                            ? applyannualleave(entriesProvider)
                            : applyleave(entriesProvider, value));

                    if (!context.mounted) return;

                    if (response.isSuccess) {
                      final authProvider = context.read<AuthProvider>();
                      final entriesProvider = context.read<EntriesProvider>();
                      final leaveProvider = context.read<LeaveProvider>();
                      final taskProvider = context.read<TaskProvider>();
                      final navProvider = context.read<NavProvider>();

                      openDialog(context);
                      final logoutResponse = await authProvider.logout();

                      if (!context.mounted) return;
                      closeDialog(context); // Close logout dialog

                      if (logoutResponse.isSuccess) {
                        RouteNavigator.pushReplacementRouted(AppRoutes.login);
                        TokenStorage.deleteToken();
                        TokenStorage.deleteRefresh();
                        try {
                          authProvider.clearAllData();
                        } catch (_) {}
                        try {
                          entriesProvider.clearAllData();
                        } catch (_) {}
                        try {
                          leaveProvider.clearAllData();
                        } catch (_) {}
                        try {
                          taskProvider.clearAllData();
                        } catch (_) {}
                        try {
                          navProvider.clearAllData();
                        } catch (_) {}
                      } else {
                        ToastManager.showSingleCustom(
                          child: FieldValidation(
                            message: logoutResponse.message,
                            icon: Icons.error_outline_rounded,
                          ),
                        );
                      }
                    } else {
                      ToastManager.showSingleCustom(
                        child: FieldValidation(
                          message: response.message,
                          icon: Icons.error_outline_rounded,
                        ),
                      );
                    }
                    if (!context.mounted) return;
                    closeDialog(context);
                  },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                (value.listleavetype?.items ?? []).isEmpty
                    ? Colors.grey
                    : AppColors.appPrimary,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10.r),
                ),
              ),
            ),
            child: Txt('Apply Leave', color: AppColors.appBackground),
          );
        },
      ),
    );
  }
}
