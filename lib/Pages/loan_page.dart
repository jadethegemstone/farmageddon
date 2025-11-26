import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({Key? key}) : super(key: key);
  @override
  State <LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {

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

    int balance = gameState.balance;

    final gregImage = SizedBox(
      width: width * 0.4,
      child: AspectRatio(aspectRatio: 300 / 290,
          child: Image.asset('Assets/images/greg.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final impactStar = SizedBox(
      width: width * 0.4,
      child: AspectRatio(aspectRatio: 300 / 290,
          child: Image.asset('Assets/images/impactStar.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final gregDialogue = SizedBox(
      width: width * 0.3,
      child: Image.asset('Assets/images/gregDialogueLoanPage.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
    );

    final rightCol = Align( alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          impactStar,
          gregImage,
          Text('GREG', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: XL,
              color: Colors.white,
            )
          )
        ],
      )
    );

    final topRow = SizedBox (
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column (
            children: [
              Column ( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text('LOANS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: L,
                        color: theColors.darkPink,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text('\$${NumberFormat('#,###').format(balance)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: L,
                        color: theColors.darkPink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          gregDialogue
        ],
      ),
    );

    final leftCol = SizedBox(
      width: width * 0.5,
      child: Column (
        children: [
          topRow,
          loanChoiceButton(loan: 1000, hearts: 1, time: 1, imagePath: 'Assets/Images/greg.png', onPressed: () => setState(() {}),),
          Spacer(),
          loanChoiceButton(loan: 3000, hearts: 2, time: 8, imagePath: 'Assets/Images/greg.png', onPressed: () => setState(() {}),),
          Spacer(),
          loanChoiceButton(loan: 5000, hearts: 3, time: 12, imagePath: 'Assets/Images/greg.png', onPressed: () => setState(() {}),),
          Spacer(),
        ],
      ),
    );

    return Scaffold(
      body: Align( alignment: Alignment.topCenter,
        child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leftCol,
              rightCol,
          ]
        ),
      ), // Center
    ); // Scaffold
  }
}

class loanChoiceButton extends StatelessWidget {
  final int loan;
  final int hearts;
  final int time;
  final String imagePath;
  final VoidCallback onPressed;

  const loanChoiceButton({
    Key? key,
    required this.loan,
    required this.hearts,
    required this.time,
    required this.imagePath,
    required this.onPressed,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = context.read<GameState>();
    final width = context.screenWidth;
    final S = context.fontS;

    void checkLoan() {
      if (gameState.balance >= loan) {
        gameState.subtractBalance(loan);
      } else {
        gameState.subtractLives(hearts);
      }
    };


    return ElevatedButton (
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(width: width * .003, color: theColors.darkPink),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: SizedBox (
        width: width * .45,
        child: (
            Row (
              children: [
                Image.asset(imagePath, fit: BoxFit.cover, width: width * 0.08,),
                Text('\$${NumberFormat('#,###').format(loan)} (Bet ${hearts} heart(s), ${time} minutes to pay back',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: S,
                      color: Colors.black,
                  ),
                )
              ],
            )
        ),
      ),
      onPressed: () {
        // Add loan to balance if enough hearts and timer isn't already running
        // Add time to timer
        // Subtract hearts from health if timer runs out
        gameState.takeLoan(loan, hearts, time);
        onPressed();
      },
    );
  }
}