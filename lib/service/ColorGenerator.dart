import 'dart:math';

import 'package:flutter/material.dart';


class ColorGenerator {
  static List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.indigo,
    Colors.amber,
    Colors.black,
    Colors.pink,
    Colors.cyan
  ];

  static final Random _random = Random();

  static Color getColor() {
    return colorOptions[_random.nextInt(colorOptions.length)];
  }
}