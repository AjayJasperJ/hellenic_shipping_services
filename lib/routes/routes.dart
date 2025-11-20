import 'package:flutter/cupertino.dart';
import 'package:hellenic_shipping_services/screens/authentication/login_screen.dart';
import 'package:hellenic_shipping_services/screens/dashboard/dashboard_screen.dart';
import 'package:hellenic_shipping_services/screens/static/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static Map<String, WidgetBuilder> goRoutes() {
    return {
      splash: (context) => SplashScreen(),
      dashboard: (context) => DashboardScreen(),
      login: (context) => LoginScreen(),
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
