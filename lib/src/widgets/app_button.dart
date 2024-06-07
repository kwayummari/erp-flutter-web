import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function onPress;
  final String label;
  final double borderRadius;
  final Color textColor;
  final Color? solidColor;
  final Gradient? gradient;
  final Color? borderColor;

  const AppButton({
    Key? key,
    required this.onPress,
    required this.label,
    required this.borderRadius,
    required this.textColor,
    this.solidColor,
    this.gradient,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: solidColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
        onPressed: () => onPress(),
        child: AppText(
          txt: label,
          color: textColor,
          size: 15,
        ),
      ),
    );
  }
}
