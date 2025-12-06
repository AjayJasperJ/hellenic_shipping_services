import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/core/utils/api_services.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/models/tasklist_model.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/providers/entries_provider.dart';
import 'package:hellenic_shipping_services/providers/task_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_scafold.dart';
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
  // Focus nodes for form fields
  late FocusNode _jobIdFocusNode;
  late FocusNode _shipNameFocusNode;
  late FocusNode _locationFocusNode;
  late FocusNode _descriptionFocusNode;

  // Note: createtask() and updatetasklist() logic inlined at call sites and
  // removed to avoid duplication and to ensure request factories don't use
  // stale BuildContext across async gaps.

  Future<void> registerentry() async {
    final taskProvider = context.read<TaskProvider>();

    if (!_validateEntry(context)) return;

    // Prepare request closure capturing required providers/values
    final entriesProvider = context.read<EntriesProvider>();
    final isAdmin = context.read<AuthProvider>().employeeInfo?.category == 'A';
    final start = startTime.value!;
    final end = endTime.value!;
    final jobId = _jobIdCont.text;
    final description = _descriptionCont.text;
    final shipNum = _shipNameCont.text;
    final location = _locationCont.text;
    final driv = isDrive.value.toString();
    final holiday = isHolidayWorked.value.toString();
    final localSite = isLocalSite.value.toString();
    final offStation = isOffStation.value.toString();

    Future<StatusResponse> request() => entriesProvider.postEnteries(
      isAdmin,
      startTime: start,
      endTime: end,
      status: 'on_duty',
      jobId: jobId,
      description: description,
      shipNum: shipNum,
      location: location,
      driv: driv,
      holiday: holiday,
      localSite: localSite,
      offStation: offStation,
    );

    await _executeAndRefresh(request, taskProvider: taskProvider);
  }

  Future<void> editcontent() async {
    final taskProvider = context.read<TaskProvider>();
    if (!_validateEntry(context)) return;
    final taskProviderForEdit = context.read<TaskProvider>();
    final isAdmin = context.read<AuthProvider>().employeeInfo?.category == 'A';
    final taskId = widget.dutyitem!.id;
    final description = _descriptionCont.text;
    final start = startTime.value;
    final end = endTime.value;
    final jobId = _jobIdCont.text;
    final shipNum = _shipNameCont.text;
    final location = _locationCont.text;
    final driv = isDrive.value.toString();
    final holiday = isHolidayWorked.value.toString();
    final localSite = isLocalSite.value.toString();
    final offStation = isOffStation.value.toString();
    Future<StatusResponse> request() => taskProviderForEdit.edittaskdata(
      taskId,
      isAdmin,
      description: description,
      startTime: start!,
      endTime: end!,
      driv: driv,
      jobId: jobId,
      location: location,
      shipNum: shipNum,
      status: 'on_duty',
      holiday: holiday,
      localSite: localSite,
      offStation: offStation,
    );
    await _executeAndRefresh(request, taskProvider: taskProvider);
  }

  Future<void> _executeAndRefresh(
    Future<StatusResponse> Function() request, {
    required TaskProvider taskProvider,
  }) async {
    openDialog(context);
    final response = await ApiService.apiRequest(context, request);
    if (!mounted) return;
    ApiService.apiServiceStatus(context, response, (data) async {
      if (data == 'success') {
        final taskListResponse = await ApiService.apiRequest(
          context,
          () => taskProvider.getTaskList(),
        );
        if (!mounted) return;
        ApiService.apiServiceStatus(context, taskListResponse, (data) {
          if (data == 'success') {
            RouteNavigator.removeUntil(AppRoutes.nav, (route) => false);
          }
        }, disableSuccessToast: true);
      }
    }, disableSuccessToast: true);
    if (mounted) closeDialog(context);
  }

  @override
  void initState() {
    _jobIdFocusNode = FocusNode();
    _shipNameFocusNode = FocusNode();
    _locationFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    if (widget.dutyitem != null) {
      startTime.value = Helper.stringToTimeOfDay(widget.dutyitem!.startTime);
      endTime.value = Helper.stringToTimeOfDay(widget.dutyitem!.endTime);
      _jobIdCont.text = widget.dutyitem!.jobNo;
      _shipNameCont.text = widget.dutyitem!.shipName;
      _locationCont.text = widget.dutyitem!.location;
      _descriptionCont.text = widget.dutyitem!.description;
      isHolidayWorked.value = bool.parse(widget.dutyitem!.holidayWorked);
      isOffStation.value = bool.parse(widget.dutyitem!.offStation);
      isLocalSite.value = bool.parse(widget.dutyitem!.localSite);
      isDrive.value = bool.parse(widget.dutyitem!.driv);
    }
    super.initState();
  }

  @override
  void dispose() {
    _jobIdFocusNode.dispose();
    _shipNameFocusNode.dispose();
    _locationFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _jobIdCont.dispose();
    _shipNameCont.dispose();
    _locationCont.dispose();
    _descriptionCont.dispose();
    super.dispose();
  }

  bool fieldvalidation(bool isadmin) {
    if (!isadmin) {
      return (_descriptionCont.text.isEmpty);
    } else {
      return (_descriptionCont.text.isEmpty ||
          _jobIdCont.text.isEmpty ||
          _shipNameCont.text.isEmpty ||
          _locationCont.text.isEmpty);
    }
  }

  bool _validateEntry(BuildContext context) {
    if (startTime.value == null) {
      if (mounted) {
        ToastManager.showSingle(context, title: 'Start time not selected');
      }
      return false;
    }
    if (endTime.value == null) {
      if (mounted) {
        ToastManager.showSingle(context, title: 'End time not selected');
      }
      return false;
    }
    if (fieldvalidation(
      context.read<AuthProvider>().employeeInfo?.category == 'A',
    )) {
      if (mounted) {
        ToastManager.showSingle(context, title: 'Fields Should not be Empty');
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScafold(
      enablecloseButton: true,
      children: [
        SliverToBoxAdapter(child: SizedBox(height: 30.h)),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildTimeField('Start Time', startTime)),
                  SizedBox(width: 10.w),
                  Expanded(child: _buildTimeField('End Time', endTime)),
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
                              child: Txtfield(
                                controller: _jobIdCont,
                                focusNode: _jobIdFocusNode,
                                nextFocusNode: _shipNameFocusNode,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomBoarderedField(
                              label: 'Ship Name',
                              child: Txtfield(
                                controller: _shipNameCont,
                                focusNode: _shipNameFocusNode,
                                nextFocusNode: _locationFocusNode,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomBoarderedField(
                              label: 'Location',
                              child: Txtfield(
                                controller: _locationCont,
                                focusNode: _locationFocusNode,
                                nextFocusNode: _descriptionFocusNode,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),

              SizedBox(height: 20.h),
              CustomBoarderedField(
                label: 'Remarks',
                child: Txtfield(
                  controller: _descriptionCont,
                  focusNode: _descriptionFocusNode,
                  minLines: 4,
                  maxLines: 10,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Selector<AuthProvider, EmployeeInfo?>(
            selector: (_, p) => p.employeeInfo,
            builder: (_, value, __) {
              return (value?.category == 'A')
                  ? Column(
                      children: [
                        _checkboxItem('Holiday worked', isHolidayWorked),
                        SizedBox(height: 20.h),
                        _checkboxItem('Off Station', isOffStation),
                        SizedBox(height: 20.h),
                        _checkboxItem('Local site', isLocalSite),
                        SizedBox(height: 20.h),
                        _checkboxItem('Driv', isDrive),
                        SizedBox(height: 20.h),
                      ],
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 56.h,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (widget.dutyitem != null) {
                  await editcontent();
                } else {
                  await registerentry();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.appPrimary),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              child: Txt('Save', color: AppColors.appBackground),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: Dimen.h25)),
      ],
    );
  }

  // ---------- REUSABLE CHECKBOX WIDGET ----------
  Widget _checkboxItem(String title, ValueNotifier<bool> listenable) {
    return SizedBox(
      height: 50,
      child: ValueListenableBuilder<bool>(
        valueListenable: listenable,
        builder: (_, value, __) {
          return Container(
            decoration: BoxDecoration(
              border: GradientBoxBorder(gradient: AppColors.appTextfield),
              borderRadius: BorderRadius.circular(Dimen.r5),
            ),
            padding: EdgeInsets.symmetric(horizontal: Dimen.w20),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Txt(title, size: Dimen.s16),
                  Checkbox(
                    value: value,
                    onChanged: (v) => listenable.value = v!,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeField(String label, ValueNotifier<TimeOfDay?> timeNotifier) {
    return CustomBoarderedField(
      label: label,
      child: SizedBox(
        height: 50.h,
        child: ValueListenableBuilder<TimeOfDay?>(
          valueListenable: timeNotifier,
          builder: (_, time, __) {
            final display = time == null ? '' : time.format(context);
            return InkWell(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: time ?? TimeOfDay.now(),
                );
                if (picked != null) timeNotifier.value = picked;
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
    );
  }
}
