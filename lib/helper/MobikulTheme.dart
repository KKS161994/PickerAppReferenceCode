import 'package:flutter/material.dart';

class MobikulTheme {
  static Color primaryColor = Colors.white;
  static Color accentColor = Color(0xFF6CB1E1);

  static Color backgroundColor = Colors.white;

  static Color actionBarItemColor = Color(0xFF000000);

  static Color textColorPrimary = Color(0xFF000000);
  static Color textColorSecondary = Color(0xFF8A8A8A);
  static Color textColorLink = Color(0xFF3F60DA);

  static Color buttonBackgroundGrey = Color(0xFFE0E0E0);

  static ThemeData mobikulTheme = ThemeData(
    fontFamily: 'Montserrat',
    primaryColor: primaryColor,
    accentColor: accentColor,
    textTheme: TextTheme(
      headline: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black),
      title: TextStyle(
          fontSize: 16.0, color: Colors.black, fontFamily: 'Montserrat'),
      body1: TextStyle(
          fontSize: 14.0, color: Colors.black, fontFamily: 'Montserrat'),
    ),
  );
}
