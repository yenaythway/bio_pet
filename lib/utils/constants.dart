import 'package:flutter/material.dart';

/// App-wide color constants
class AppColors {
  // Background colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkBlueBackground = Color(0xFF0F172A);
  static const Color cardColor = Color(0xFF1E293B);
  static const Color cardBackgroundColor = Color(0xFF1E293B);

  // Primary colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color secondaryBlue = Color(0xFF60A5FA);

  // Text colors
  static const Color lightTextColor = Colors.white;
  static const Color faintTextColor = Color(0xFF94A3B8);

  // Action colors
  static const Color deleteIconColor = Color(0xFFEF4444);
}

/// App-wide text styles
class AppTextStyles {
  // Main title - large, bold
  static const TextStyle mainTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );

  // Subtitle - medium, normal weight
  static const TextStyle subTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF90CAF9),
  );

  // Heading - medium-large, bold
  static const TextStyle heading = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextColor,
  );

  // Body text - medium, regular
  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color(0xFFE0E0E0),
  );

  // Small text - small, regular
  static const TextStyle smallText = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Color(0xFFBBDEFB),
  );
}
