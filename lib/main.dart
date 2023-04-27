import 'package:flutter/material.dart';
import 'package:naverwebtoon_clone/home/home_screen.dart';
import 'package:naverwebtoon_clone/main_navigation_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MainNavigationScreen(),
    );
  }
}