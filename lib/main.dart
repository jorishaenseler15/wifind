import 'package:flutter/material.dart';
import 'package:wifind/screens/WiFindHomeScreen.dart';




void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primaryColorDark: Colors.blueAccent, primarySwatch: Colors.lightBlue)
      ),
      home: WiFindScreen(),
    );
  }
}


