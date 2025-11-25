import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

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
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
      )
    )
      ),
      child:
      Align(
        alignment: Alignment.centerRight,
        child: Text('Back to menu',
          style: TextStyle(
            fontSize: M,
          ),
        ),
      ),

      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    );

    final hearts = Row(
      children: [
        // Full hearts
        for (int i = 0; i < gameState.lives; i++) ...[
          SizedBox(
              width: width * .03,
              child: PixelArtImage(assetPath: 'Assets/images/heartfull.png')
          ),
          if (i < gameState.totalLives - 1) SizedBox(width: width * 0.01),
        ],
        // Empty hearts
        for (int i = 0; i < (gameState.totalLives - gameState.lives); i++) ...[
          SizedBox(
              width: width * .03,
              child: PixelArtImage(assetPath: 'Assets/images/heartempty.png')
          ),
          if (i < (gameState.totalLives - gameState.lives) - 1) SizedBox(width: width * 0.01),
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
              // Count of fish power up
              Text(
                gameState.fish.toString(),
                style: TextStyle(
                  fontSize: M,
                )
              ),
              SizedBox(
                width: width * .03,
                child: PixelArtImage(assetPath: 'Assets/images/apple.png')
              ),
              // Count of apple power up
              Text(
                gameState.apple.toString(),
                style: TextStyle(
                  fontSize: M,
                )
              ),
              SizedBox(
                width: width * .03,
                child: PixelArtImage(assetPath: 'Assets/images/banana.png')
              ),
              // Count of banana power up
              Text(
                gameState.banana.toString(),
                style: TextStyle(
                  fontSize: M,
                )
              ),
            ],
          ),
        )
    );

    final balanceBox = Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child:
      SizedBox(
        width: width * .1,
        child: Text('\$${NumberFormat('#,###').format(gameState.balance)}',
          style: TextStyle(
            fontSize: M,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );

    final timer = Visibility (
        visible: true,
        child: Positioned(
          right: width * 0.03,
          bottom: height * 0.06,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time Remaining:',
                  style: TextStyle(
                    fontSize: S,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'XX:XX:XX',
                  style: TextStyle(fontSize: L),
                ),
              ],
            ),
          ),
        )
    );

    return Container(
      padding: const EdgeInsets.fromLTRB( 10, 10, 10, 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            hearts,
            SizedBox(width: width * 0.02),
            powerups,
            SizedBox(width: width * 0.02),
            balanceBox,
            Spacer(),
            timer,
            Spacer(),
            backButton
          ]
      ),
    );
  }
}