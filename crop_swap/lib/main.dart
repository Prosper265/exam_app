import 'package:crop_swap/screens/authScreen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const CropSwapApp());
}

class CropSwapApp extends StatelessWidget {
  const CropSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CropSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

