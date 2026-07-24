import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  static const Color primaryDark = Color(0xFF1E7C6B);
  static const Color primaryLight = Color(0xFF4FBF9F);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primaryDark],
  );

  // Buttons
  static const Color buttonGreen = Color(0xFF2E9E6B);
  static const Color buttonBlue = Color(0xFF2F80ED);
  static const Color buttonRed = Color(0xFFE03B3B);

  static const Color safe = Color(0xFF1E9E5A);
  static const Color suspicious = Color(0xFFD32F2F);
  static const Color trusted = Color(0xFF1E9E5A);

  // Surfaces
  static const Color cardBackground = Colors.white;
  static const Color textFieldFill = Colors.white;
  static const Color scaffoldBackgroundDark = Color(0xFF121212);

  // Text
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textOnGradient = Colors.white;
}
