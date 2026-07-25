import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central ThemeData for CyberMail. Applied once in main.dart / app.dart
/// via MaterialApp(theme: AppTheme.light).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        primary: AppColors.primaryDark,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimary),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.textFieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
