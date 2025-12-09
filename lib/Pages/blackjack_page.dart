import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../main.dart';

class _BJCard {
  final String rank;
  final String suit;
  final int value;

  _BJCard(this.rank, this.suit, this.value);
}

class BlackjackPage extends StatefulWidget {
  const BlackjackPage({Key? key}) : super(key: key);

  @override
  State<BlackjackPage> createState() => _BlackjackPageState();
}

class _BlackjackPageState extends State<BlackjackPage> {
  final Random _rng = Random();

  // betting config
  static const int _minBet = 500;
  static const int _betStep = 500;
  int _betAmount = _minBet;
  int _currentBet = 0;

  List<_BJCard> _playerCards = [];
  List<_BJCard> _dealerCards = [];

  bool _dealerHidden = true;
  String _message = 'Press DEAL to start';
  bool _playerTurn = false;
  bool _roundOver = false;

  //Power Ups
  bool _usePowerUp = false;
  bool _noPowerUp = false;
  bool _notStarted = false;
  bool _alreadyUsedError = false;
  bool _alreadyUsed = false;

  final List<String> _cardBackImages = [
    'Assets/images/blackjack/hehe_monkey.jpeg',
    'Assets/images/blackjack/teehee_monkey.jpeg',
    'Assets/images/blackjack/angry_monkey.jpg',
    'Assets/images/blackjack/flirting_monkey.jpg',
    'Assets/images/blackjack/shocking_monkey.jpg',
    'Assets/images/blackjack/wherelooking_monkey.jpg',
  ];
  late String _currentBackImage;

  @override
  void initState() {
    super.initState();
    _currentBackImage = _cardBackImages.first;
  }

  //Card logic
  _BJCard _drawCard() {
    const suits = ['♠', '♥', '♦', '♣'];
    const ranks = [
      'A',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
    ];

    final suit = suits[_rng.nextInt(suits.length)];
    final rank = ranks[_rng.nextInt(ranks.length)];

    int value;
    if (rank == 'A') {
      value = 11;
    } else if (['J', 'Q', 'K'].contains(rank)) {
      value = 10;
    } else {
      value = int.parse(rank);
    }

    return _BJCard(rank, suit, value);
  }

  int _handTotal(List<_BJCard> hand) {
    int total = hand.fold(0, (sum, c) => sum + c.value);
    int aceCount = hand.where((c) => c.rank == 'A').length;

    while (total > 21 && aceCount > 0) {
      total -= 10;
      aceCount--;
    }
    return total;
  }

  void _deal() {
    final gameState = Provider.of<GameState>(context, listen: false);
    final balance = gameState.balance;

    if (balance < _minBet) {
      setState(() => _message = "Not enough money (min \$$_minBet)");
      return;
    }

    int desiredBet = _betAmount;
    if (desiredBet > balance) desiredBet = balance;
    if (desiredBet < _minBet) desiredBet = _minBet;

    if (desiredBet > balance) {
      setState(() => _message = "Not enough money to bet.");
      return;
    }

    _currentBet = desiredBet;
    _betAmount = desiredBet;

    // random monkey back
    _currentBackImage = _cardBackImages[_rng.nextInt(_cardBackImages.length)];

    // take bet
    gameState.subtractBalance(_currentBet);
    gameState.showLossAmount(_currentBet);

    setState(() {
      _playerCards = [_drawCard(), _drawCard()];
      _dealerCards = [_drawCard(), _drawCard()];
      _dealerHidden = true;
      _roundOver = false;
      _playerTurn = true;
      _message = "Hit or Stand";
    });

    if (_handTotal(_playerCards) == 21) {
      _endRound(autoFromDeal: true);
    }
  }

  void _hit() {
    if (!_playerTurn || _roundOver) return;

    setState(() => _playerCards.add(_drawCard()));

    if (_handTotal(_playerCards) > 21) _endRound();
  }

  void _stand() {
    if (!_playerTurn || _roundOver) return;

    setState(() {
      _playerTurn = false;
      _dealerHidden = false;
    });

    while (_handTotal(_dealerCards) < 17) {
      setState(() => _dealerCards.add(_drawCard()));
    }

    _endRound();
  }

  void _endRound({bool autoFromDeal = false}) {
    final gameState = Provider.of<GameState>(context, listen: false);

    setState(() {
      _dealerHidden = false;
      _roundOver = true;
      _playerTurn = false;
      _alreadyUsed = false;
    });

    final p = _handTotal(_playerCards);
    final d = _handTotal(_dealerCards);

    String result;
    int payout = 0;

    if (p > 21) {
      result = "You busted!";
    } else if (autoFromDeal && p == 21) {
      result = "Blackjack!";
      payout = (_currentBet * 5) ~/ 2;
    } else if (d > 21) {
      result = "Dealer busts! You win!";
      payout = _currentBet * 2;
    } else if (p > d) {
      result = "You win!";
      payout = _currentBet * 2;
    } else if (p < d) {
      result = "Dealer wins.";
    } else {
      result = "Push.";
      payout = _currentBet;
    }

    if (payout > 0) {
      gameState.addBalance(payout);
      final net = payout - _currentBet;
      if (net > 0) gameState.showWinAmount(net);
    }

    setState(() => _message = result);
  }

