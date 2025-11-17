import 'package:flutter/material.dart';

import 'Pages/main_menu.dart';

class theColors {
  static const Color lightPink = Color(0xFFed7dac);
  static const Color darkPink = Color(0xFFe42178);
}

void main() {
    runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenu()
      },
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: theColors.lightPink)
    ));
}
