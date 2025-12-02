import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/app.dart';
import 'package:hellenic_shipping_services/core/utils/internet_service.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InternetService()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LeaveProvider()),
        ChangeNotifierProvider(create: (context) => EntriesProvider()),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: const HellenicApp(),
    ),
  );
}
