import 'package:flutter/material.dart';

ThemeClass _themeClass = ThemeClass();

class ThemeClass {
  Color lightGeneralColor = const Color(0xFFB9B9B9);
  Color lightBackgroundColor = const Color(0xFFDADADA);
  Color lightPrimaryColor = const Color(0xFF222831);

  Color darkGeneralColor = const Color(0xFF31363F);
  Color darkBackgroundColor = const Color(0xFF222831);
  Color darkPrimaryColor = const Color(0xFFE1CDB5);

  Color accentColor = const Color(0xFF00ADB5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: _themeClass.lightGeneralColor,
    dividerColor: Colors.black.withOpacity(0.5),
    colorScheme: const ColorScheme.light().copyWith(
      background: _themeClass.lightBackgroundColor,
      primary: _themeClass.lightPrimaryColor,
      secondary: Colors.black,
      tertiary: _themeClass.accentColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: _themeClass.darkGeneralColor,
    dividerColor: Colors.white.withOpacity(0.5),
    colorScheme: const ColorScheme.dark().copyWith(
      background: _themeClass.darkBackgroundColor,
      primary: _themeClass.darkPrimaryColor,
      secondary: Colors.white,
      tertiary: _themeClass.accentColor,
    ),
  );
}
