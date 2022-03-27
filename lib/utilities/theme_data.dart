import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFF6FFFE9),
    unselectedItemColor: Color(0xFFB8BDC9),
    backgroundColor: Color(0xFF112149),
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF103388),
  ),
);

ThemeData dark = ThemeData(
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: Color(0xFF6FFFE9),
    unselectedItemColor: Color(0xFFB8BDC9),
    backgroundColor: Color(0xFF112149),
  ),
  buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF103388), textTheme: ButtonTextTheme.primary),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6FFFE9),
    surface: Color(0xFF0B132B),
  ),
);
