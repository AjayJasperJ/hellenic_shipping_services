import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';

import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/redesigned_model/leave_model.dart';
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
  final ValueNotifier<DateTime?> startDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<DateTime?> endDate = ValueNotifier<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<LeaveProvider>().getleavelist(),
      child: CustomScafold(
        children: [
          SliverToBoxAdapter(child: SizedBox(height: Dimen.h20)),
          Consumer<LeaveProvider>(
            builder: (context, value, child) {
              final data = value.listleavetype?.items;
              if (value.leaveListState.isLoading) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
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
                        Helper.twoDigits(
                          int.parse(data?[index].remaining ?? '0'),
                        ),
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
                          data?[index].leaveType ?? '',
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
            child: Consumer<LeaveProvider>(
              builder: (context, value, child) => Column(
                children: [
                  SizedBox(height: 30.h),
                  CustomBoarderedField(
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
                  SizedBox(height: 20.h),
                  if (value.leaveitem != null &&
                      value.leaveitem?.leaveType == 'annual')
                    Row(
                      children: [
                        Expanded(
                          child: BuildDateField(
                            label: 'Start Date',
                            timeNotifier: startDate,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: BuildDateField(
                            label: 'End Date',
                            timeNotifier: endDate,
                          ),
                        ),
                      ],
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
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: startDate,
                    builder: (context, start, child) {
                      return ValueListenableBuilder<DateTime?>(
                        valueListenable: endDate,
                        builder: (context, end, child) {
                          return ApplyLeaveButton(
                            reasonController: _reasonController,
                            endDate: end,
                            startDate: start,
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildDateField extends StatelessWidget {
  final String label;
  final ValueNotifier<DateTime?> timeNotifier;
  const BuildDateField({
    super.key,
    required this.label,
    required this.timeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBoarderedField(
      label: label,
      child: SizedBox(
        height: 50.h,
        child: ValueListenableBuilder<DateTime?>(
          valueListenable: timeNotifier,
          builder: (_, time, __) {
            return InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: time ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2050),
                );
                if (picked != null) timeNotifier.value = picked;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                alignment: Alignment.center,
                child: Text(
                  time == null ? '' : Helper.formatDate(time),
                  style: TextStyle(
                    color: AppColors.appPrimary,
                    fontSize: 20.sp,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
