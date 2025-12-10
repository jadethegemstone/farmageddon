import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'layout.dart';

import 'Pages/main_menu.dart';
import 'Pages/loan_page.dart';
import 'Pages/slots_page.dart';
import 'Pages/3card_monte.dart';
import 'Pages/blackjack_page.dart';

import 'Pages/Components/win.dart';
import 'Pages/Components/lose.dart';

class GameState extends ChangeNotifier{
  static final GameState _instance = GameState._internal();
  factory GameState() => _instance;
  GameState._internal() {
    // Initializes timer to 0
    _endTime = DateTime.now();
  }

  int _balance = 5000;
  int _lives = 5;
  int _totalLives = 5;
  int _fish = 0;
  int _apple = 0;
  int _banana = 0;

  int _currentLoan = 0;
  int _currentHearts = 0;

  DateTime _endTime = DateTime.now();
  bool _timerRunning = false;

  bool _showPopup = false;
  int _lastWinAmount = 0;
  int _lastLossAmount = 0;

  int get balance => _balance;
  int get lives => _lives;
  int get totalLives => _totalLives;
  int get fish => _fish;
  int get apple => _apple;
  int get banana => _banana;

  DateTime get endTime => _endTime;
  bool get timerRunning => _timerRunning;

  int get currentLoan => _currentLoan;
  int get currentHearts => _currentHearts;

  bool get showPopup => _showPopup;
  int get lastWinAmount => _lastWinAmount;
  int get lastLossAmount => _lastLossAmount;


  void addBalance(int amount) {
    _balance += amount;
    notifyListeners();
  }

  void subtractBalance(int amount) {
    _balance -= amount;
    notifyListeners();
  }

  void addFish(int amount) {
    _fish += amount;
    notifyListeners();
  }

  void subtractFish(int amount) {
    _fish -= amount;
    notifyListeners();
  }

  bool checkFish() {
    if(_fish == 0) {
      return false;
    } else {
      return true;
    }
  }

  void addApple(int amount) {
    _apple += amount;
    notifyListeners();
  }

  void subtractApple(int amount) {
    _apple -= amount;
    notifyListeners();
  }

  bool checkApple() {
    if(_apple == 0) {
      return false;
    } else {
      return true;
    }
  }

  void addBanana(int amount) {
    _banana += amount;
    notifyListeners();
  }

  void subtractBanana(int amount) {
    _banana -= amount;
    notifyListeners();
  }

  bool checkBanana() {
    if(_banana == 0) {
      return false;
    } else {
      return true;
    }
  }

  Set<String> ownedGames = {'slots'};

  void purchaseGame(String gameId, int cost) {
    if (_balance >= cost) {
      _balance -= cost;
      ownedGames.add(gameId);
      notifyListeners();
    }

  }

  void showWinAmount(int amount) {
    _showPopup = true;
    _lastWinAmount = amount;
    notifyListeners();

    Future.delayed(Duration(milliseconds: 300), () {
      _showPopup = false;
      _lastWinAmount = 0;
      notifyListeners();
    });
  }

  void showLossAmount(int amount) {
    _showPopup = true;
    _lastLossAmount = amount;
    notifyListeners();

    Future.delayed(Duration(milliseconds: 300), () {
      _showPopup = false;
      _lastLossAmount = 0;
      notifyListeners();
    });
  }

  void addLives(int amount) {
    _lives += amount;
    notifyListeners();
  }

  void subtractLives(int amount) {
    _lives -= amount;
    notifyListeners();
  }

  void restartGame() {
    _balance = 5000;
    _lives = 5;
    _currentHearts = 0;
    _currentLoan = 0;
    _endTime = DateTime.now();
    _timerRunning = false;
    notifyListeners();
  }

  void takeLoan(int loan, int hearts, int minutes) {
    if (_lives >= hearts && !_timerRunning) {
      _balance += loan;
      _currentLoan = loan;
      _currentHearts = hearts;
      addTime(minutes, 0);
    }
  }

  void addTime(int minutes, int seconds) {
    if (endTime!.isBefore(DateTime.now()) || endTime!.isAtSameMomentAs(DateTime.now())) {
      _endTime = DateTime.now().add(Duration(
        minutes: minutes,
        seconds: seconds,
      ));
      _timerRunning = true;
    }
    notifyListeners();
  }

  void onTimerEnd() {
    _timerRunning = false;
    // Check if player can pay back the loan
    if (_balance >= _currentLoan) {
      _balance -= _currentLoan;
    } else {
      _lives -= _currentHearts;
    }
    // Reset loan tracking
    _currentLoan = 0;
    _currentHearts = 0;
    notifyListeners();
  }
}

// Custom colors
class theColors {
  static const Color lightPink = Color(0xFFed7dac);
  static const Color darkPink = Color(0xFFe42178);
}

// Gets current screen size and also custom font sizes
extension ScreenSize on BuildContext{
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double get fontXXL => screenWidth * 0.05;
  double get fontXL => screenWidth * 0.04;
  double get fontL => screenWidth * 0.03;
  double get fontM => screenWidth * 0.02;
  double get fontS => screenWidth * 0.01;
}

// Use to fix pixel art resolution
class PixelArtImage extends StatelessWidget {
  final String assetPath;

  const PixelArtImage({
    Key? key,
    required this.assetPath,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset (
      assetPath,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.none,
    );
  }
}

// Routing
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => AppLayout(child: MainMenu()),
          '/loan': (context) => AppLayout(child: LoanPage()),
          '/slots': (context) => AppLayout(child: SlotsPage()),
          '/3cardmonte': (context) => AppLayout(child: ThreeCardMontePage()),
          '/blackjack': (context) => AppLayout(child: BlackjackPage()),
          '/win' : (context) => Win(),
          '/lose' : (context) => Lose(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: theColors.lightPink),
      ),
    ),
  );
}
