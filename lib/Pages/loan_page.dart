import 'package:flutter/material.dart';
import '../main.dart';

class LoanPage extends StatelessWidget {
  const LoanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green),
              foregroundColor: WidgetStateProperty.all(Colors.white)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Back!'),
        ), // ElevatedButton
      ), // Center
    ); // Scaffold
  }
}