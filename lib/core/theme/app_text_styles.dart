import 'package:flutter/material.dart';

/// Color-agnostic text styles — colors come from the theme's textTheme.apply().
abstract final class AppTextStyles {
  static const String _heading = 'PlusJakartaSans';
  static const String _body = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: _heading,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _heading,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: _heading,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _heading,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );

  static const TextStyle statNumber = TextStyle(
    fontFamily: _heading,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1,
  );

  static const TextStyle navLabel = TextStyle(
    fontFamily: _body,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
