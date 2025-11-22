import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/default_dropdown.dart';

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
                          Txt(
                            'Hello Vignesh!',
                            size: 21.sp,
                            font: Font.semiBold,
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
                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),
                      Txt("All", size: 14.sp, font: Font.semiBold),
                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Txt("Start Date", size: 14.sp),
                          SizedBox(width: 10.w),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      Container(
                        height: 30.h,
                        width: .5,
                        color: AppColors.appPrimary.withValues(alpha: .2),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Txt("End Date", size: 14.sp),
                          SizedBox(width: 10.w),
                          Icon(Icons.arrow_drop_down),
                        ],
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
            ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              itemCount: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (_, __) => GestureDetector(
                onTap: () {
                  RouteNavigator.pushRouted(AppRoutes.viewTask);
                },
                child: const RepaintBoundary(child: TaskCardWithDiagonalBlur()),
              ),
            ),

            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}

// PERFECT DIAGONAL BLUR CARD — This is the one you wanted!
class TaskCardWithDiagonalBlur extends StatelessWidget {
  const TaskCardWithDiagonalBlur({super.key});

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
                        "Track ongoing client needs,\nensure timely responses,\nand maintain smooth project flow.",
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

              // DIAGONAL INCREASING BLUR — This is the magic
              // IgnorePointer(
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(12.r),
              //     child: ShaderMask(
              //       shaderCallback: (Rect bounds) {
              //         return LinearGradient(
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter,
              //           colors: [
              //             // Colors.transparent, // top-left = no blur
              //             Colors.white.withOpacity(0),
              //             Colors.white.withOpacity(0.9),
              //             Colors.white.withOpacity(
              //               1,
              //             ), // bottom-right = max blur
              //           ],
              //         ).createShader(bounds);
              //       },
              //       blendMode: BlendMode
              //           .colorBurn, // keeps only blurred part where mask is white
              //       child: BackdropFilter(
              //         filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              //         child: Container(
              //           decoration: BoxDecoration(
              //             color: Colors.white.withOpacity(0.25),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
                            children: const [
                              TextSpan(
                                text: 'Today : ',
                                // style: TextWeight.bold,
                              ),
                              TextSpan(
                                text: '10:00AM - 5:30PM',
                                style: TextStyle(color: Color(0xFF8F8F8F)),
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
