import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/network/interceptors/cache_interceptor.dart';
import 'package:hellenic_shipping_services/core/network/interceptors/offline_sync_interceptor.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_manager.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_widgets.dart';
import 'package:hellenic_shipping_services/redesigned_model/profile_model.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
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
                        CustomProfileImage(
                          username: value?.username ?? '',
                          radius: Dimen.r40,
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
                      'Emp id #${Helper.capitalizeFirst(value?.employeeNo.toString().toUpperCase() ?? '')}',
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
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  size: 40.r,
                                  color: AppColors.appPrimary,
                                ),
                                SizedBox(height: 16.h),
                                Txt(
                                  "Confirm Logout",
                                  size: 18.sp,
                                  font: Font.bold,
                                ),
                                SizedBox(height: 8.h),
                                Txt(
                                  "Are you sure you want to logout?",
                                  size: 14.sp,
                                  font: Font.regular,
                                  align: TextAlign.center,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(height: 24.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        child: Txt(
                                          "Cancel",
                                          size: 14.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.appSecondary,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                        child: Txt(
                                          "Logout",
                                          size: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                        await CacheInterceptor.reset();
                        await OfflineSyncInterceptor.reset();
                        ToastManager.showSingleCustom(
                          child: FieldValidation(
                            message: 'Logged out Successfully',
                            icon: Icons.logout,
                          ),
                        );
                      } else {
                        ToastManager.showSingleCustom(
                          child: FieldValidation(
                            message: response.message,
                            icon: Icons.error_outline_outlined,
                          ),
                        );
                      }
                    }
                  },
                  // onLongPress: () {
                  //   RouteNavigator.pushReplacementRouted(AppRoutes.login);
                  // },
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
