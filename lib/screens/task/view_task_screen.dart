import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

class ViewTaskScreen extends StatefulWidget {
  const ViewTaskScreen({super.key});

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),
                    Image.asset(AppImages.appLogo, height: 77.r, width: 77.r),
                    SizedBox(height: 20.h),
                    Txt('Task History', size: 21.sp, font: Font.semiBold),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.h),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: Font.bold.weight,
                ),
                children: const [
                  TextSpan(
                    text: 'Start Time : ',
                    style: TextStyle(color: Color.fromARGB(255, 69, 134, 63)),
                  ),
                  TextSpan(
                    text: '12:01 AM - Aug 20',
                    // style: TextStyle(color: ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: Font.bold.weight,
                ),
                children: const [
                  TextSpan(
                    text: 'End Time : ',
                    style: TextStyle(color: Color.fromARGB(255, 160, 58, 58)),
                  ),
                  TextSpan(
                    text: '12:01 AM - Aug 21',
                    // style: TextStyle(color: ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
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
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.center,
                        colors: [AppColors.appPrimary, AppColors.appPrimary],
                      ),
                      width: 1,
                    ),
                  ),
                  child: Txt(
                    """Manage daily client requests and ensure smooth project delivery.
Collaborate with internal teams to address requirements efficiently and maintain clear communication throughout each phase.
Monitor ongoing projects to identify potential challenges early and implement effective solutions.
Strive to deliver exceptional results that strengthen client relationships and enhance overall service quality.`""",
                    size: 16.sp,
                    font: Font.medium,
                  ),
                ),
                Positioned(
                  left: 25,

                  top: -8.h,

                  child: Center(
                    child: Container(
                      color: AppColors.appBackground,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Txt(
                        'About the task',
                        height: 0,
                        color: Color.fromARGB(255, 69, 134, 63),
                        size: 12.sp,
                        font: Font.regular,
                        space: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 56.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // RouteNavigator.pushRouted(AppRoutes.createTask);
                      },
                      style: customEvelatedButtonStyle(Colors.blueGrey),
                      child: Txt(
                        'Edit',
                        size: 16.sp,
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
                        Color.fromARGB(255, 160, 58, 58),
                      ),
                      child: Txt(
                        'Delete',
                        size: 16.sp,
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
    );
  }
}
