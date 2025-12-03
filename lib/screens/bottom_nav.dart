import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/providers/nav_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/screens/dashboard/dashboard_screen.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      openDialog(context);

      final leaveProvider = context.read<LeaveProvider>();
      final taskProvider = context.read<TaskProvider>();

      // Fetch leave list
      final response = await leaveProvider.getleavelist();
      if (response.status == 'token_expaired') {
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
    return Scaffold(
      //
      // ---------- BODY ----------
      //
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
            case 3:
              return Center(child: Text("Profile Page Placeholder"));
            default:
              return const SizedBox();
          }
        },
      ),

      //
      // ---------- BOTTOM NAV ----------
      //
      bottomNavigationBar: Selector<NavProvider, int>(
        selector: (_, p) => p.index,
        builder: (context, index, _) {
          return BottomNavigationBar(
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              context.read<NavProvider>().setIndex(value);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.beach_access_outlined),
                activeIcon: Icon(Icons.beach_access_rounded),
                label: "Leave",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined),
                activeIcon: Icon(Icons.task_alt_rounded),
                label: "TaskList",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          );
        },
      ),
    );
  }
}
