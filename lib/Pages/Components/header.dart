import 'package:flutter/material.dart';
import '../../main.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    final XXL = context.fontXXL;
    final XL = context.fontXL;
    final L = context.fontL;
    final M = context.fontM;
    final S = context.fontS;

    final backButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(theColors.darkPink)),
      child: Text('Back to menu',
        style: TextStyle(
          fontSize: M,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    );

    return Container(
      child:
        Row( mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              backButton
            ]
        ), // Center
    ); // Scaffold
  }
}