import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'layout.dart';

import 'Pages/main_menu.dart';
import 'Pages/loan_page.dart';
import 'Pages/slots_page.dart';
import 'Pages/plinko_page.dart';
import 'Pages/blackjack_page.dart';

class GameState extends ChangeNotifier{
  static final GameState _instance = GameState._internal();
  factory GameState() => _instance;
  GameState._internal();

  int _balance = 0;
  int _lives = 5;
  int _totalLives = 5;
  int _fish = 0;
  int _apple = 0;
  int _banana = 0;

  int get balance => _balance;
  int get lives => _lives;
  int get totalLives => _totalLives;
  int get fish => _fish;
  int get apple => _apple;
  int get banana => _banana;

  void addBalance(int amount) {
    _balance += amount;
    notifyListeners();
  }

  void subtractBalance(int amount) {
    _balance -= amount;
    notifyListeners();
  }

  void subtractLives(int amount) {
    _lives -= amount;
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
          '/plinko': (context) => AppLayout(child: PlinkoPage()),
          '/blackjack': (context) => AppLayout(child: BlackjackPage()),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: theColors.lightPink),
      ),
    ),
  );
}
