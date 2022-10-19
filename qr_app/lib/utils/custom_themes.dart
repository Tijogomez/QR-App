import 'package:flutter/material.dart';

class CustomThemes {
  static getNormalStyle({size = 20.0, color = Colors.black}) {
    return TextStyle(fontSize: size, color: color);
  }

  static getBoldStyle({size = 20.0, color = Colors.black}) {
    return TextStyle(fontSize: size, color: color, fontWeight: FontWeight.bold);
  }
}
