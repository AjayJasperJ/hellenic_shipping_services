import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      openDialog(context);

      final response = await context.read<LeaveProvider>().getleavelist();
      if (response.status == 'token_expaired') {
        await ApiService().authguard(401);
        if (!mounted) return;
        await context.read<LeaveProvider>().getleavelist();
      }
      if (!mounted) return;
      final response2 = await context.read<TaskProvider>().getTaskList();
      if (response2.status == 'token_expaired') {
        await ApiService().authguard(401);
        if (!mounted) return;
        await context.read<TaskProvider>().getTaskList();
      }
      closeDialog(context);
    });
    super.initState();
  }

  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, index, _) {
          if (index == 0) return const DashboardScreen();
          if (index == 1) return const ApplyLeaveScreen();
          if (index == 2) return const TaskListScreen();
          return const SizedBox();
        },
      ),

      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, index, _) {
          return BottomNavigationBar(
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            onTap: (value) => selectedIndex.value = value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: "Alerts",
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
