import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/network/utils/connectivity_service.dart';
import 'package:hellenic_shipping_services/core/theme/themes.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_manager.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_widgets.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:toastification/toastification.dart';

class HellenicApp extends StatefulWidget {
  final bool enableScale;
  const HellenicApp({super.key, required this.enableScale});

  @override
  State<HellenicApp> createState() => _HellenicAppState();
}

class _HellenicAppState extends State<HellenicApp> {
  late final ConnectivityService _connectivityService;
  late final StreamSubscription<bool> _connectionSubscription;

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _connectionSubscription = _connectivityService.connectionChange.listen((
      hasConnection,
    ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!hasConnection) {
          ToastManager.showSingleCustom(
            child: FieldValidation(
              message: 'No Internet Connection',
              icon: Icons.error_outline_outlined,
            ),
          );
        } else {
          ToastManager.showSingleCustom(
            child: FieldValidation(
              message: 'Internet Connection Restored',
              icon: Icons.check_circle_outline_outlined,
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      enableScaleText: () => widget.enableScale,
      enableScaleWH: () => widget.enableScale,
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
