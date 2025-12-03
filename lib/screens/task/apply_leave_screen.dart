import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/leave_model.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_textfield.dart';
import 'package:hellenic_shipping_services/screens/widget/default_dropdown.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:provider/provider.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 26.h),
            Image.asset(AppImages.appLogo, height: 85.r, width: 85.r),
            SizedBox(height: 21.h),
            Txt(
              'Hello Vignesh!',
              size: 21.sp,
              font: Font.semiBold,
              height: 0.2,
            ),
            SizedBox(height: 16.h),
            Txt('Friday 20 Aug, 2025', size: 14.sp),
            SizedBox(height: 79.h),
            Consumer<LeaveProvider>(
              builder: (context, value, child) {
                final data = value.listleavetype?.items;
                if (value.leavelistloading) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.w,
                    crossAxisSpacing: 8.h,
                    mainAxisExtent: 78.h,
                  ),
                  itemCount: data?.length ?? 0,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),

                  itemBuilder: (context, index) => Stack(
                    // clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.appSecondaryContainer,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        right: 0,
                        child: Txt(
                          "0${data![index].remaining}",
                          size: 57.sp,
                          font: Font.semiBold,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: Txt(
                            data[index].leaveType,
                            size: 12.sp,
                            font: Font.regular,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 30.h),
            Consumer<LeaveProvider>(
              builder: (context, value, child) => CustomBoarderedField(
                label: 'Select Type of Leave',
                child: DefaultDropdown<LeaveItem>(
                  items: value.listleavetype?.items ?? [],
                  hint: value.leaveitem?.leaveType ?? "",
                  onChanged: (data) {
                    value.updateleave(data);
                  },
                  itemLabel: (item) => item.leaveType,
                ),
              ),
            ),

            SizedBox(height: 20.h),
            CustomBoarderedField(
              label: 'Reason for leave',
              child: Txtfield(maxLines: 4),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              height: 56.h,
              width: double.infinity,
              child: Consumer<LeaveProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      openDialog(context);
                      final result = await context
                          .read<EntriesProvider>()
                          .applyleave(
                            status: 'leave',
                            leaveType: value.leaveitem?.leaveType ?? '',
                            leaveReason: _reasonController.text,
                          );
                      if (result.status == 'token_expaired') {
                        await ApiService().authguard(401);
                        await context.read<EntriesProvider>().applyleave(
                          status: 'leave',
                          leaveType: value.leaveitem?.leaveType ?? '',
                          leaveReason: _reasonController.text,
                        );
                      }
                      closeDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.appPrimary,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10.r),
                        ),
                      ),
                    ),
                    child: Txt('Apply Leave', color: AppColors.appBackground),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
