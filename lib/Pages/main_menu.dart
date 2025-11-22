import 'package:flutter/material.dart';

import '../main.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    final XXL = context.fontXXL;
    final XL = context.fontXL;
    final L = context.fontL;
    final M = context.fontM;
    final S = context.fontS;



    final topTitle = Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'WELCOME TO THE',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: XL,
          color: Colors.white,
        ),
      ),
    );

    final bottomTitle = Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'FARMAGEDDON',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: XXL,
          color: theColors.darkPink,
        ),
      ),
    );

    final gregImage = SizedBox(
      width: width * 0.30,
      child: AspectRatio(aspectRatio: 500 / 290,
          child: Image.asset('Assets/images/greg.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final loanButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(theColors.darkPink)),
      child: Text('I NEED A LOAN',
        style: TextStyle(
          fontSize: M,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/loan');
      },
    );

    final slotButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
            side: BorderSide(width: width * .003, color: theColors.darkPink),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: SizedBox(
        width: width * .13,
        height: width * .13,
        child: Stack(
          alignment: Alignment.center,
          children: [
             Image.asset('Assets/Images/greg.png', fit: BoxFit.cover),
             Text('SLOTS',
                 style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: S,
                     color: Colors.white,
                     shadows: [
                       Shadow(
                           offset: Offset(2, 2),
                           blurRadius: 3,
                           color: Colors.black
                       )
                     ]
                 )
             ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/slots');
      },
    );

    final plinkoButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
            side: BorderSide(width: width * .003, color: theColors.darkPink),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: SizedBox(
        width: width * .13,
        height: width * .13,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('Assets/Images/greg.png', fit: BoxFit.cover),
            Text('PLINKO',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: S,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black
                      )
                    ]
                )
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/plinko');
      },
    );

    final BJButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
            side: BorderSide(width: width * .003, color: theColors.darkPink),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: SizedBox(
        width: width * .13,
        height: width * .13,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('Assets/Images/greg.png', fit: BoxFit.cover),
            Text('BLACKJACK',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: S,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3,
                          color: Colors.black
                      )
                    ]
                )
            ),
          ],
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/blackjack');
      },
    );

    final homelessAntImg = SizedBox(
      width: width * .25,
      child: AspectRatio(aspectRatio: 500 / 600,
          child: Image.asset('Assets/images/homelessAnt.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final topRowColLeft = Container (
      // padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 5, color: Colors.black),
          borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
          children:[topTitle, bottomTitle]),
    );

    final topRowColRight = Container (
      // padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(children:[gregImage, loanButton]),
    );


    final topRow = Container (
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children:[topRowColLeft, topRowColRight]),
    );
    final bottomRow = Container (
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [slotButton, plinkoButton, BJButton, homelessAntImg])
    );

    return Scaffold (
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            topRow, bottomRow
          ], // <Widget>[]
        ), // Column
      ), // Center
    );
  }
}