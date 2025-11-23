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

    // hearts
    const int totalLives = 5;
    const int lives = 1;

    // power ups
    const int fish = 0;
    const int apple = 0;
    const int banana = 0;

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

    final powerups =
    Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child:
        SizedBox(
          width: width * .3,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * .03,
                child: PixelArtImage(assetPath: 'Assets/images/fish.png')
              ),
              Text(
                fish.toString(),
                style: TextStyle(
                  fontSize: M,
                )
              ),
              SizedBox(
                width: width * .03,
                child: PixelArtImage(assetPath: 'Assets/images/apple.png')
              ),
              Text(
                apple.toString(),
                style: TextStyle(
                  fontSize: M,
                )
              ),
              SizedBox(
                width: width * .03,
                child: PixelArtImage(assetPath: 'Assets/images/banana.png')
              ),
              Text(
                banana.toString(),
                style: TextStyle(
                  fontSize: M,
                )
              ),
            ],
          ),
        )
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            hearts,
            SizedBox(width: width * 0.02),
            powerups,
            SizedBox(width: width * 0.02),
            backButton
          ]
      ),
    );
  }
}