import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/data/token_storage.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/screens/dashboard/dashboard_screen.dart';
import 'package:hellenic_shipping_services/screens/navigation/bar.dart';
import 'package:hellenic_shipping_services/screens/task/apply_leave_screen.dart';
import 'package:hellenic_shipping_services/screens/task/task_list_screen.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String? username;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      openDialog(context);
      username = await TokenStorage.getdata('username');
      final leaveProvider = context.read<LeaveProvider>();
      final taskProvider = context.read<TaskProvider>();
      final authProvider = context.read<AuthProvider>();

      final response = await authProvider.profile();
      if (response.status == 'token_expaired') {
        await ApiService().authguard(401);
        if (mounted) {
          await authProvider.profile();
        }
      }

      // Fetch leave list
      final response1 = await leaveProvider.getleavelist();
      if (response1.status == 'token_expaired') {
        await ApiService().authguard(401);
        if (mounted) {
          await leaveProvider.getleavelist();
        }
      }

      if (!mounted) return;

      // Fetch task list
      final response2 = await taskProvider.getTaskList();
      if (response2.status == 'token_expaired') {
        await ApiService().authguard(401);
        if (mounted) {
          await taskProvider.getTaskList();
        }
      }

      if (mounted) closeDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Scaffold(
          key: _scaffoldKey,
          endDrawer: AppDrawer(),
          body: Selector<NavProvider, int>(
            selector: (_, p) => p.index,
            builder: (_, index, __) {
              switch (index) {
                case 0:
                  return const DashboardScreen();
                case 1:
                  return const ApplyLeaveScreen();
                case 2:
                  return const TaskListScreen();
                default:
                  return const SizedBox();
              }
            },
          ),
          bottomNavigationBar: CustomNavBar(
            onProfileTap: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ),
      ],
    );
  }
}
