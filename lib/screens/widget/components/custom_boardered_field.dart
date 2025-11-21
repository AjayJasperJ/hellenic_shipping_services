import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

class CustomBoarderedField extends StatelessWidget {
  final Widget child;
  final String label;
  final double? width;
  const CustomBoarderedField({
    super.key,
    this.width,
    required this.child,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: GradientBoxBorder(
              gradient: AppColors.appTextfield,
              width: .5,
            ),
          ),
          constraints: BoxConstraints(minHeight: 48.h),
          child: child,
        ),
        Positioned(
          left: 25.w,
          top: -8.h,

          child: Container(
            color: AppColors.appBackground,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Txt(
              label,
              height: 0,
              size: 12.sp,
              font: Font.regular,
              space: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
