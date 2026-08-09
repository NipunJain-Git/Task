import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF1B4332);
  static const Color secondaryGold = Color(0xFFD4AF37);
  static const Color accentMint = Color(0xFFD8F3DC);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF212529);
  static const Color textLight = Color(0xFF6C757D);
  static const Color errorRed = Color(0xFFDC3545);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: secondaryGold,
        tertiary: accentMint,
        surface: backgroundLight,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: textDark),
        displayMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: textDark),
        displaySmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, color: textDark),
        headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textDark),
        titleLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: textDark),
        bodyLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.normal, color: textDark),
        bodyMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.normal, color: textLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorRed),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
