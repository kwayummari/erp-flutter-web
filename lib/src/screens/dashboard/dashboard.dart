import 'package:erp/src/screens/models/layout/layout.dart';
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    return layout(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: Row(
            children: [
              Material(
                elevation: 10,
                color: AppConst.white,
                child: Container(
                  width: 250.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: AppConst.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                txt: 'Total sales',
                                size: 15,
                                color: AppConst.grey,
                                weight: FontWeight.bold,
                              ),
                              AppText(
                                txt: 'Tsh. 1,000,000',
                                size: 20,
                                color: AppConst.black,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.graphic_eq, color: AppConst.grey,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Material(
                elevation: 10,
                color: AppConst.white,
                child: Container(
                  width: 250.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: AppConst.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                txt: 'Total purchases',
                                size: 15,
                                color: AppConst.grey,
                                weight: FontWeight.bold,
                              ),
                              AppText(
                                txt: 'Tsh. 200,000',
                                size: 20,
                                color: AppConst.black,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.money, color: AppConst.grey,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Material(
                elevation: 10,
                color: AppConst.white,
                child: Container(
                  width: 250.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: AppConst.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                txt: 'Total products',
                                size: 15,
                                color: AppConst.grey,
                                weight: FontWeight.bold,
                              ),
                              AppText(
                                txt: '100',
                                size: 20,
                                color: AppConst.black,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.propane_tank_rounded, color: AppConst.grey,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Material(
                elevation: 10,
                color: AppConst.white,
                child: Container(
                  width: 250.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: AppConst.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                txt: 'Net profit',
                                size: 15,
                                color: AppConst.grey,
                                weight: FontWeight.bold,
                              ),
                              AppText(
                                txt: 'Tsh. 800,000',
                                size: 20,
                                color: AppConst.black,
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.money, color: AppConst.grey,)
                      ],
                    ),
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
