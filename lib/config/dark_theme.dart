import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromRGBO(26, 25, 28, 1),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.dark(
    background: Color.fromRGBO(26, 25, 28, 1),
    primary: Colors.grey[100]!,
    secondary: Colors.grey[400]!,
    secondaryContainer: Colors.grey[100]!
  ),
);