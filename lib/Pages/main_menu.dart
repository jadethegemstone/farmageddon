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
        style: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: 30,
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
          fontSize: 50,
        ),
      ),
    );

    final gregImage = Image.asset('/Assets/Images/greg.png', fit:BoxFit.cover);

    final loanButton = ElevatedButton(
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(theColors.pageColor)),
      child: const Text('I NEED A LOAN'),
      onPressed: () {
        Navigator.pushNamed(context, '/second');
      },
    );

    final topRowColLeft = Container (
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(children:[topTitle, bottomTitle]),
    );

    final topRowColRight = Container (
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(children:[gregImage, loanButton]),
    );


    final topRow = Container (
      child: Row(children:[topRowColLeft, topRowColRight]),
    );

    final bottomRow = Row (

    );









    return Scaffold (
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            topRow
          ], // <Widget>[]
        ), // Column
      ), // Center
    );
  }
}