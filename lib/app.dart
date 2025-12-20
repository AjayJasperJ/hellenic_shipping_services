import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/theme/themes.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:toastification/toastification.dart';

class HellenicApp extends StatelessWidget {
  final bool enableScale;
  const HellenicApp({super.key, required this.enableScale});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleText: () => enableScale,
      enableScaleWH: () => enableScale,
      builder: (context, child) => ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: AppThemes.lightTheme,
          navigatorKey: RouteNavigator.navigatorKey,
          routes: AppRoutes.goRoutes(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
          initialRoute: AppRoutes.splash,
        ),
      ),
    );
  }
}
