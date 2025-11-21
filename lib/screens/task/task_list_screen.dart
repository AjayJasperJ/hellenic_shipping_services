import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30.r),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Image.asset(AppImages.appLogo, height: 77.r, width: 77.r),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Txt(
                            'Hello Vignesh!',
                            size: 21.sp,
                            font: Font.semiBold,
                            height: 0.2,
                          ),
                          SizedBox(height: 16.h),
                          Txt('Friday 20 Aug, 2025', size: 14.sp),
                        ],
                      ),
                      SizedBox(
                        height: 41.h,
                        width: 129.w,
                        child: ElevatedButton(
                          onPressed: () {},
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
                      Txt("All", size: 14.sp),
                      Txt("Start Date", size: 14.sp),
                      Txt("End Date", size: 14.sp),
                    ],
                  ),
                ],
              ),
            ),
            ListView.separated(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 30.w),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Txt(
                  """Manage daily client requests and ensure smooth project delivery.Collaborate with internal teams to address requirements efficiently and maintain clear communication throughout each phase.Monitor ongoing projects to identify potential challenges early and implement effective solutions.""",
                  size: 14.sp,
                  align: TextAlign.start,
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 20.h),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
