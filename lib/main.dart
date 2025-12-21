import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellenic_shipping_services/app.dart';
import 'package:hellenic_shipping_services/bootstrap.dart';
import 'package:hellenic_shipping_services/core/utils/global_logger.dart';
import 'package:hellenic_shipping_services/core/utils/internet_service.dart';
import 'package:hellenic_shipping_services/core/utils/logger_service.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
  try {
    await LoggerService.init();
  } catch (e, s) {
    // If logging initialization fails, don't prevent the app from starting.
    // Log to console and continue.
    debugPrint('LoggerService.init failed: $e\n$s');
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final width =
      WidgetsBinding
          .instance
          .platformDispatcher
          .views
          .first
          .physicalSize
          .width /
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

  final bool isPhone = width <= 450;
  final bool isSmallPhone = width <= 360;
  try {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => InternetService()),
          ChangeNotifierProvider(create: (_) => NavProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => LeaveProvider()),
          ChangeNotifierProvider(create: (context) => EntriesProvider()),
          ChangeNotifierProvider(create: (context) => TaskProvider()),
        ],
        child: HellenicApp(enableScale: isPhone || isSmallPhone),
      ),
    );
  } catch (e) {
    gLogger.error(e.toString());
  }
}
