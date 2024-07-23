// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  // final Widget child;
  final String? txt;
  final TextAlign? align;
  var color;
  var weight;
  double size;
  TextDecoration? textdecoration;
  final bool? softWrap;
  FontStyle? fontStyle;
  AppText(
      {Key? key,
      required this.txt,
      this.color,
      this.align,
      this.weight,
      this.textdecoration,
      required this.size,
      this.fontStyle,
      this.softWrap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt.toString(),
      textAlign: align ?? null,
      softWrap: softWrap,
      style: TextStyle(
        decoration: textdecoration,
        fontStyle: fontStyle,
        color: color,
        fontSize: size,
        fontFamily: 'OpenSans',
        fontWeight: weight,
      ),
    );
  }
}
