import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/widgets/app_text.dart';
import 'package:flutter/material.dart';

class sideTabForm extends StatefulWidget {
  const sideTabForm({super.key});

  @override
  State<sideTabForm> createState() => _sideTabFormState();
}

class _sideTabFormState extends State<sideTabForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 200),
      child: Center(
          child: Material(
              elevation: 10.0,
              child: Container(
                width: 500.0,
                height: 400.0,
                decoration: BoxDecoration(
                  gradient: AppConst.primaryGradient,
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText(
                      txt: 'Sign In',
                      size: 30,
                      weight: FontWeight.w600,
                      color: AppConst.white,
                    ),
                    AppText(
                      txt:
                          'Enterprise Resource Planning (ERP) \n systems are like the digital \n backbone of many modern \n businesses.',
                      size: 18,
                      color: AppConst.white,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ))),
    );
  }
}
