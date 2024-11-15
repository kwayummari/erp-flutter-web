import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrintPage extends StatelessWidget {
  final String company;
  final String amount;
  final String recipientName;
  final String senderName;
  final String phoneNumber;
  final String previousPage;

  PrintPage({
    Key? key,
    required this.company,
    required this.amount,
    required this.recipientName,
    required this.senderName,
    required this.phoneNumber,
    required this.previousPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger printing and navigate back
    Future.delayed(Duration(milliseconds: 500), () {
      html.window.print();
      Future.delayed(Duration(seconds: 1), () {
        context.go(previousPage); // Return to the specified previous page
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Company: $company', style: TextStyle(fontSize: 20)),
            Text('Amount: $amount', style: TextStyle(fontSize: 20)),
            Text('Recipient Name: $recipientName', style: TextStyle(fontSize: 20)),
            Text('Sender Name: $senderName', style: TextStyle(fontSize: 20)),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
