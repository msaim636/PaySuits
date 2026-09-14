// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Raleway',
  primaryColor: const Color(0xFF1E604A),
  disabledColor: const Color(0xFF7a7a7a),
  scaffoldBackgroundColor: LightAppColor.backgroundColor,
  brightness: Brightness.light,
  hintColor: const Color(0xFFA0A4A8),
  cardColor: const Color(0xFFFFFFFF),
  primarySwatch: LightAppColor.primarySwatchValueColor,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color(0xFF1E604A),
    onPrimaryContainer: const Color(0xFFFFFFFF),
    error: const Color(0xFFE84D4F),
  ),
  splashFactory: NoSplash.splashFactory,
  // canvasColor: Colors.white,
);

// primarySwatch color for light theme MaterialColor and custom colors
class LightAppColor {
  static const int primarySwatchValue = 0xFF1E604A;
  static MaterialColor primarySwatchValueColor =
      MaterialColor(primarySwatchValue, <int, Color>{
        50: const Color(primarySwatchValue).withValues(alpha: 0.1),
        100: const Color(primarySwatchValue).withValues(alpha: 0.2),
        200: const Color(primarySwatchValue).withValues(alpha: 0.3),
        300: const Color(primarySwatchValue).withValues(alpha: 0.4),
        400: const Color(primarySwatchValue).withValues(alpha: 0.5),
        500: const Color(primarySwatchValue).withValues(alpha: 0.6),
        600: const Color(primarySwatchValue).withValues(alpha: 0.7),
        700: const Color(primarySwatchValue).withValues(alpha: 0.8),
        800: const Color(primarySwatchValue).withValues(alpha: 0.9),
        900: const Color(primarySwatchValue).withValues(alpha: 1.0),
      });

  static const Color primaryColor = Color(0xFF1E604A);
  static const Color backgroundColor = Color.fromARGB(255, 246, 246, 246);
  static const Color aquamarine = Color(0xff31c79b);
  static const Color bisque = Color(0xFFEC9C53);
  static const Color pink = Color(0xFFF5508C);
  static const Color dodgerBlue = Color(0xFF1F98FF);
  static const Color lime = Color(0xFF57BC2C);
  static const Color black = Color(0xF7000000);
  static const Color lightGray = Color(0xFFD9D9D9);
  static const Color purple = Color(0xFF7C1CBD);
  static const Color lightOrange = Color(0xFFFFAB00);
  static const Color lightYellow = Color(0xF2FFFF00);
  static const Color lightRed = Color(0xFFFF3E1D);
  static const Color graphSecondary = Color(0xFF0DBAEC);
  static const Color emeraldGreen = Color(0xFF1F8B4C);
  static const Color lightGreen = Color(0xFF6DC38D);
  static const Color blackGrey = Color(0xFF1F2A37);
  static const Color originGrey = Color(0xFFD7E1EC);
  static const Color darkGrey = Color(0xFF8A8A8A);
  static const Color lightPurple = Color(0xFF9B98B4);
  static const Color lightGrey = Color(0xFFF8F6FF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color disabledColor = Color(0xFFA0A4A8);
}
