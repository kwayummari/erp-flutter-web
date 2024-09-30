import 'package:erp/src/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class PrintPage extends StatelessWidget {
  final String company;
  final String amount;
  final String recipientName;
  final String senderName;
  final String phoneNumber;

  PrintPage({
    required this.company,
    required this.amount,
    required this.recipientName,
    required this.senderName,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Automatically triggers print dialog when page loads
      html.window.print();
    });

    return Scaffold(
      backgroundColor: AppConst.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Company: $company'),
            Text('Amount: $amount'),
            Text('Recipient Name: $recipientName'),
            Text('Sender Name: $senderName'),
            Text('Phone Number: $phoneNumber'),
          ],
        ),
      ),
    );
  }
}
