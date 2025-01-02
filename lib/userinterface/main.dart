import 'package:flutter/material.dart';
import 'package:frontend/userinterface/getbarang.dart';
import 'package:frontend/userinterface/home.dart';
import 'package:frontend/userinterface/splash.dart';
import 'package:frontend/userinterface/navigation.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}