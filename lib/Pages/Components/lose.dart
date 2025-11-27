import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class Lose extends StatefulWidget {
  const Lose({Key? key}) : super(key: key);

  @override
  State<Lose> createState() => _LoseState();
}

class _LoseState extends State<Lose> {
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

    final backButton = SizedBox(
      width: width * 0.2,
      child: ElevatedButton(
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
          alignment: Alignment.center,
          child: Text('Back to menu',
            style: TextStyle(
              fontSize: M,
            ),
          ),
        ),

        onPressed: () {
          Navigator.pushNamed(context, '/');
          gameState.restartGame();
        },
      )
    );

    return Scaffold(
      body: Center ( child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('YOU LOSE',
              style: TextStyle(
                fontSize: XL,
                fontWeight: FontWeight.w800,
              ),
            ),
            backButton,
          ],
        )
      ),
    );
  }
}