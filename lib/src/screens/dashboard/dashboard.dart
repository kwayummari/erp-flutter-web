import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return layout(child: Column(
      children: [
       Padding(
         padding: const EdgeInsets.only(left: 100, right: 100),
         child: Row(
          children: [
            Material(
              elevation: 10,
              color: AppConst.white,
              child: Container(
                width: 350.0,
              height: 200.0,
              decoration: BoxDecoration(
                color: AppConst.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              ),
            ),
            SizedBox( width: 50,),
            Material(
              elevation: 10,
              color: AppConst.white,
              child: Container(
                width: 350.0,
              height: 200.0,
              decoration: BoxDecoration(
                color: AppConst.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              ),
            ),
            SizedBox( width: 50,),
            Material(
              elevation: 10,
              color: AppConst.white,
              child: Container(
                width: 350.0,
              height: 200.0,
              decoration: BoxDecoration(
                color: AppConst.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              ),
            )
          ],
         ),
       )
      ],
    ));
  }
}