import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.w),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: SizedBox(
              height: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100.h),
                  Center(
                    child: Image.asset(
                      AppImages.appLogo,
                      height: 120.r,
                      width: 120.r,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Txt(
                    'Hello There!',

                    size: 21.sp,
                    font: Font.semiBold,
                    space: 0.2,
                    height: 01,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
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
                  SizedBox(height: 21.h),
                  CustomBoarderedField(
                    label: "UserName",
                    child: Center(
                      child: Txtfield(keyboardtype: TextInputType.emailAddress),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  CustomBoarderedField(
                    label: "Password",
                    child: Center(
                      child: Txtfield(keyboardtype: TextInputType.emailAddress),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomBoarderedField(
                      width: width * .45,
                      label: "Login Time",
                      child: Center(),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  SizedBox(
                    height: 56.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        RouteNavigator.pushRouted(AppRoutes.dashboard);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.appPrimary,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10.r),
                          ),
                        ),
                      ),
                      child: Txt('Sign In', color: AppColors.appBackground),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Txt('By tapping on next, you are agreeing to', size: 12.sp),
                  RichText(
                    text: TextSpan(
                      text: 'Terms of Service ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.appSecondary,
                        decoration: TextDecoration.underline,
                      ),
                      children: [
                        TextSpan(
                          text: 'and ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.appPrimary,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.appSecondary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Txt(
                      'copyright 2025   Hellenic Shipping Services',
                      size: 10.sp,
                      font: Font.regular,
                      space: 0.2,
                      height: 0.18,
                      align: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