  //UI
  Widget _cardBack(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(_currentBackImage, fit: BoxFit.cover),
    );
  }

  Widget _cardFront(_BJCard card, double w, double h) {
    bool isRed = card.suit == '♥' || card.suit == '♦';

    return Container(
      width: w,
      height: h,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.rank,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isRed ? Colors.red : Colors.black,
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              card.suit,
              style: TextStyle(
                fontSize: 22,
                color: isRed ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dealerRow(double cw, double ch) {
    if (_dealerCards.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _dealerCards.asMap().entries.map((entry) {
        int index = entry.key;
        _BJCard card = entry.value;

        if (index == 1 && _dealerHidden && !_roundOver) {
          return _cardBack(cw, ch);
        }
        return _cardFront(card, cw, ch);
      }).toList(),
    );
  }

  Widget _playerRow(double cw, double ch) {
    if (_playerCards.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _playerCards.map((c) => _cardFront(c, cw, ch)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final size = MediaQuery.of(context).size;

    final cardWidth = size.width * 0.10;
    final cardHeight = cardWidth * 1.45;

    int dealerTotal;
    if (_dealerCards.isEmpty) {
      dealerTotal = 0;
    } else if (_dealerHidden && !_roundOver) {
      dealerTotal = _handTotal([_dealerCards.first]);
    } else {
      dealerTotal = _handTotal(_dealerCards);
    }

    final int playerTotal = _playerCards.isEmpty ? 0 : _handTotal(_playerCards);

    Future<void> delay() async {
      await Future.delayed(Duration(seconds: 3));
    }

    final BJHeader = Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            "BLACKJACK",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          Text(
            _message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Dealer Row
          Text(
            "Dealer ($dealerTotal)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          _dealerRow(cardWidth, cardHeight),

          const SizedBox(height: 30),

          // Player Row
          Text(
            "You ($playerTotal)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          _playerRow(cardWidth, cardHeight),
        ],
      ),
    );

    final BettingBox = Container(
      width: size.width * 0.24,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.shade400, width: 2),
      ),
      constraints: const BoxConstraints(minHeight: 350, maxHeight: 430),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //Bet Controls
          Column(
            children: [
              const Text(
                "BET",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                "\$$_betAmount",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        final next = _betAmount - _betStep;
                        if (next >= _minBet) _betAmount = next;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        final next = _betAmount + _betStep;
                        if (next <= gameState.balance) {
                          _betAmount = next;
                        }
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Text(
                "Balance: \$${gameState.balance}",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text("Min bet: \$500", style: TextStyle(fontSize: 11)),
              const SizedBox(height: 8),
              if (_currentBet > 0)
                Text(
                  "Current round bet:\n\$$_currentBet",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),

          //Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _deal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("DEAL", style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (_playerTurn && !_roundOver) ? _hit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    disabledBackgroundColor: Colors.green.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("HIT", style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_playerTurn && !_roundOver) ? _stand : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    disabledBackgroundColor: Colors.blue.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("STAND", style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final PowerupButton = GestureDetector(
      onTap: () async {
        if (_playerTurn) {
          if (gameState.checkBanana() && !_alreadyUsed) {
            _usePowerUp = true;
            _alreadyUsed = true;
            _dealerHidden = false;
            setState(() {});
            gameState.subtractBanana(1);
            await Future.delayed(const Duration(seconds: 1));
            _usePowerUp = false;
            setState(() {});
          } else if (!gameState.checkBanana()) {
            _noPowerUp = true;
            setState(() {});
            await Future.delayed(const Duration(seconds: 1));
            _noPowerUp = false;
            setState(() {});
          } else {
            _alreadyUsedError = true;
            setState(() {});
            await Future.delayed(const Duration(seconds: 1));
            _alreadyUsedError = false;
            setState(() {});
          }
        } else {
          _notStarted = true;
          setState(() {});
          await Future.delayed(const Duration(seconds: 1));
          _notStarted = false;
          setState(() {});
        }
      },
      child: Image.asset(
        width: size.width * 0.06,
        height: size.width * 0.06,
        'assets/images/powerup.png',
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BJHeader,
            Column(
              children: [
                BettingBox,
                PowerupButton,
                if (_notStarted)
                  Text(
                    'Start Game before Powering Up!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      letterSpacing: 1.5,
                    ),
                  ),

                if (_alreadyUsedError)
                  Text(
                    'Already used Power Up!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      letterSpacing: 1.5,
                    ),
                  ),

                if (_noPowerUp)
                  Text(
                    'No Banana Power Up!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      letterSpacing: 1.5,
                    ),
                  ),

                if (_usePowerUp)
                  Text(
                    'Banana Power Up Used!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
