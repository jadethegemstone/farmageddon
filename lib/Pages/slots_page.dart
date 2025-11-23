import 'package:flutter/material.dart';
import '../main.dart';

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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  slot1 = randomSlot();
                  slot2 = randomSlot();
                  slot3 = randomSlot();
                });
              },
              child: Container(
                width: width * 0.08,
                height: width * 0.08,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.redAccent, Colors.red],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(4, 6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Time remaining box
          Positioned(
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