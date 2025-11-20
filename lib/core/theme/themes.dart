import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.appPrimary,
      surface: AppColors.appBackground,
      onSurface: AppColors.appPrimary,
      onPrimary: Colors.white,
    ),
    useMaterial3: true,
    fontFamily: "GeneralSans",
  );
}
