import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
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
import 'package:provider/provider.dart';

class ApplyLeaveButton extends StatelessWidget {
  final TextEditingController reasonController;
  const ApplyLeaveButton({super.key, required this.reasonController});

  Future<StatusResponse> applyleave(
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
                    openDialog(context);
                    final entriesProvider = context.read<EntriesProvider>();
                    // Run the request and check mounted before using context
                    final response = await ApiService.apiRequest(
                      context,
                      () => applyleave(entriesProvider, value),
                    );
                    if (!context.mounted) return;
                    ApiService.apiServiceStatus(context, response, (
                      data,
                    ) async {
                      if (data == 'success') {
                        final authProvider = context.read<AuthProvider>();
                        final entriesProvider = context.read<EntriesProvider>();
                        final leaveProvider = context.read<LeaveProvider>();
                        final taskProvider = context.read<TaskProvider>();
                        final navProvider = context.read<NavProvider>();

                        openDialog(context);

                        final response = await ApiService.apiRequest(
                          context,
                          () => authProvider.logout(),
                        );
                        if (!context.mounted) return;

                        if (context.mounted) closeDialog(context);

                        // Show toast or error based on response and then clear local state
                        ApiService.apiServiceStatus(context, response, (
                          data,
                        ) async {
                          if (data == 'success') {
                            RouteNavigator.pushReplacementRouted(
                              AppRoutes.login,
                            );
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
                          }
                        });
                      }
                    });
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
