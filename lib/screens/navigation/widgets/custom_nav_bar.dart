// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/redesigned_model/profile_model.dart';

import 'package:toastification/toastification.dart';
import 'package:hellenic_shipping_services/screens/widget/other_widgets.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/redesigned_model/employee_detail.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_profile.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  CustomNavBar({super.key, required this.onProfileTap});

  final List<String> _icons = [
    AppIcons.home,
    AppIcons.add,
    AppIcons.transaction,
    AppIcons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return Padding(
      padding: EdgeInsets.only(
        left: Dimen.w10,
        right: Dimen.w10,
        bottom: Dimen.h15,
      ),
      child: Container(
        height: Dimen.h70,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            final bool isActive = navProvider.index == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (index == 3) {
                    // Last item → open drawer, don't change page
                    onProfileTap();
                  } else {
                    // Normal navigation
                    navProvider.setIndex(index);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors
                              .appPrimary // Replace with AppColors.appPrimary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Center(
                    child: Image.asset(
                      _icons[index],
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      height: Dimen.r18,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        backgroundColor: AppColors.appBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimen.w16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Selector<AuthProvider, ProfileResponse?>(
                  selector: (_, p) => p.profileResponse,
                  builder: (_, value, __) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimen.h50),
                        GestureDetector(
                          onTap: () {
                            RouteNavigator.pushReplacementRouted(
                              AppRoutes.login,
                            );
                          },
                          child: CustomProfileImage(
                            username: value?.username ?? '',
                            radius: Dimen.r40,
                          ),
                        ),
                        SizedBox(height: Dimen.h15),
                        Txt(
                          Helper.capitalizeFirst(value?.username ?? ''),
                          size: 21.sp,
                          font: Font.semiBold,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: Dimen.h20),
                Selector<AuthProvider, ProfileResponse?>(
                  selector: (_, p) => p.profileResponse,
                  builder: (_, value, __) {
                    return Txt(
                      'Emp id #${Helper.capitalizeFirst(value?.employeeNo.toString() ?? '')}',
                      size: 14.sp,
                      font: Font.regular,
                    );
                  },
                ),
                Selector<AuthProvider, ProfileResponse?>(
                  selector: (_, p) => p.profileResponse,
                  builder: (_, value, __) {
                    return Flexible(
                      child: Txt(
                        'Emp type : ${Helper.capitalizeFirst(value?.categoryLabel.toString() ?? '')}',
                        size: 14.sp,
                        font: Font.regular,
                      ),
                    );
                  },
                ),
                SizedBox(height: Dimen.h20),
                GestureDetector(
                  onTap: () async {
                    // Ask for confirmation before logging out
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (c) {
                        return AlertDialog(
                          title: const Text('Confirm Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(c).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(c).pop(true),
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                    if (!context.mounted) return;
                    if (shouldLogout != null && shouldLogout) {
                      final authProvider = context.read<AuthProvider>();
                      final entriesProvider = context.read<EntriesProvider>();
                      final leaveProvider = context.read<LeaveProvider>();
                      final taskProvider = context.read<TaskProvider>();
                      final navProvider = context.read<NavProvider>();

                      openDialog(context);

                      final response = await authProvider.logout();
                      if (!context.mounted) return;

                      if (context.mounted) closeDialog(context);

                      if (response.isSuccess) {
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
                        ToastManager.showSingle(
                          context,
                          title: response.message,
                          type: ToastificationType.error,
                        );
                      }
                    }
                  },
                  child: Container(
                    height: Dimen.h55,
                    width: 230.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Dimen.r8),
                    ),
                    child: Center(child: Txt("LogOut Now")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
