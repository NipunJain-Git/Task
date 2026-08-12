// Core theme and colors matching the web app (deep indigo primary, saffron accent)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary: deep indigo
  static const Color primary = Color(0xFF3730A3);
  static const Color primaryForeground = Color(0xFFF8F7FF);

  // Accent: saffron
  static const Color accent = Color(0xFFE07B2A);
  static const Color accentForeground = Color(0xFF3B2200);

  // Backgrounds
  static const Color background = Color(0xFFF9F8FF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color foreground = Color(0xFF1E1B3A);

  // Supporting
  static const Color muted = Color(0xFFF0EFF9);
  static const Color mutedForeground = Color(0xFF6B6880);
  static const Color border = Color(0xFFE4E3F0);
  static const Color secondary = Color(0xFFEEEDF9);
  static const Color secondaryForeground = Color(0xFF36345A);

  // Status
  static const Color destructive = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);

  // Dark theme
  static const Color darkBackground = Color(0xFF17162B);
  static const Color darkCard = Color(0xFF22213A);
  static const Color darkForeground = Color(0xFFF0EFF9);
  static const Color darkPrimary = Color(0xFF818CF8);
  static const Color darkBorder = Color(0xFF302F4A);
  static const Color darkMuted = Color(0xFF2A2945);
  static const Color darkMutedForeground = Color(0xFF9C9BB5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: primaryForeground,
      secondary: accent,
      onSecondary: accentForeground,
      error: destructive,
      onError: Colors.white,
      surface: card,
      onSurface: foreground,
    ),
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.notoSansTextTheme().copyWith(
      bodyLarge: GoogleFonts.notoSans(color: foreground),
      bodyMedium: GoogleFonts.notoSans(color: foreground),
      bodySmall: GoogleFonts.notoSans(color: mutedForeground),
      titleLarge: GoogleFonts.notoSans(
          color: foreground, fontWeight: FontWeight.w800),
      titleMedium: GoogleFonts.notoSans(
          color: foreground, fontWeight: FontWeight.w700),
      titleSmall: GoogleFonts.notoSans(
          color: foreground, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.notoSans(
          color: foreground, fontWeight: FontWeight.w700),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: card,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.notoSans(
        color: foreground,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(color: foreground),
    ),
    cardTheme: CardThemeData(
      color: card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: border, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: border, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      hintStyle: GoogleFonts.notoSans(color: mutedForeground),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: primaryForeground,
        elevation: 0,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: border, width: 2),
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(color: border, thickness: 1),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: card,
      selectedItemColor: primary,
      unselectedItemColor: mutedForeground,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle:
          GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w700),
      unselectedLabelStyle:
          GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w600),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: darkBackground,
      secondary: const Color(0xFFFBBF24),
      onSecondary: const Color(0xFF1C1400),
      error: const Color(0xFFEF4444),
      onError: Colors.white,
      surface: darkCard,
      onSurface: darkForeground,
    ),
    scaffoldBackgroundColor: darkBackground,
    textTheme: GoogleFonts.notoSansTextTheme(ThemeData.dark().textTheme).copyWith(
      bodyLarge: GoogleFonts.notoSans(color: darkForeground),
      bodyMedium: GoogleFonts.notoSans(color: darkForeground),
      bodySmall: GoogleFonts.notoSans(color: darkMutedForeground),
      titleLarge: GoogleFonts.notoSans(
          color: darkForeground, fontWeight: FontWeight.w800),
      titleMedium: GoogleFonts.notoSans(
          color: darkForeground, fontWeight: FontWeight.w700),
      titleSmall: GoogleFonts.notoSans(
          color: darkForeground, fontWeight: FontWeight.w600),
      labelLarge: GoogleFonts.notoSans(
          color: darkForeground, fontWeight: FontWeight.w700),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkCard,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.notoSans(
        color: darkForeground,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(color: darkForeground),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: darkBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: darkBorder, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: darkBorder, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: darkPrimary, width: 2),
      ),
      hintStyle: GoogleFonts.notoSans(color: darkMutedForeground),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
        elevation: 0,
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkCard,
      selectedItemColor: darkPrimary,
      unselectedItemColor: darkMutedForeground,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle:
          GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w700),
      unselectedLabelStyle:
          GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w600),
    ),
    dividerTheme:
        const DividerThemeData(color: darkBorder, thickness: 1),
  );
}
