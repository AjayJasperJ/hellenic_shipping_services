import 'package:flutter/cupertino.dart';
import 'package:hellenic_shipping_services/screens/authentication/login_screen.dart';
import 'package:hellenic_shipping_services/screens/dashboard/dashboard_screen.dart';
import 'package:hellenic_shipping_services/screens/static/splash_screen.dart';
import 'package:hellenic_shipping_services/screens/task/apply_leave_screen.dart';
import 'package:hellenic_shipping_services/screens/task/create_task_screen.dart';
import 'package:hellenic_shipping_services/screens/task/task_list_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String createTask = '/createTask';
  static const String applyleave = '/applyleave';
  static const String tasklist = '/tasklist';

  static Map<String, WidgetBuilder> goRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      dashboard: (context) => const DashboardScreen(),
      login: (context) => const LoginScreen(),
      createTask: (context) => const CreateTaskScreen(),
      applyleave: (context) => const ApplyLeaveScreen(),
      tasklist: (context) => const TaskListScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case services:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => BooknowScreen(
      //           isDeity: args?['isDeity'],
      //           deitiesDetails: args?['deitiesDetails'],
      //           worshipCenter: args?['worshipCenter'],
      //         ),
      //   );
      default:
        return null;
    }
  }
}
