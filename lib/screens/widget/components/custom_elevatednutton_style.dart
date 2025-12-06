import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

customEvelatedButtonStyle(Color? backgroundColor) {
  return ElevatedButton.styleFrom(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
  );
}
