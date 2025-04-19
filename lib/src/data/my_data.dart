import 'package:flutter/material.dart';

class MyData {
  static const imageUrl = 'https://tinyurl.com/3hfa26cx';

  static const colorList = ['Green', 'Blue', 'Red', 'Purple'];

  static const colorMap = {
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Red': Color.fromARGB(255, 167, 44, 35),
    'Purple': Color(0xFF5e4caf),
  };

  static const gradientMap = {
    'Green': [Colors.green, Colors.greenAccent],
    'Blue': [Colors.blue, Colors.lightBlueAccent],
    'Red': [Colors.red, Colors.redAccent],
    'Purple': [Color(0xFF5a0cf0), Color(0xFFfef7ff)],
  };
}
