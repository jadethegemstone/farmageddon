import 'package:flutter/material.dart';

import 'Pages/main_menu.dart';

class theColors {
  static const Color pageColor = Color(0xFFed7dac);
}

void main() {
    runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const MainMenu()
      },
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(scaffoldBackgroundColor: theColors.pageColor)
    ));
}
