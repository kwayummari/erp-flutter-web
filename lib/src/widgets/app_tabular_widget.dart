import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class appTabular extends StatefulWidget {
  final Widget child;
  final Widget button;
  final String title;
  const appTabular({super.key, required this.child, required this.title, required this.button});

  @override
  State<appTabular> createState() => _appTabularState();
}

class _appTabularState extends State<appTabular> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppConst.blackOpacity),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            Container(
              color: AppConst.grey200,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 20, top: 20, bottom: 20),
                child: Row(
                  children: [
                    AppText(
                      txt: widget.title,
                      size: 20,
                      color: AppConst.black,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(width: 20,),
                    widget.button,
                  ],
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppConst.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
