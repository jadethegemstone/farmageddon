import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'dart:math';

class SlotsPage extends StatefulWidget {
  const SlotsPage({Key? key}) : super(key: key);

  @override
  _SlotsPageState createState() => _SlotsPageState();
}
  class _SlotsPageState extends State<SlotsPage> {

  //SLOT IMAGES
  final List<String> slotImages = [
    'assets/images/slots/alien_cat.jpg',
    'assets/images/slots/bruh_cat.jpg',
    'assets/images/slots/crying_cat.jpg',
    'assets/images/slots/elcato.jpg',
    'assets/images/slots/goofy_ass_cat.jpg',
    'assets/images/slots/human_cat.jpg',
    'assets/images/slots/loser_cat.jpg',
    'assets/images/slots/milk_cat.jpg',
    'assets/images/slots/scared_cat.png',
    'assets/images/slots/sideeye_cat.jpg',
    'assets/images/slots/singing_cat.jpg',
    'assets/images/slots/smirk_cat.jpg',
    'assets/images/slots/soldier_cat.jpg',
    'assets/images/slots/staring_cat.jpg',
    'assets/images/slots/teeth_cat.jpg',
  ];
  
  //Rigging
  final Random _rng = Random();
  final double riggedWinChance3 = 0.05;
  final double riggedWinChance2 = 0.15;

  String randomSlot() {
    slotImages.shuffle();
    return slotImages.first;
  }

  late String slot1;
  late String slot2;
  late String slot3;

  @override
  void initState() {
    super.initState();
    slot1 = randomSlot();
    slot2 = randomSlot();
    slot3 = randomSlot();
  }

   @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final height = context.screenHeight;
    final L = context.fontL;
    final S = context.fontS;

    //Machine image 
    final machineWidth = width * 0.70;

    return Scaffold(
      backgroundColor: theColors.lightPink,
      body: Stack(
        children: [
          //Slot Machine Background
          Align(
            alignment: const Alignment(0.1, -0.45),
            child: Image.asset(
              'assets/images/slots/slot_machine.png',
              width: machineWidth,
              fit: BoxFit.contain,
            ),
          ),

          //3 cat window
          Align(
            alignment: const Alignment(-0.15, 0),
            child: SizedBox(
              width: machineWidth * 0.80,       
              height: machineWidth * 0.40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SlotWindow(imagePath: slot1, machineWidth: machineWidth),
                  _SlotWindow(imagePath: slot2, machineWidth: machineWidth),
                  _SlotWindow(imagePath: slot3, machineWidth: machineWidth),
                ],
              ),
            ),
          ),

          //SPIN BUTTON
          Positioned(
            left: width * 0.07,
            bottom: height * 0.06,
            child: Consumer<GameState>(
              builder: (context, gameState, child) {
                final bool canSpin = gameState.balance >= 100;

                return GestureDetector(
              onTap: () {
                if (!canSpin) return; // Can't afford, do nothing

                setState(() {

                  gameState.subtractBalance(100);
                  
                  slot1 = randomSlot();
                  slot2 = randomSlot();
                  slot3 = randomSlot();

                  //Rigging
                  //3 slots
                  if (_rng.nextDouble() < riggedWinChance3) {
                    final forced = randomSlot();
                    slot1 = forced;
                    slot2 = forced;
                    slot3 = forced;
                  }
                  //2 slots
                  if (_rng.nextDouble() < riggedWinChance2 && _rng.nextDouble() > riggedWinChance3) {
                    final random = Random().nextInt(2);
                    final forced = randomSlot();
                    switch (random) {
                      case 0:
                        slot1 = randomSlot();
                        slot2 = forced;
                        slot3 = forced;
                      case 1:
                        slot1 = forced;
                        slot2 = forced;
                        slot3 = randomSlot();
                      case 2:
                        slot1 = forced;
                        slot2 = randomSlot();
                        slot3 = forced;
                    }
                  }

                  //Reward Wins
                  if (slot1 == slot2 && slot2 == slot3) {
                    gameState.balance * 2;
                  }
                  if (slot1 == slot2 || slot2 == slot3 || slot1 == slot3) {
                    gameState.addBalance(250);
                  }
                });
              },

              child: Opacity(
              opacity: canSpin ? 1.0 : 0.5, 
              child: Container(
                width: width * 0.08,
                height: width * 0.08,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: canSpin ? const RadialGradient(
                          colors: [Colors.redAccent, Colors.red],
                  ) : const RadialGradient(
                          colors: [Colors.grey, Colors.grey], 
                      ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(4, 6),
                      blurRadius: 6,
                    ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        ],
      ),
    );
  }
}

//Slot Window
class _SlotWindow extends StatelessWidget {
  final String imagePath;
  final double machineWidth;

  const _SlotWindow({
    required this.imagePath,
    required this.machineWidth,
  });

  @override
  Widget build(BuildContext context) {
    // size of each window 
    final windowWidth = machineWidth * 0.22;
    final windowHeight = machineWidth * 0.32;

    return Container(
      width: windowWidth,
      height: windowHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), 
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}