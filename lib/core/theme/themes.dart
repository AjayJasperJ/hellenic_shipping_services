import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';

class AppThemes {
  AppThemes._();

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.appPrimary,
      surface: AppColors.appBackground,
      onSurface: AppColors.appPrimary,
      onPrimary: AppColors.white,
    ),
    useMaterial3: true,
    // fontFamily: "GeneralSans",
  );
}
