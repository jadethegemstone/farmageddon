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

    const int totalLives = 5;
    const int lives = 3;

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

    final hearts = Row(
      children: [
        // Full hearts
        for (int i = 0; i < lives; i++) ...[
          SizedBox(
              width: width * .03,
              child: PixelArtImage(assetPath: 'Assets/images/heartfull.png')
          ),
          if (i < totalLives - 1) SizedBox(width: width * 0.01),
        ],
        // Empty hearts
        for (int i = 0; i < (totalLives - lives); i++) ...[
          SizedBox(
              width: width * .03,
              child: PixelArtImage(assetPath: 'Assets/images/heartempty.png')
          ),
          if (i < (totalLives - lives) - 1) SizedBox(width: width * 0.01),
        ],
      ],
    );

    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            hearts,
            SizedBox(width: width * 0.02),
            backButton
          ]
      ),
    );
  }
}