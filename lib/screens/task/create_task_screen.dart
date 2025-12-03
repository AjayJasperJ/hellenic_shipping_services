import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/constants/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/models/tasklist_model.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
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

  // NEW CHECKBOX VALUE NOTIFIERS
  final ValueNotifier<bool> isHolidayWorked = ValueNotifier(false);
  final ValueNotifier<bool> isOffStation = ValueNotifier(false);
  final ValueNotifier<bool> isLocalSite = ValueNotifier(false);
  final ValueNotifier<bool> isDrive = ValueNotifier(false);

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
            context.read<AuthProvider>().employeeInfo?.category == 'A',
            startTime: startTime.value!,
            endTime: endTime.value!,
            status: 'on_duty',
            jobId: _jobIdCont.text,
            description: _descriptionCont.text,
            shipNum: _shipNameCont.text,
            location: _locationCont.text,
            driv: isDrive.value.toString(),
            holiday: isHolidayWorked.value.toString(),
            localSite: isLocalSite.value.toString(),
            offStation: isOffStation.value.toString(),
          );

      if (response.status == 'token_expaired') {
        await ApiService().authguard(401);
        await context.read<EntriesProvider>().postEnteries(
          context.read<AuthProvider>().employeeInfo?.category == 'A',
          startTime: startTime.value!,
          endTime: endTime.value!,
          status: 'on_duty',
          jobId: _jobIdCont.text,
          description: _descriptionCont.text,
          shipNum: _shipNameCont.text,
          location: _locationCont.text,
          driv: isDrive.value.toString(),
          holiday: isHolidayWorked.value.toString(),
          localSite: isLocalSite.value.toString(),
          offStation: isOffStation.value.toString(),
        );
      }
    }

    final response2 = await context.read<TaskProvider>().getTaskList();
    if (response2.status == 'token_expaired') {
      await ApiService().authguard(401);
      if (mounted) await context.read<TaskProvider>().getTaskList();
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
      if (mounted) await context.read<TaskProvider>().getTaskList();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 26.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(AppImages.appLogo, height: 85.r, width: 85.r),
                  GestureDetector(
                    onTap: () => RouteNavigator.pop(),
                    child: Container(
                      height: Dimen.r55,
                      width: Dimen.r55,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.appSecondaryContainer,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21.h),

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
              SizedBox(height: 60.h),

              // START + END TIME FIELDS
              Row(
                children: [
                  Expanded(
                    child: CustomBoarderedField(
                      label: 'Start Time',
                      child: SizedBox(
                        height: 50.h,
                        child: ValueListenableBuilder<TimeOfDay?>(
                          valueListenable: startTime,
                          builder: (_, time, __) {
                            final display = time == null
                                ? ''
                                : time.format(context);
                            return InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: time ?? TimeOfDay.now(),
                                );
                                if (picked != null) startTime.value = picked;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                alignment: Alignment.center,
                                child: Text(
                                  display,
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
                          builder: (_, time, __) {
                            final display = time == null
                                ? ''
                                : time.format(context);
                            return InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: time ?? TimeOfDay.now(),
                                );
                                if (picked != null) endTime.value = picked;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 22.w),
                                alignment: Alignment.center,
                                child: Text(
                                  display,
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
                    ),
                  ),
                ],
              ),

              // JOB FIELDS FOR CATEGORY A
              Selector<AuthProvider, EmployeeInfo?>(
                selector: (_, p) => p.employeeInfo,
                builder: (_, value, __) {
                  return (value?.category == 'A')
                      ? Column(
                          children: [
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
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),

              SizedBox(height: 20.h),
              CustomBoarderedField(
                label: 'Remarks',
                child: Txtfield(maxLines: 4, controller: _descriptionCont),
              ),

              SizedBox(height: 20.h),

              // CHECKBOXES (UPDATED WITH VALUENOTIFIER)
              _checkboxItem('Holiday worked', isHolidayWorked),
              _checkboxItem('Off Station', isOffStation),
              _checkboxItem('Local site', isLocalSite),
              _checkboxItem('Driv', isDrive),

              SizedBox(height: Dimen.h20),

              // SAVE BUTTON
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
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.appPrimary,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                  child: Txt('Save', color: AppColors.appBackground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- REUSABLE CHECKBOX WIDGET ----------
  Widget _checkboxItem(String title, ValueNotifier<bool> listenable) {
    return SizedBox(
      height: 50,
      child: ValueListenableBuilder<bool>(
        valueListenable: listenable,
        builder: (_, value, __) {
          return Center(
            child: Row(
              children: [
                Checkbox(value: value, onChanged: (v) => listenable.value = v!),
                Txt(title, size: Dimen.s16),
              ],
            ),
          );
        },
      ),
    );
  }
}
