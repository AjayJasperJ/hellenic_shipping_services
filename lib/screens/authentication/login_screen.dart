import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.appBackground),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 34.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 122.h),
              Center(
                child: Image.asset(
                  AppImages.appLogo,
                  height: 116.h,
                  width: 116.w,
                ),
              ),
              SizedBox(height: 40.h),
              Txt(
                'Hello There!',
                size: 21.sp,
                font: Font.semiBold,
                space: 0.2,
                height: 01,
                align: TextAlign.center,
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: width * .7,
                child: Txt(
                  'Log in to your account\nusing  username or email address',
                  size: 16.sp,
                  font: Font.regular,
                  space: 0.2,
                  // height: 1.2,
                  align: TextAlign.start,
                ),
              ),
              SizedBox(height: 18.h),
              Txtfield(),
            ],
          ),
        ),
      ),
    );
  }
}
