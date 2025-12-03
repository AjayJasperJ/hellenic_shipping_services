import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(30.r),
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(AppImages.appLogo, height: 77.r, width: 77.r),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Selector<AuthProvider, EmployeeInfo?>(
                            selector: (_, p) => p.employeeInfo,
                            builder: (_, value, __) {
                              return Txt(
                                'Hello ${Helper.capitalizeFirst(value?.username ?? '')}!',
                                size: 21.sp,
                                font: Font.semiBold,
                                height: 0.2,
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          Txt(Helper.formatCurrentDate(), size: 14.sp),
                        ],
                      ),
                      SizedBox(
                        height: 41.h,
                        width: 129.w,
                        child: ElevatedButton(
                          onPressed: () {
                            RouteNavigator.pushRouted(AppRoutes.createTask);
                          },
                          style: customEvelatedButtonStyle(
                            AppColors.appSecondary,
                          ),
                          child: Txt(
                            '+ New Task',
                            size: 14.sp,
                            color: AppColors.appBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),

                      // ALL
                      GestureDetector(
                        onTap: () => context.read<TaskProvider>().resetSort(),
                        child: Txt("All", size: 14.sp, font: Font.semiBold),
                      ),

                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),

                      // START DATE DROPDOWN
                      Consumer<TaskProvider>(
                        builder: (_, p, __) {
                          return GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              if (picked != null) {
                                p.setStartDate(picked);
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Txt(
                                  p.selectedStartDate == null
                                      ? "Start Date"
                                      : "${p.selectedStartDate!.day}/${p.selectedStartDate!.month}/${p.selectedStartDate!.year}",
                                  size: 14.sp,
                                  font: Font.semiBold,
                                ),
                                SizedBox(width: 10.w),
                                Icon(Icons.calendar_today_outlined, size: 18),
                              ],
                            ),
                          );
                        },
                      ),

                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),

                      // END DATE DROPDOWN
                      Consumer<TaskProvider>(
                        builder: (_, p, __) {
                          return GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: DateTime.now(),
                              );
                              if (picked != null) {
                                p.setEndDate(picked);
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Txt(
                                  p.selectedEndDate == null
                                      ? "End Date"
                                      : "${p.selectedEndDate!.day}/${p.selectedEndDate!.month}/${p.selectedEndDate!.year}",
                                  size: 14.sp,
                                  font: Font.semiBold,
                                ),
                                SizedBox(width: 10.w),
                                Icon(Icons.calendar_today_outlined, size: 18),
                              ],
                            ),
                          );
                        },
                      ),

                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // List of Cards
            Consumer<TaskProvider>(
              builder: (context, value, child) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  itemCount: value.tasklist.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final current = value.tasklist[index];
                    return GestureDetector(
                      onTap: () => RouteNavigator.pushRouted(
                        AppRoutes.viewTask,
                        arguments: {
                          'description': current.description,
                          'starttime': current.startTime,
                          'endtime': current.endTime,
                          'taskid': current.id,
                          'date': current.date,
                          'item': current,
                        },
                      ),
                      child: RepaintBoundary(
                        child: TaskCardWithDiagonalBlur(
                          day: current.day,
                          startdate: current.startTime,
                          enddate: current.endTime,
                          description: current.description,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Txt("Sort By", size: 18.sp, font: Font.semiBold),
              SizedBox(height: 20.h),

              if (type == "start") ...[
                _sortTile(context, "Earliest Start Time", () {
                  Navigator.pop(context);
                  context.read<TaskProvider>().sortByStartTime();
                }),
              ],

              if (type == "end") ...[
                _sortTile(context, "Earliest End Time", () {
                  Navigator.pop(context);
                  context.read<TaskProvider>().sortByEndTime();
                }),
              ],

              _sortTile(context, "By Date", () {
                Navigator.pop(context);
                context.read<TaskProvider>().sortByDate();
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _sortTile(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Txt(title, size: 15.sp),
      onTap: onTap,
    );
  }
}

// PERFECT DIAGONAL BLUR CARD — This is the one you wanted!
class TaskCardWithDiagonalBlur extends StatelessWidget {
  final String startdate;
  final String enddate;
  final String description;
  final String day;

  const TaskCardWithDiagonalBlur({
    super.key,
    required this.startdate,
    required this.enddate,
    required this.day,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              // ALL CONTENT — perfectly readable
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    // Thin line
                    Container(
                      height: 0.6,
                      color: const Color(0xFF8F8F8F).withOpacity(0.5),
                    ),
                    SizedBox(height: 12.h),
                    // Main text
                    Flexible(
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.5,
                          color: Colors.black87,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // Colors.transparent, // top-left = no blur
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(0.95),
                        Colors.white.withOpacity(1), // bottom-right = max blur
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: '$day : ',
                                // style: TextWeight.bold,
                              ),
                              TextSpan(
                                text: '$startdate-$enddate',
                                style: const TextStyle(
                                  color: Color(0xFF8F8F8F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(AppIcons.edit, height: 22.r, width: 22.r),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
