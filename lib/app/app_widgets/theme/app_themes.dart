// lib/app/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryTeal = Color(0xFF015055); // Dark teal
  static const Color accentYellowGreen = Color(0xFFE2F299); // Light yellow-green
  static const Color backgroundColor = Color(0xFFFFFFFF); // Light grey
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        // Main heading style
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        // Accent text style (for "Outside", "Box")
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: accentYellowGreen,
        ),
        // Description text
        bodyLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        // Button text
        labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: accentYellowGreen,
        ),
      ),
    );
  }
}