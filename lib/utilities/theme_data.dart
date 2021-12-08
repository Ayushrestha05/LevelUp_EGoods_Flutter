import 'package:flutter/material.dart';
import 'package:levelup_egoods/utilities/size_config.dart';

ThemeData light = ThemeData(
    colorScheme: const ColorScheme.light(
  primary: Color(0xFF103388),
));

ThemeData dark = ThemeData(
  buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF103388), textTheme: ButtonTextTheme.primary),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6FFFE9),
    surface: Color(0xFF0B132B),
  ),
);
