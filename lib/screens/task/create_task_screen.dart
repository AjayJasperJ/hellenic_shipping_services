import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/tasklist_model.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_textfield.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:hellenic_shipping_services/screens/widget/other_widgets.dart';
import 'package:provider/provider.dart';

class CreateTaskScreen extends StatefulWidget {
  final DutyItem? dutyitem;
  const CreateTaskScreen({super.key, this.dutyitem});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final ValueNotifier<TimeOfDay?> startTime = ValueNotifier<TimeOfDay?>(null);
  final ValueNotifier<TimeOfDay?> endTime = ValueNotifier<TimeOfDay?>(null);
  final TextEditingController _jobIdCont = TextEditingController();
  final TextEditingController _shipNameCont = TextEditingController();
  final TextEditingController _locationCont = TextEditingController();
  final TextEditingController _descriptionCont = TextEditingController();

  Future<void> registerentry() async {
    openDialog(context);
    if (startTime.value == null) {
      ToastManager.showSingle(context, title: 'Start time not selected');
    } else if (endTime.value == null) {
      ToastManager.showSingle(context, title: 'End time not selected');
    } else {
      final StatusResponse response = await context
          .read<EntriesProvider>()
          .postEnteries(
            startTime: startTime.value!,
            endTime: endTime.value!,
            status: 'on_duty',
            jobId: _jobIdCont.text,
            description: _descriptionCont.text,
            shipNum: _shipNameCont.text,
            location: _locationCont.text,
          );
      if (response.status == 'token_expaired') {
        await ApiService().authguard(401);
        await context.read<EntriesProvider>().postEnteries(
          startTime: startTime.value!,
          endTime: endTime.value!,
          status: 'on_duty',
          jobId: _jobIdCont.text,
          description: _descriptionCont.text,
          shipNum: _shipNameCont.text,
          location: _locationCont.text,
        );
      }
    }
    final response2 = await context.read<TaskProvider>().getTaskList();
    if (response2.status == 'token_expaired') {
      await ApiService().authguard(401);
      if (mounted) {
        await context.read<TaskProvider>().getTaskList();
      }
    }
    closeDialog(context);
  }

  Future<void> editcontent() async {
    openDialog(context);
    final StatusResponse response = await context
        .read<TaskProvider>()
        .edittaskdata(
          widget.dutyitem!.id,
          description: widget.dutyitem!.description,
          startTime: widget.dutyitem!.startTime,
          endTime: widget.dutyitem!.endTime,
        );
    if (response.status == 'token_expaired') {
      await ApiService().authguard(401);
      await context.read<TaskProvider>().edittaskdata(
        widget.dutyitem!.id,
        description: widget.dutyitem!.description,
        startTime: widget.dutyitem!.startTime,
        endTime: widget.dutyitem!.endTime,
      );
    }
    final response2 = await context.read<TaskProvider>().getTaskList();
    if (response2.status == 'token_expaired') {
      await ApiService().authguard(401);
      if (mounted) {
        await context.read<TaskProvider>().getTaskList();
      }
    }
    closeDialog(context);
  }

  @override
  void initState() {
    if (widget.dutyitem != null) {
      startTime.value = Helper.stringToTimeOfDay(widget.dutyitem!.startTime);
      endTime.value = Helper.stringToTimeOfDay(widget.dutyitem!.endTime);
      _jobIdCont.text = widget.dutyitem!.jobNo;
      _shipNameCont.text = widget.dutyitem!.shipName;
      _locationCont.text = widget.dutyitem!.location;
      _descriptionCont.text = widget.dutyitem!.description;
    }
    super.initState();
  }

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
            SizedBox(height: 60.h),
            Row(
              children: [
                Expanded(
                  child: CustomBoarderedField(
                    label: 'Start Time',
                    child: SizedBox(
                      height: 50.h,
                      child: ValueListenableBuilder<TimeOfDay?>(
                        valueListenable: startTime,
                        builder: (context, time, _) {
                          final display = time == null
                              ? ''
                              : time.format(context);
                          return GestureDetector(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: time ?? TimeOfDay.now(),
                              );
                              if (picked != null) startTime.value = picked;
                            },
                            child: Container(
                              color: AppColors.appBackground.withValues(
                                alpha: .0,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 22.w),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  display,
                                  style: TextStyle(
                                    color: AppColors.appPrimary,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                          // return TextButton.icon(
                          //   onPressed:
                          // label:
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomBoarderedField(
                    label: 'End Time',
                    child: SizedBox(
                      height: 50.h,
                      child: ValueListenableBuilder<TimeOfDay?>(
                        valueListenable: endTime,
                        builder: (context, time, _) {
                          final display = time == null
                              ? ''
                              : time.format(context);
                          return GestureDetector(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: time ?? TimeOfDay.now(),
                              );
                              if (picked != null) endTime.value = picked;
                            },
                            child: Container(
                              color: AppColors.appBackground.withValues(
                                alpha: .0,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 22.w),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  display,
                                  style: TextStyle(
                                    color: AppColors.appPrimary,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                          // return TextButton.icon(
                          //   onPressed:
                          // label:
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            CustomBoarderedField(
              label: 'Job ID',
              child: Txtfield(controller: _jobIdCont),
            ),
            SizedBox(height: 20.h),
            CustomBoarderedField(
              label: 'Ship Name',
              child: Txtfield(controller: _shipNameCont),
            ),
            SizedBox(height: 20.h),
            CustomBoarderedField(
              label: 'Location',
              child: Txtfield(controller: _locationCont),
            ),
            SizedBox(height: 20.h),
            CustomBoarderedField(
              label: 'Remarks',
              child: Txtfield(maxLines: 4, controller: _descriptionCont),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 56.h,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (widget.dutyitem != null) {
                    await editcontent();
                  } else {
                    await registerentry();
                  }

                  RouteNavigator.pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.appPrimary),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10.r),
                    ),
                  ),
                ),
                child: Txt('Save', color: AppColors.appBackground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
