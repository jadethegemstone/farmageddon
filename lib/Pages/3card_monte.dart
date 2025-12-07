import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../main.dart';

class _MonteCard {
  final String id;
  final String image;
  final String? type; // 'apple', 'banana', 'fish'

  _MonteCard(this.id, this.image, {this.type});
}

class ThreeCardMontePage extends StatefulWidget {
  const ThreeCardMontePage({Key? key}) : super(key: key);

  @override
  State<ThreeCardMontePage> createState() => _ThreeCardMontePageState();
}

class _ThreeCardMontePageState extends State<ThreeCardMontePage> {
  final Random _rng = Random();

  List<_MonteCard> _cards = [];
  bool _showAll = false;
  String _message = "Pick a card!";
  int _correctIndex = 0;

  // Powerup mode
  bool _powerupMode = false;
  static const int _powerupCost = 250;

  // Normal mode betting
  static const int _minBet = 500;
  static const int _betStep = 500;
  int _currentBet = _minBet;

  // Normal card images
  final List<String> _normalCardImages = [
    'Assets/images/3cardmonte/man_horse.jpg',
    'Assets/images/3cardmonte/rollercoaster_horse.jpg',
    'Assets/images/3cardmonte/sitting_horse.jpg',
  ];

  // Powerup cards
  final List<Map<String, String>> _powerupCards = [
    {'image': 'Assets/images/3cardmonte/horse_apple.webp', 'type': 'apple'},
    {'image': 'Assets/images/3cardmonte/horse_banana.jpg', 'type': 'banana'},
    {'image': 'Assets/images/3cardmonte/horse_fish.jpg', 'type': 'fish'},
  ];

  final String _backImage = 'Assets/images/3cardmonte/sideeye_horse.jpg';

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _showAll = false;
    _message = "Pick a card!";

    if (_powerupMode) {
      final powerup = _powerupCards[_rng.nextInt(_powerupCards.length)];

      final remainingNormals =
      _normalCardImages.where((img) => img != powerup['image']).toList();
      remainingNormals.shuffle(_rng);
      final chosenNormals = remainingNormals.take(2).toList();

      final tempCards = [
        _MonteCard('card0', powerup['image']!, type: powerup['type']),
        _MonteCard('card1', chosenNormals[0]),
        _MonteCard('card2', chosenNormals[1]),
      ];
      tempCards.shuffle(_rng);
      _cards = tempCards;
      _correctIndex = _cards.indexWhere((c) => c.image == powerup['image']);
    } else {
      _correctIndex = _rng.nextInt(3);
      _cards = List.generate(
          3, (i) => _MonteCard('card$i', _normalCardImages[i]));
    }

    setState(() {});
  }

  void _pickCard(int index) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final cost = _powerupMode ? _powerupCost : _currentBet;

    if (gameState.balance < cost) {
      setState(() => _message = "Not enough money!");
      return;
    }

    gameState.subtractBalance(cost);
    gameState.showLossAmount(cost);

    setState(() {
      _showAll = true;
      if (index == _correctIndex) {
        if (_powerupMode) {
          final card = _cards[_correctIndex];
          switch (card.type) {
            case 'fish':
              gameState.addFish(1);
              break;
            case 'apple':
              gameState.addApple(1);
              break;
            case 'banana':
              gameState.addBanana(1);
              break;
          }
          _message = "You won a ${card.type}!";
        } else {
          int payout = cost * 2;
          gameState.addBalance(payout);
          gameState.showWinAmount(payout - cost);
          _message = "You won!";
        }
      } else {
        _message = "Wrong card!";
      }
    });
  }

  Widget _cardWidget(_MonteCard card, bool reveal) {
    final isWinner = _cards.indexOf(card) == _correctIndex;
    return GestureDetector(
      onTap: () {
        if (!_showAll) _pickCard(_cards.indexOf(card));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 120,
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: reveal && isWinner
              ? [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.8),
              blurRadius: 12,
              spreadRadius: 4,
            )
          ]
              : [],
        ),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(
          reveal ? card.image : _backImage,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Powerup Mode: "),
                  Switch(
                    value: _powerupMode,
                    onChanged: (val) {
                      setState(() {
                        _powerupMode = val;
                        _resetGame();
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _message,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _cards.map((c) => _cardWidget(c, _showAll)).toList(),
              ),
              const SizedBox(height: 24),

              // Betting HUD (narrower)
              Container(
                width: size.width * 0.3,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.shade400, width: 2),
                ),
                child: Column(
                  children: [
                    if (!_powerupMode) ...[
                      const Text("BET",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text("\$$_currentBet",
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  final next = _currentBet - _betStep;
                                  if (next >= _minBet) _currentBet = next;
                                });
                              },
                              icon: const Icon(Icons.remove)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  final next = _currentBet + _betStep;
                                  if (next <= gameState.balance) _currentBet = next;
                                });
                              },
                              icon: const Icon(Icons.add)),
                        ],
                      ),
                    ],
                    Text("Balance: \$${gameState.balance}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    if (_powerupMode)
                      const Text("Cost per play: \$250",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _resetGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("RESET"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
