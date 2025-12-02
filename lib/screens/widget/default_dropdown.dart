import 'package:flutter/material.dart';
import 'package:hellenic_shipping_services/core/constants/colors.dart';
import 'package:hellenic_shipping_services/core/constants/dimensions.dart';
import 'package:hellenic_shipping_services/screens/widget/custom_text.dart';

class DefaultDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final ValueChanged<T> onChanged;
  final double? buttonHeight;
  final double? buttonWidth;
  final EdgeInsets? margin;

  final String Function(T item) itemLabel;

  const DefaultDropdown({
    super.key,
    this.value,
    this.margin,
    this.buttonHeight,
    this.buttonWidth,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.itemLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Disable hover + highlight + splash
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Container(
        height: buttonHeight,
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: Dimen.w8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimen.r99),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(Dimen.r10),
            value: value,
            hint: Txt(hint, size: Dimen.s14, font: Font.medium),
            isExpanded: true,
            enableFeedback: false,
            icon: Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: Dimen.r18,
            onChanged: (v) => onChanged(v as T),
            style: TextStyle(
              fontSize: Dimen.s14,
              fontWeight: Font.medium.weight,
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Center(
                      child: Txt(
                        itemLabel(item),
                        size: Dimen.s14,
                        font: Font.semiBold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
