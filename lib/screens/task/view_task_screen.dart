import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/tasklist_model.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:provider/provider.dart';

class ViewTaskScreen extends StatefulWidget {
  final DutyItem item;
  final String date;
  final String startTime;
  final String endTime;
  final String description;
  final String taskID;

  const ViewTaskScreen({
    super.key,
    required this.item,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.taskID,
    required this.date,
  });

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  Future deletetask() async {
    openDialog(context);
    final response = await context.read<TaskProvider>().deletetaskdata(
      widget.item.id,
    );
    if (response.status == 'token_expaired') {
      await ApiService().authguard(401);
      if (!mounted) return;
      await context.read<TaskProvider>().deletetaskdata(widget.item.id);
    }
    if (!mounted) return;
    final response2 = await context.read<TaskProvider>().getTaskList();
    if (response2.status == 'token_expaired') {
      await ApiService().authguard(401);
      if (!mounted) return;
      await context.read<TaskProvider>().getTaskList();
    }
    RouteNavigator.pop();
    if (!mounted) return;
    closeDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    final outputs = Helper.generateStartEndOutputs(
      startDate: widget.date,
      startTime: widget.startTime,
      endTime: widget.endTime,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Center(
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50.h),
                          Image.asset(
                            AppImages.appLogo,
                            height: 77.r,
                            width: 77.r,
                          ),
                          SizedBox(height: 20.h),
                          Txt('Task History', size: 21.sp, font: Font.semiBold),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          RouteNavigator.pop();
                        },
                        child: Container(
                          height: Dimen.r55,
                          width: Dimen.r55,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.appSecondaryContainer,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: Font.bold.weight,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Start Time : ',
                      style: TextStyle(color: Color.fromARGB(255, 69, 134, 63)),
                    ),
                    TextSpan(
                      text: outputs["startOutput"],
                      // style: TextStyle(color: ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: Font.bold.weight,
                  ),
                  children: [
                    TextSpan(
                      text: 'End Time : ',
                      style: TextStyle(color: Color.fromARGB(255, 160, 58, 58)),
                    ),
                    TextSpan(
                      text: outputs["endOutput"],
                      // style: TextStyle(color: ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 19.w,
                      vertical: 30.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),

                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.center,
                          colors: [AppColors.appPrimary, AppColors.appPrimary],
                        ),
                        width: 1,
                      ),
                    ),
                    child: Txt(
                      widget.description,
                      size: 16.sp,
                      max: 10,
                      font: Font.medium,
                    ),
                  ),
                  Positioned(
                    left: 25,

                    top: -8.h,

                    child: Center(
                      child: Container(
                        color: AppColors.appBackground,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Txt(
                          'About the task',
                          height: 0,
                          color: Color.fromARGB(255, 69, 134, 63),
                          size: 12.sp,
                          font: Font.regular,
                          space: 0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 56.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          RouteNavigator.pushRouted(
                            AppRoutes.createTask,
                            arguments: {'dutyitem': widget.item},
                          );
                        },
                        style: customEvelatedButtonStyle(Colors.blueGrey),
                        child: Txt(
                          'Edit',
                          size: 16.sp,
                          color: AppColors.appBackground,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Flexible(
                    child: SizedBox(
                      height: 56.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => deletetask(),
                        style: customEvelatedButtonStyle(
                          Color.fromARGB(255, 160, 58, 58),
                        ),
                        child: Txt(
                          'Delete',
                          size: 16.sp,
                          color: AppColors.appBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
