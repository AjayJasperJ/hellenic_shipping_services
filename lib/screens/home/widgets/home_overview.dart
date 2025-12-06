import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:provider/provider.dart';

class HomeOverview extends StatelessWidget {
  const HomeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 252.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 30.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),

              border: GradientBoxBorder(
                gradient: AppColors.appTextfield,
                width: .5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                          child: Txt('Onduty', color: AppColors.appBackground),
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
                          child: Txt('Leave', color: AppColors.appBackground),
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
                  'Hellenic Shipping Services',
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
    );
  }
}
