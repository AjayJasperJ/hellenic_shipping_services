import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/models/leave_model.dart';
import 'package:hellenic_shipping_services/providers/leave_provider.dart';
import 'package:hellenic_shipping_services/screens/tasks/widgets/apply_leave_button.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_scafold.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_textfield.dart';
import 'package:hellenic_shipping_services/screens/widget/default_dropdown.dart';
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
    return CustomScafold(
      children: [
        SliverToBoxAdapter(child: SizedBox(height: Dimen.h20)),
        Consumer<LeaveProvider>(
          builder: (context, value, child) {
            final data = value.listleavetype?.items;
            if (value.leavelistloading) {
              return Center(child: CircularProgressIndicator());
            }
            if (data?.isEmpty ?? false) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 150.h,
                  child: Center(
                    child: Txt(
                      'Currently no leave assigned',
                      size: 16.sp,
                      font: Font.semiBold,
                    ),
                  ),
                ),
              );
            }
            return SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.w,
                crossAxisSpacing: 8.h,
                mainAxisExtent: 78.h,
              ),
              itemCount: data?.length ?? 0,
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
                      color: Colors.white.withValues(alpha: .15),
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
        SliverToBoxAdapter(
          child: Column(
            children: [
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
              Selector<LeaveProvider, List>(
                selector: (_, p) => p.listleavetype?.items ?? [],
                builder: (_, value, __) {
                  return CustomBoarderedField(
                    label: 'Reason for leave',
                    child: Txtfield(
                      minLines: 4,
                      readonly: value.isEmpty,
                      controller: _reasonController,
                    ),
                  );
                },
              ),
              SizedBox(height: 30.h),
              ApplyLeaveButton(reasonController: _reasonController),
            ],
          ),
        ),
      ],
    );
  }
}
