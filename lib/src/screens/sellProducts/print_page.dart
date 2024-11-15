import 'dart:html' as html;
import 'package:erp/src/utils/app_const.dart';
import 'package:erp/src/utils/routes/route-names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrintPage extends StatelessWidget {
  final String company;
  final String amount;
  final String recipientName;
  final String senderName;
  final String phoneNumber;

  PrintPage({
    Key? key,
    required this.company,
    required this.amount,
    required this.recipientName,
    required this.senderName,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger printing and navigate back
    // html.window.print();
    // Future.delayed(Duration(milliseconds: 500), () {
    //   html.window.print();
    //   Future.delayed(Duration(seconds: 1), () {
    //     context.go(RouteNames.saleManagement);
    //   });
    // });

    return Scaffold(
      backgroundColor: AppConst.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Company: $company', style: TextStyle(fontSize: 20)),
            Text('Amount: $amount', style: TextStyle(fontSize: 20)),
            Text('Recipient Name: $recipientName',
                style: TextStyle(fontSize: 20)),
            Text('Sender Name: $senderName', style: TextStyle(fontSize: 20)),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
