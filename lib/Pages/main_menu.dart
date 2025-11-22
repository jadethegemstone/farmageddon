import 'package:flutter/material.dart';

import '../main.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const topTitle = Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'WELCOME TO THE',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: 50,
          color: Colors.white,
        ),
      ),
    );

    const bottomTitle = Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'FARMAGEDDON',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: 75,
          color: theColors.darkPink,
        ),
      ),
    );

    final gregImage = SizedBox(
      width: 500,
      child: AspectRatio(aspectRatio: 500 / 290,
          child: Image.asset('Assets/images/greg.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final loanButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(theColors.darkPink)),
      child: const Text('I NEED A LOAN'),
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
            side: BorderSide(width: 5, color: theColors.darkPink),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('Assets/Images/greg.png', width: 300, height: 300, fit: BoxFit.cover),
          const Text('SLOTS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
      onPressed: () {
        Navigator.pushNamed(context, '/second');
      },
    );

    final plinkoButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
            side: BorderSide(width: 5, color: theColors.darkPink),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('Assets/Images/greg.png', width: 300, height: 300, fit: BoxFit.cover),
          const Text('PLINKO',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
      onPressed: () {
        Navigator.pushNamed(context, '/second');
      },
    );

    final BJButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        foregroundColor: WidgetStateProperty.all(theColors.darkPink),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
            side: BorderSide(width: 5, color: theColors.darkPink),
          ),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('Assets/Images/greg.png', width: 300, height: 300, fit: BoxFit.cover),
          const Text('BlackJack',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
      onPressed: () {
        Navigator.pushNamed(context, '/second');
      },
    );

    final homelessAntImg = SizedBox(
      width: 500,
      child: AspectRatio(aspectRatio: 500 / 600,
          child: Image.asset('Assets/images/homelessAnt.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final topRowColLeft = Container (
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 5, color: Colors.black),
          borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
          children:[topTitle, bottomTitle]),
    );

    final topRowColRight = Container (
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
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