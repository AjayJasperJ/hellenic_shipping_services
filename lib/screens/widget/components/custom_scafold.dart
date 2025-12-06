import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/core/utils/helper.dart';
import 'package:hellenic_shipping_services/core/constants/images.dart';
import 'package:hellenic_shipping_services/models/employee_detail.dart';
import 'package:hellenic_shipping_services/providers/auth_provider.dart';
import 'package:hellenic_shipping_services/routes/route_navigator.dart';
import 'package:hellenic_shipping_services/screens/widget/components/custom_elevatednutton_style.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';
import 'package:provider/provider.dart';

class CustomScafold extends StatelessWidget {
  final List<Widget>? children;
  final bool? enableaddButton;
  final bool? enablecloseButton;
  final VoidCallback? onadd;
  const CustomScafold({
    super.key,
    this.children,
    this.enableaddButton,
    this.onadd,
    this.enablecloseButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 30.h),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 26.h),
                  Row(
                    children: [
                      Image.asset(AppImages.appLogo, height: 85.r, width: 85.r),
                      Spacer(),
                      if (enablecloseButton ?? false)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Selector<AuthProvider, EmployeeInfo?>(
                              selector: (_, p) => p.employeeInfo,
                              builder: (_, value, __) {
                                return Txt(
                                  'Hello ${Helper.capitalizeFirstName(value?.username ?? '')}!',
                                  size: 21.sp,
                                  font: Font.semiBold,
                                );
                              },
                            ),
                            SizedBox(height: 5.h),
                            Txt(Helper.formatCurrentDate(), size: 14.sp),
                          ],
                        ),
                      ),
                      if (enableaddButton ?? false)
                        SizedBox(
                          height: 41.h,
                          child: ElevatedButton(
                            onPressed: onadd,
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
                ],
              ),
            ),
            if (children != null) ...children!,
          ],
        ),
      ),
    );
  }
}
