import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color primary = Color(0xFF39FF14); // Neon Green
  static const Color secondary = Color(0xFF9D00FF); // Dark Purple
  static const Color accent = Color(0xFF00E5FF); // Electric Blue
  
  // Neutral Palette
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF666666);
  
  // Status Palette
  static const Color error = Color(0xFFFF0033);
  static const Color success = Color(0xFF39FF14);
  static const Color warning = Color(0xFFFFD300);
  static const Color info = Color(0xFF00E5FF);

  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [secondary, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
