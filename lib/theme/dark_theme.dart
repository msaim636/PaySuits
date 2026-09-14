// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Raleway',
  primaryColor: const Color(0xFF1E604A),
  scaffoldBackgroundColor: const Color(0xFF1c1f26),
  disabledColor: const Color(0xFF7a7a7a),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFA0A4A8),
  cardColor: const Color(0xFF262a33),
  primarySwatch: DarkAppColor.primarySwatchValueColor,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xFF1E604A),
    error: const Color(0xFFE84D4F),
  ),
  splashFactory: NoSplash.splashFactory,
);

// primarySwatch color for dark theme MaterialColor
class DarkAppColor {
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
}
