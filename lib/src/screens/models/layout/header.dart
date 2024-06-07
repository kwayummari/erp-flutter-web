import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Container(
        width: MediaQuery.of(context).size.width,
              height: 100.0,
              decoration: BoxDecoration(
                color: AppConst.primary,
                borderRadius: BorderRadius.circular(0.0),),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}