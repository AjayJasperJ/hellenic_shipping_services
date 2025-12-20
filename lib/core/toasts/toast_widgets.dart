import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

class FieldValidation extends StatelessWidget {
  final String message;
  final IconData icon;
  const FieldValidation({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Dimen.h70,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(Dimen.r15),
          border: GradientBoxBorder(gradient: AppColors.appTextfield),
        ),
        margin: EdgeInsets.symmetric(horizontal: Dimen.w20),
        padding: EdgeInsets.symmetric(horizontal: Dimen.w20),
        child: Row(
          children: [
            Icon(icon, color: AppColors.appSecondary),
            SizedBox(width: Dimen.w10),
            Txt(message, size: Dimen.s16),
          ],
        ),
      ),
    );
  }
}
