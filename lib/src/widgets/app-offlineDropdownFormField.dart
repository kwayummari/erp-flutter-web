import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppDropdownTextFormField extends StatelessWidget {
  final String labelText;
  final List<String> options;
  final String value;
  final Color? fillcolor;
  final double? circle;
  final labelWeight;
  final Color? textsColor;
  final Icon? icon;
  final IconButton? suffixicon;
  final Color? dropdownColor;
  final void Function(String?)? onChanged;

  AppDropdownTextFormField({
    required this.fillcolor,
    required this.labelText,
    required this.options,
    required this.value,
    required this.onChanged,
    required this.dropdownColor,
    this.circle,
    this.labelWeight,
    this.textsColor,
    this.icon,
    this.suffixicon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InputDecorator(
        decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(circle ?? 5.0),
                  ),
                  label: Container(
                    color: fillcolor,
                    child: AppText(
                      txt: labelText,
                      size: 15,
                      weight: labelWeight ?? FontWeight.w700,
                      color: textsColor ?? AppConst.white,
                    ),
                  ),
                  filled: true,
                  fillColor: fillcolor,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(circle ?? 5.0),
                    borderSide: BorderSide(color: AppConst.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(circle ?? 5.0),
                    borderSide: BorderSide(color: AppConst.black),
                  ),
                  prefixIcon: icon,
                  suffixIcon: suffixicon,
                ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: AppConst.white,
            value: value,
            hint: AppText(
              txt: labelText,
              color: AppConst.black,
              size: 15,
            ),
            isDense: true,
            onChanged: onChanged,
            items: [
              ...options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: AppText(
                    txt: option,
                    size: 15,
                    color: AppConst.black,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
