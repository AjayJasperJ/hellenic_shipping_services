import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_textfield.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
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
            SizedBox(height: 60.h),
            Row(
              children: [
                Expanded(
                  child: CustomBoarderedField(
                    label: 'Start Time',
                    child: Txtfield(),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomBoarderedField(
                    label: 'End Time',
                    child: Txtfield(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            CustomBoarderedField(label: 'Job ID', child: Txtfield()),
            SizedBox(height: 20.h),
            CustomBoarderedField(label: 'Shop Name', child: Txtfield()),
            SizedBox(height: 20.h),
            CustomBoarderedField(label: 'Location', child: Txtfield()),
            SizedBox(height: 20.h),
            CustomBoarderedField(
              label: 'Remarks',
              child: Txtfield(maxLines: 4),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 56.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  RouteNavigator.pushRouted(AppRoutes.applyleave);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.appPrimary),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10.r),
                    ),
                  ),
                ),
                child: Txt('Save', color: AppColors.appBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
