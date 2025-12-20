import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';

import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_scafold.dart';
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
    return RefreshIndicator(
      onRefresh: () async => await context.read<TaskProvider>().getTaskList(),
      child: CustomScafold(
        enableaddButton: true,
        onadd: () {
          RouteNavigator.pushRouted(AppRoutes.createTask);
        },
        children: [
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30.h,
                  width: .5,
                  color: AppColors.appPrimary.withValues(alpha: .2),
                ),

                // ALL
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.read<TaskProvider>().resetSort(),
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    height: 30.h,
                    child: Center(
                      child: Txt("All", size: 14.sp, font: Font.semiBold),
                    ),
                  ),
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
                      behavior: HitTestBehavior.opaque,
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
                          Container(
                            color: Theme.of(context).colorScheme.surface,
                            height: 30.h,
                            child: Center(
                              child: Txt(
                                p.selectedStartDate == null
                                    ? "Start Date"
                                    : "${p.selectedStartDate!.day}/${p.selectedStartDate!.month}/${p.selectedStartDate!.year}",
                                size: 14.sp,
                                font: Font.semiBold,
                              ),
                            ),
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
                      behavior: HitTestBehavior.opaque,
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
                          Container(
                            color: Theme.of(context).colorScheme.surface,
                            height: 30.h,
                            child: Center(
                              child: Txt(
                                p.selectedEndDate == null
                                    ? "End Date"
                                    : "${p.selectedEndDate!.day}/${p.selectedEndDate!.month}/${p.selectedEndDate!.year}",
                                size: 14.sp,
                                font: Font.semiBold,
                              ),
                            ),
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
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          Consumer<TaskProvider>(
            builder: (context, value, child) {
              if (value.tasklist.isEmpty) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150.h,
                    child: Center(
                      child: Txt(
                        'No records found !',
                        size: 16.sp,
                        font: Font.semiBold,
                      ),
                    ),
                  ),
                );
              } else {
                return SliverList.separated(
                  itemCount: value.tasklist.length,
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
                      child: TaskCardWithDiagonalBlur(
                        day: current.day,
                        startdate: current.startTime,
                        enddate: current.endTime,
                        description: current.description,
                      ),
                    );
                  },
                );
              }
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: Dimen.h25)),
        ],
      ),
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
              color: Colors.grey.withValues(alpha: 0.12),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    // Thin line
                    Container(
                      height: 0.6,
                      color: const Color(0xFF8F8F8F).withValues(alpha: .5),
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
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: .95),
                        Colors.white.withValues(
                          alpha: 1,
                        ), // bottom-right = max blur
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
