import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

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
            Txt(
              'Hello Vignesh!',
              size: 21.sp,
              font: Font.semiBold,
              height: 0.2,
            ),
            SizedBox(height: 16.h),
            Txt('Friday 20 Aug, 2025', size: 14.sp),
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
                      Txt('7:38:07 Hrs', font: Font.semiBold, size: 20.sp),
                      SizedBox(height: 21.h),
                      Container(
                        height: 1.5,
                        width: 174.w,
                        color: AppColors.appSecondary,
                      ),
                      SizedBox(height: 30.h),
                      Txt(
                        "Today's Schedule Overview",
                        font: Font.semiBold,
                        size: 20.sp,
                      ),
                      Txt("Mark your current work status below.", size: 14.sp),
                      SizedBox(height: 27.h),
                      Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 56.h,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
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
                                onPressed: () {},
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
