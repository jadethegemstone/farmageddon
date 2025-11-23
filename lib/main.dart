import 'package:flutter/material.dart';

import 'layout.dart';

import 'Pages/main_menu.dart';
import 'Pages/loan_page.dart';
import 'Pages/slots_page.dart';
import 'Pages/plinko_page.dart';
import 'Pages/blackjack_page.dart';

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
    runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => AppLayout(child: MainMenu()),
        '/loan': (context) => AppLayout(child: LoanPage()),
        '/slots': (context) => AppLayout(child: SlotsPage()),
        '/plinko': (context) => AppLayout(child: PlinkoPage()),
        '/blackjack': (context) => AppLayout(child: BlackjackPage()),
      },
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: theColors.lightPink)
    ));
}
