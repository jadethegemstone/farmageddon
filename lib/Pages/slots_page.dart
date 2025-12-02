import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
  import 'package:confetti/confetti.dart';
  import 'package:flutter/services.dart';
  import '../main.dart';
  import 'dart:math';

  class SlotsPage extends StatefulWidget {
    const SlotsPage({Key? key}) : super(key: key);

    @override
    _SlotsPageState createState() => _SlotsPageState();
  }
    class _SlotsPageState extends State<SlotsPage> with SingleTickerProviderStateMixin {

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

    //Win State
    bool _spin1 = false;
    bool _spin2 = false;
    bool _spin3 = false;
    bool _isWinning = false;
    bool _showWinGif = false;

    // Confetti
    late ConfettiController _confettiController;

    //Screen Shake
    late AnimationController _shakeController;

    // Keyboard Focus
    late FocusNode _focusNode;

    @override
    void initState() {
      super.initState();
      slot1 = randomSlot();
      slot2 = randomSlot();
      slot3 = randomSlot();

      _confettiController =
          ConfettiController(duration: const Duration(seconds: 2));

      _shakeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

       _shakeController.addListener(() {
      if (mounted) {
        setState(() {});   
      }
    });

    _focusNode = FocusNode();

    }

    @override
    void dispose() {
      _confettiController.dispose();
      _shakeController.dispose();
      _focusNode.dispose();
      super.dispose();
      
    }


    void _triggerSpin() {
    final gameState = Provider.of<GameState>(context, listen: false);
    const int gameCost = 100;

    if (gameState.balance < gameCost) return;

    setState(() {
      // Start spinning animation
      _spin1 = true;
      _spin2 = true;
      _spin3 = true;

      // Staggered stop
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _spin1 = false);
      });

      Future.delayed(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() => _spin2 = false);
      });

      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() => _spin3 = false);
      });

      // Pay cost & show loss popup
      gameState.subtractBalance(gameCost);
      gameState.showLossAmount(gameCost);

      // Base random slots
      slot1 = randomSlot();
      slot2 = randomSlot();
      slot3 = randomSlot();

      // Rigging
      final roll = _rng.nextDouble();

      if (roll < riggedWinChance3) {
        final forced = randomSlot();
        slot1 = forced;
        slot2 = forced;
        slot3 = forced;
      } else if (roll < riggedWinChance3 + riggedWinChance2) {
        final forced = randomSlot();
        final patternIndex = Random().nextInt(3);

        switch (patternIndex) {
          case 0:
            slot1 = randomSlot();
            slot2 = forced;
            slot3 = forced;
            break;
          case 1:
            slot1 = forced;
            slot2 = forced;
            slot3 = randomSlot();
            break;
          case 2:
            slot1 = forced;
            slot2 = randomSlot();
            slot3 = forced;
            break;
        }
      }

      // Reset win state
      _isWinning = false;
      _showWinGif = false;

      int moneyWon = 0;

      // Match checking
      final threeMatch = (slot1 == slot2 && slot2 == slot3);
      final twoMatch = (!threeMatch) &&
          (slot1 == slot2 || slot2 == slot3 || slot1 == slot3);

      if (threeMatch) {
        moneyWon = 500;

        _isWinning = true;
        _showWinGif = true;
        _confettiController.play();
        _shakeController.forward(from: 0);

        Future.delayed(const Duration(seconds: 5), () {
          if (!mounted) return;
          setState(() {
            _isWinning = false;
            _showWinGif = false;
          });
        });
      } else if (twoMatch) {
        moneyWon = 150;
      }

      if (moneyWon > 0) {
        gameState.addBalance(moneyWon);
        gameState.showWinAmount(moneyWon);
      }
    });
  }

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

      //Shake animation
      final double shakeValue = _shakeController.isAnimating ? _shakeController.value : 0.0;
      final double shakeOffset = 10 * sin(shakeValue * pi * 10);

      //Machine image 
      final machineWidth = width * 0.70;

      final slotMachineBackground = Align(
        alignment: const Alignment(0.1, -0.45),
        child: Image.asset(
          'assets/images/slots/slot_machine.png',
          width: machineWidth,
          fit: BoxFit.contain,
        ),
      );

      final threeCatWindow = Align(
        alignment: const Alignment(-0.15, 0),
        child: SizedBox(
          width: machineWidth * 0.80,
          height: machineWidth * 0.40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SlotWindow(imagePath: slot1, machineWidth: machineWidth, isWinning: _isWinning, isSpinning: _spin1,),
              _SlotWindow(imagePath: slot2, machineWidth: machineWidth, isWinning: _isWinning, isSpinning: _spin2,),
              _SlotWindow(imagePath: slot3, machineWidth: machineWidth, isWinning: _isWinning, isSpinning: _spin3,),
            ],
          ),
        ),
      );

      final confetti = Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          emissionFrequency: 0.9,
          numberOfParticles: 60,
          maxBlastForce: 250,
          minBlastForce: 120,
          gravity: 0.5,
        ),
      );


      return Scaffold(
        backgroundColor: theColors.lightPink,
        body: RawKeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKey: (event) {
            if (event.isKeyPressed(LogicalKeyboardKey.space)) {
              _triggerSpin();
            }
          },

        child: Transform.translate(
        offset: Offset(shakeOffset, 0),   // screen shaking
        child: Stack(
          children: [
            slotMachineBackground,
            threeCatWindow,

            //SPIN BUTTON with cost popup
            Positioned(
              left: width * 0.07,
              bottom: height * 0.06,
              child: Consumer<GameState>(
                builder: (context, gameState, child) {
                  final bool canSpin = gameState.balance >= 100;

                  return GestureDetector(
                    onTap: _triggerSpin,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: canSpin ? 1.0 : 0.5,
                          child: Container(
                            width: width * 0.06,
                            height: width * 0.06,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: canSpin
                                  ? const RadialGradient(
                                colors: [Colors.redAccent, Colors.red],
                              )
                                  : const RadialGradient(
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
                        SizedBox(width: width * 0.02), // Space between button and text
                        // Cost popup
                        if (gameState.lastLossAmount > 0)
                          AnimatedOpacity(
                            opacity: gameState.showPopup ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 300),
                            child: Text(
                              '-\$${NumberFormat('#,###').format(gameState.lastLossAmount)}',
                              style: TextStyle(
                                fontSize: M,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

          confetti,

            // Dancing cat GIF
            if (_showWinGif)
            Stack(
              children: [
                // Big center cat
                Center(
                  child: Image.asset(
                    'Assets/images/slots/dancing-cat.gif',
                    width: width * 0.6,     // huge
                  ),
                ),

                // Smaller cat top-left
                Positioned(
                  left: width * 0.05,
                  top: height * 0.15,
                  child: Image.asset(
                    'Assets/images/slots/dancing-cat.gif',
                    width: width * 0.3,
                  ),
                ),

                // Smaller cat top-right
                Positioned(
                  right: width * 0.05,
                  top: height * 0.2,
                  child: Image.asset(
                    'Assets/images/slots/dancing-cat.gif',
                    width: width * 0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
        ),
      );
    }
  }

  //Slot Window
  class _SlotWindow extends StatelessWidget {
    final String imagePath;
    final double machineWidth;
    final bool isWinning;
    final bool isSpinning;

    const _SlotWindow ({
      required this.imagePath,
      required this.machineWidth,
      required this.isWinning,
      required this.isSpinning,
    });
    
    @override
    Widget build(BuildContext context) {
      // size of each window 
      final windowWidth = machineWidth * 0.22;
      final windowHeight = machineWidth * 0.32;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: windowWidth,
        height: windowHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isWinning ? theColors.darkPink : Colors.black,
            width: isWinning ? 6 : 4,
          ),
          boxShadow: isWinning
              ? [
                  BoxShadow(
                    color: theColors.darkPink.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(3, 5),
                  ),
                ],
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: isWinning ? 1.05 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 1.5, end: 1).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  ),
                  child: child,
                );
              },
              child: isSpinning
                  ? Transform.scale(
                      scale: 1.8,
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          imagePath,
                          key: ValueKey("spin-$imagePath"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      key: ValueKey(imagePath),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      );
    }
  }