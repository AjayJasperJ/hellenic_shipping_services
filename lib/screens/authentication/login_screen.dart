import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/core/network/api_services/state_response.dart';
import 'package:hellenic_shipping_services/core/network/interceptors/cache_interceptor.dart';
import 'package:hellenic_shipping_services/core/network/interceptors/offline_sync_interceptor.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_manager.dart';
import 'package:hellenic_shipping_services/core/toasts/toast_widgets.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/routes/routes.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_boardered_field.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_textfield.dart';
import 'package:hellenic_shipping_services/screens/widget/loading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<TimeOfDay?> loginTime = ValueNotifier<TimeOfDay?>(null);
  final TextEditingController _identiferCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  final FocusNode _identiferFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (_identiferCont.text.trim().isEmpty) {
      ToastManager.showSingleCustom(
        child: FieldValidation(
          message: 'Username is required',
          icon: Icons.text_fields_rounded,
        ),
      );
      return;
    }
    if (_passwordCont.text.trim().isEmpty) {
      ToastManager.showSingleCustom(
        child: FieldValidation(
          message: 'Password is required',
          icon: Icons.key_off_rounded,
        ),
      );
      return;
    }
    if (loginTime.value == null) {
      ToastManager.showSingleCustom(
        child: FieldValidation(
          message: 'Login time not selected',
          icon: Icons.timer_sharp,
        ),
      );
      return;
    }

    openDialog(context);
    final StateResponse response = await context.read<AuthProvider>().loginuser(
      identifier: _identiferCont.text,
      password: _passwordCont.text,
    );
    if (!mounted) return;

    if (response.isSuccess) {
      if (loginTime.value != null) {
        final StateResponse response2 = await context
            .read<AuthProvider>()
            .attendanceuser(time: loginTime.value!);

        if (!mounted) return;
        closeDialog(context);

        if (response2.isSuccess) {
          await CacheInterceptor.reset();
          await OfflineSyncInterceptor.reset();
          RouteNavigator.pushReplacementRouted(AppRoutes.nav);
        } else {
          ToastManager.showSingleCustom(
            child: FieldValidation(
              message: response2.message,
              icon: Icons.error_outline_rounded,
            ),
          );
        }
      } else {
        closeDialog(context);
        ToastManager.showSingleCustom(
          child: FieldValidation(
            message: 'Login time not selected',
            icon: Icons.timer_sharp,
          ),
        );
      }
    } else {
      closeDialog(context);
      ToastManager.showSingleCustom(
        child: FieldValidation(
          message: response.message,
          icon: Icons.error_outline_rounded,
        ),
      );
    }
  }

  @override
  void dispose() {
    loginTime.dispose();
    _identiferFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Ensure the view scrolls when keyboard appears
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 100.h),
                        Center(
                          child: Image.asset(
                            AppImages.appLogo,
                            height: 120.r,
                            width: 120.r,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Txt(
                          'Hello There!',

                          size: 21.sp,
                          font: Font.semiBold,
                          space: 0.2,
                          height: 01,
                          align: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: width * .7,
                          child: Txt(
                            'Log in to your account\nusing  username or email address',
                            size: 16.sp,
                            font: Font.regular,
                            space: 0.2,
                            // height: 1.2,
                            align: TextAlign.start,
                          ),
                        ),
                        SizedBox(height: 21.h),
                        CustomBoarderedField(
                          label: "UserName",
                          child: Center(
                            child: Txtfield(
                              keyboardtype: TextInputType.emailAddress,
                              controller: _identiferCont,
                              focusNode: _identiferFocusNode,
                              nextFocusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        CustomBoarderedField(
                          label: "Password",
                          child: Center(
                            child: Txtfield(
                              keyboardtype: TextInputType.emailAddress,
                              controller: _passwordCont,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CustomBoarderedField(
                            width: width * .45,
                            label: "Login Time",
                            child: SizedBox(
                              height: 50.h,
                              child: ValueListenableBuilder<TimeOfDay?>(
                                valueListenable: loginTime,
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
                                      if (picked != null) {
                                        loginTime.value = picked;
                                      }
                                    },
                                    child: Container(
                                      color: AppColors.appBackground.withValues(
                                        alpha: .0,
                                      ),
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
                        SizedBox(height: 30.h),
                        SizedBox(
                          height: 56.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await login();
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                AppColors.appPrimary,
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10.r,
                                  ),
                                ),
                              ),
                            ),
                            child: Txt(
                              'Sign In',
                              color: AppColors.appBackground,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Txt(
                          'By tapping on next, you are agreeing to',
                          size: 12.sp,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Terms of Service ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.appSecondary,
                              decoration: TextDecoration.underline,
                            ),
                            children: [
                              TextSpan(
                                text: 'and ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.appPrimary,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.appSecondary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        SizedBox(height: Dimen.h20),
                        Center(
                          child: Txt(
                            'copyright 2025   Hellenic Shipping Services',
                            size: 10.sp,
                            font: Font.regular,
                            space: 0.2,
                            height: 0.18,
                            align: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 28.h),
                      ],
                    ), // Column
                  ), // Form
                ), // IntrinsicHeight
              ), // ConstrainedBox
            ); // SingleChildScrollView
          }, // LayoutBuilder builder
        ), // LayoutBuilder
      ), // Padding
    ); // Scaffold
  }
}
