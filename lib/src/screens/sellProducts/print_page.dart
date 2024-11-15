import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrintingPage extends StatelessWidget {
  final String previousPage;

  PrintingPage({Key? key, required this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger printing after the page renders
    Future.delayed(Duration(milliseconds: 500), () {
      if (html.window != null) {
        html.window.print(); // Trigger browser print
      }

      // Navigate back to the previous page after printing
      Future.delayed(Duration(seconds: 1), () {
        context.go(previousPage); // Navigate back
      });
    });

    // The content of the page to print
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Company: Aurorawave Labs'),
            Text('Amount: 20,000'),
            Text('Recipient Name: Andrew Msilu'),
            Text('Sender Name: Kwayu Mmari'),
            Text('Phone Number: 0762996305'),
          ],
        ),
      ),
    );
  }
}
