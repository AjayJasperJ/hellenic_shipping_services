import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/models/auth_model.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.h),
            Image.asset(AppImages.appLogo, height: 85.r, width: 85.r),
            SizedBox(height: 21.h),
            Selector<AuthProvider, EmployeeInfo?>(
              selector: (_, p) => p.employeeInfo,
              builder: (_, value, __) {
                return Txt(
                  'Hello ${Helper.capitalizeFirst(value?.username ?? '')}!',
                  size: 21.sp,
                  font: Font.semiBold,
                  height: 0.2,
                );
              },
            ),
            SizedBox(height: 16.h),
            Txt(Helper.formatCurrentDate(), size: 14.sp),
            SizedBox(height: 150.h),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 19.w,
                    vertical: 30.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),

                    border: GradientBoxBorder(
                      gradient: AppColors.appTextfield,
                      width: .5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Txt(
                        "Today's Schedule Overview",
                        font: Font.semiBold,
                        size: 20.sp,
                      ),
                      Txt("Mark your current work status below.", size: 14.sp),
                      SizedBox(height: 27.h),
                      Container(
                        height: 1.5,
                        width: 174.w,
                        color: AppColors.appSecondary,
                      ),
                      SizedBox(height: 27.h),
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 56.h,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<NavProvider>().setIndex(
                                    2,
                                  ); // Go to Task tab
                                },
                                style: customEvelatedButtonStyle(
                                  AppColors.appPrimary,
                                ),
                                child: Txt(
                                  'Onduty',
                                  color: AppColors.appBackground,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Flexible(
                            child: SizedBox(
                              height: 56.h,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<NavProvider>().setIndex(1);
                                },
                                style: customEvelatedButtonStyle(
                                  AppColors.appSecondary,
                                ),
                                child: Txt(
                                  'Leave',
                                  color: AppColors.appBackground,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: -8.h,

                  child: Center(
                    child: Container(
                      color: AppColors.appBackground,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Txt(
                        'Total hours logged in today',
                        height: 0,
                        size: 12.sp,
                        font: Font.regular,
                        space: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
