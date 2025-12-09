import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    final homelessAntImg = SizedBox(
      width: width * .2,
      child: AspectRatio(aspectRatio: 500 / 600,
          child: Image.asset('Assets/images/homelessAnt.png', fit: BoxFit.cover, alignment: Alignment.topCenter)
      ),
    );

    final topRowColLeft = Container (
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
          children:[topTitle, bottomTitle]),
    );

    final topRowColRight = Container (
      child: Column(children:[gregImage, loanButton]),
    );


    final topRow = Container (
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children:[topRowColLeft, topRowColRight]),
    );
    final bottomRow = Container (
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleGameButton(
                label: 'SLOTS',
                route: '/slots',
                imagePath: 'Assets/images/slots/alien_cat.jpg',
                cost: 0,
                gameId: 'slots',
              ),
              CircleGameButton(
                label: '3 CARD MONTE',
                route: '/3cardmonte',
                imagePath: 'Assets/images/3cardmonte/computer_horse.jpg',
                cost: 10000,
                gameId: '3cardmonte',
              ),
              CircleGameButton(
                label: 'BLACKJACK',
                route: '/blackjack',
                imagePath: 'Assets/images/blackjack/flirting_monkey.jpg',
                cost: 15000,
                gameId: 'blackjack',
              ),
              homelessAntImg])
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

class CircleGameButton extends StatelessWidget {
  final String label;
  final String route;
  final String imagePath;
  final int cost;
  final String gameId;

  const CircleGameButton({
    Key? key,
    required this.label,
    required this.route,
    required this.imagePath,
    required this.cost,
    required this.gameId,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final S = context.fontS;
    final XS = context.fontS;

    final gameState = context.watch<GameState>();
    final currentBalance = gameState.balance;
    final isOwned = gameState.ownedGames.contains(gameId);
    final canAfford = currentBalance >= cost;
    final isFree = cost == 0;

    final isEnabled = isFree || isOwned;
    final showBuyOption = !isFree && !isOwned;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: ElevatedButton (
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(isEnabled ? Colors.white : Colors.grey[300]),
          foregroundColor: WidgetStateProperty.all(isEnabled ? theColors.darkPink : Colors.grey),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000),
              side: BorderSide(width: width * .003, color: isEnabled ? theColors.darkPink : Colors.grey),
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
        ),
        child: SizedBox (
          width: width * .13,
          height: width * .13,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isEnabled ? theColors.darkPink : Colors.grey,
                width: width * .003,
              ),
            ),
            child: ClipOval(
              child: (
                  Stack (
                    alignment: Alignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: isEnabled
                            ? ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                            : ColorFilter.mode(Colors.grey, BlendMode.saturation),
                        child: Image.asset(imagePath, fit: BoxFit.cover,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            showBuyOption ? 'BUY' : label,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: showBuyOption ? XS : S,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      color: Colors.black
                                  )
                                ]
                            ),
                          ),
                          if (showBuyOption) ...[
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: XS,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 3,
                                        color: Colors.black
                                    )
                                  ]
                              ),
                            ),
                            Text(
                              '(\$${cost.toString()})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: XS,
                                  color: canAfford ? Colors.greenAccent : Colors.redAccent,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 3,
                                        color: Colors.black
                                    )
                                  ]
                              ),
                            ),
                          ]
                        ],
                      )
                    ],
                  )
              ),
            ),
          ),
        ),
        onPressed: () {
          if (isOwned || isFree) {
            Navigator.pushNamed(context, route);
          } else if (showBuyOption && canAfford) {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('Purchase $label'),
                  content: Text('Do you want to buy $label for \$${cost.toString()}?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                    TextButton(
                      child: Text('Buy'),
                      onPressed: () {
                        gameState.purchaseGame(gameId, cost);
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}