// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:provider/provider.dart';

// ===========================
// Custom Navigation Bar
// ===========================
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        height: Dimen.h70,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 10),
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
      width: 230.w,
      child: Drawer(
        backgroundColor: AppColors.appBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimen.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 135.h),
              Selector<AuthProvider, EmployeeInfo?>(
                selector: (_, p) => p.employeeInfo,
                builder: (_, value, __) {
                  return Txt(
                    Helper.capitalizeFirst(value?.username ?? ''),
                    size: 21.sp,
                    font: Font.semiBold,
                  );
                },
              ),
              SizedBox(height: Dimen.h20),
              Selector<AuthProvider, EmployeeInfo?>(
                selector: (_, p) => p.employeeInfo,
                builder: (_, value, __) {
                  return Txt(
                    'Emp id #${Helper.capitalizeFirst(value?.employeeNo.toString() ?? '')}',
                    size: 14.sp,
                    font: Font.regular,
                  );
                },
              ),
              Selector<AuthProvider, EmployeeInfo?>(
                selector: (_, p) => p.employeeInfo,
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
                onTap: () {
                  TokenStorage.deleteToken();
                  try {
                    Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).clearAllData();
                  } catch (_) {}

                  try {
                    Provider.of<EntriesProvider>(
                      context,
                      listen: false,
                    ).clearAllData();
                  } catch (_) {}

                  try {
                    Provider.of<LeaveProvider>(
                      context,
                      listen: false,
                    ).clearAllData();
                  } catch (_) {}

                  try {
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).clearAllData();
                  } catch (_) {}
                  try {
                    Provider.of<NavProvider>(
                      context,
                      listen: false,
                    ).clearAllData();
                  } catch (_) {}
                  RouteNavigator.removeUntil(
                    AppRoutes.login,
                    (route) => route.isFirst,
                  );
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
    );
  }
}
