import 'package:flutter/material.dart';
import 'Pages/Components/header.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  const AppLayout ({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        children: [
          Header(),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}