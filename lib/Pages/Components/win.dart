import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class Win extends StatefulWidget {
  const Win({Key? key}) : super(key: key);

  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
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
            Text('YOU WIN',
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