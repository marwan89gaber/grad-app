import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF00E5FF);
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color userMessage = Color(0xFF003366);
  static const Color aiMessage = Color(0xFF1A1A1A);
  static const Color textOnSurface = Color(0xFFE2E2E2);
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primary,
        surface: surface,
        background: background,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(color: primary, fontWeight: FontWeight.bold),
        bodyLarge: GoogleFonts.inter(color: textOnSurface),
        bodyMedium: GoogleFonts.inter(color: textOnSurface),
      ),
    );
  }
}
