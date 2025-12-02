import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/screens/authentication/login_screen.dart';
import 'package:hellenic_shipping_services/screens/bottom_nav.dart';
import 'package:hellenic_shipping_services/screens/dashboard/dashboard_screen.dart';
import 'package:hellenic_shipping_services/screens/static/splash_screen.dart';
import 'package:hellenic_shipping_services/screens/task/apply_leave_screen.dart';
import 'package:hellenic_shipping_services/screens/task/create_task_screen.dart';
import 'package:hellenic_shipping_services/screens/task/task_list_screen.dart';
import 'package:hellenic_shipping_services/screens/task/view_task_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String createTask = '/createTask';
  static const String applyleave = '/applyleave';
  static const String tasklist = '/tasklist';
  static const String viewTask = '/viewTask';
  static const String nav = '/nav';

  static Map<String, WidgetBuilder> goRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      dashboard: (context) => const DashboardScreen(),
      login: (context) => const LoginScreen(),
      // createTask: (context) => const CreateTaskScreen(),
      applyleave: (context) => const ApplyLeaveScreen(),
      tasklist: (context) => const TaskListScreen(),
      nav: (context) => BottomNav(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case viewTask:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ViewTaskScreen(
            item: args?['item'],
            description: args?['description'],
            endTime: args?['endtime'],
            startTime: args?['starttime'],
            taskID: args?['taskid'],
            date: args?['date'],
          ),
        );
      case createTask:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CreateTaskScreen(dutyitem: args?['dutyitem']),
        );
      default:
        return null;
    }
  }
}
