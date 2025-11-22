import 'package:flutter/material.dart';
import '../main.dart';

class PlinkoPage extends StatelessWidget {
  const PlinkoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    final XXL = context.fontXXL;
    final XL = context.fontXL;
    final L = context.fontL;
    final M = context.fontM;
    final S = context.fontS;

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              foregroundColor: WidgetStateProperty.all(theColors.darkPink)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('This is the plinko page, click to go back',
            style: TextStyle(
              fontSize: L
            )
          ),
        ), // ElevatedButton
      ), // Center
    ); // Scaffold
  }
}