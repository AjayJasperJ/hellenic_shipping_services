import 'package:flutter/material.dart';

class AppColors {
  static const LinearGradient appBackground = LinearGradient(
    colors: [Color(0xFFFBFFF3), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient appTextfield = LinearGradient(
    colors: [Color(0xFFB19404), Color(0xFFFFBF00)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color appPrimary = Color(0xFF3B3B3B);
}
