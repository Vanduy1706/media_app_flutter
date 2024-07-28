import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black),
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey[200]!,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[500]!,
    secondaryContainer: Colors.grey[300]!,
  )
);