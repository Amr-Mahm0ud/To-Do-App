import 'package:flutter/material.dart';

const Color prDarkClr = Color(0xFF0F4C81);
const Color prLightClr = Color(0xFF07689F);
const Color secDClr = Color(0xFFED6663);
const Color secLClr = Color(0xFFFFA372);
const Color white = Colors.white;
const Color darkGreyClr = Color(0xFF121212);

class Themes {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: prLightClr,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: white),
    iconTheme: const IconThemeData(color: darkGreyClr),
    colorScheme: const ColorScheme.light().copyWith(
        primary: prLightClr, secondary: secLClr, error: Colors.redAccent),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: prDarkClr,
      scaffoldBackgroundColor: darkGreyClr,
      brightness: Brightness.dark,
      appBarTheme:
          const AppBarTheme(elevation: 0, backgroundColor: darkGreyClr),
      iconTheme: const IconThemeData(color: white),
      colorScheme: const ColorScheme.dark()
          .copyWith(primary: prDarkClr, secondary: secDClr, error: Colors.red));
}
