import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import '../../main.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  DateTime? endTime;

  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    final width = context.screenWidth;
    final height = context.screenHeight;
    final XXL = context.fontXXL;
    final XL = context.fontXL;
    final L = context.fontL;
    final M = context.fontM;
    final S = context.fontS;

    void checkGameOver() {
      if (gameState.lives <= 0) {
        Navigator.pushNamed(context, '/lose');
      }
    }

    final timerCountdown = Container(
      key: ValueKey(gameState.endTime), // Force rebuild when endTime changes
      child: TimerCountdown(
        format: CountDownTimerFormat.minutesSeconds,
        enableDescriptions: false,
        endTime: gameState.endTime,
        onEnd: () {
          gameState.onTimerEnd();
          checkGameOver();
        },
        timeTextStyle: TextStyle(
          fontSize: M,
          fontWeight: FontWeight.bold,
        ),
        colonsTextStyle: TextStyle(
          fontSize: M,
        ),
      ),
    );

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

    final balanceBox =
    Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
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
        ),
        // pop up win amount
        Positioned(
          top: height * 0.06, // Adjust this value to position below the box
          child: gameState.lastWinAmount > 0
              ? AnimatedOpacity(
            opacity: gameState.showPopup ? 1.0 : 0.0,
            duration: Duration(milliseconds: 300),
            child: Text(
              '+\$${NumberFormat('#,###').format(gameState.lastWinAmount)}',
              style: TextStyle(
                fontSize: M,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ) : SizedBox.shrink(), // Empty widget when condition is false
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.fromLTRB( 10, 10, 10, 50),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            hearts,
            SizedBox(width: width * 0.02),
            powerups,
            SizedBox(width: width * 0.02),
            balanceBox,
            Spacer(),
            timerCountdown,
            Spacer(),
            backButton
          ]
      ),
    );
  }
}