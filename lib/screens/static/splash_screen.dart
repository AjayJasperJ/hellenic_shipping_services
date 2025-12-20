import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/core/utils/global_logger.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    try {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        precacheImage(AssetImage(AppImages.appLogo), context);
        autoRoute();
      });
    } catch (e) {
      gLogger.error('splash : $e');
    }
  }

  Future<void> autoRoute() async {
    await Future.delayed(Duration(milliseconds: 1500));
    final token = await TokenStorage.getToken();
    if (!mounted) return;
    token != null
        ? Navigator.of(context).pushReplacementNamed(AppRoutes.nav)
        : Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image.asset(AppImages.appLogo, height: 122.h, width: 122.18.w),
            SizedBox(height: 22.h),
            Txt(
              'HELLENIC',
              size: 21.sp,
              font: Font.bold,
              space: 0.42,
              height: 0.1,
              align: TextAlign.center,
            ),
            SizedBox(height: 14.h),
            Txt(
              'Shipping services',
              size: 16.sp,
              font: Font.regular,
              space: 0.2,
              // height: 0.23,
              align: TextAlign.center,
            ),
            Spacer(),
            Txt(
              'copyright 2025   Hellenic Shipping Services',
              size: 10.sp,
              font: Font.regular,
              space: 0.2,
              height: 0.18,
              align: TextAlign.center,
            ),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }
}
