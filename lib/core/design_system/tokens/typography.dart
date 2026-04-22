import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Jago POS Design System - Typography
///
/// Uses Plus Jakarta Sans - a geometric sans-serif with modern feel.
/// Designed for readability in POS environment with quick scanning.
///
/// Scale: Display → Headline → Title → Body → Label → Caption

class AppTypography {
  AppTypography._();

  // ============================================
  // FONT FAMILY
  // ============================================
  static String get fontFamily => 'Plus Jakarta Sans';

  /// Get the TextTheme for Material App
  static TextTheme get textTheme {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      // Display - Large impactful text
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      ),

      // Headline - Section headers
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.35,
      ),

      // Title - Card titles, list headers
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.45,
      ),

      // Body - Main content
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.6,
      ),

      // Label - Buttons, navigation
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.4,
      ),
    );
  }

  // ============================================
  // DIRECT STYLES - For direct use
  // ============================================

  // Display
  static TextStyle displayLarge = textTheme.displayLarge!;
  static TextStyle displayMedium = textTheme.displayMedium!;
  static TextStyle displaySmall = textTheme.displaySmall!;

  // Headline
  static TextStyle headlineLarge = textTheme.headlineLarge!;
  static TextStyle headlineMedium = textTheme.headlineMedium!;
  static TextStyle headlineSmall = textTheme.headlineSmall!;

  // Title
  static TextStyle titleLarge = textTheme.titleLarge!;
  static TextStyle titleMedium = textTheme.titleMedium!;
  static TextStyle titleSmall = textTheme.titleSmall!;

  // Body
  static TextStyle bodyLarge = textTheme.bodyLarge!;
  static TextStyle bodyMedium = textTheme.bodyMedium!;
  static TextStyle bodySmall = textTheme.bodySmall!;

  // Label
  static TextStyle labelLarge = textTheme.labelLarge!;
  static TextStyle labelMedium = textTheme.labelMedium!;
  static TextStyle labelSmall = textTheme.labelSmall!;

  // ============================================
  // SPECIAL STYLES - POS Specific
  // ============================================

  /// For price displays - uses tabular figures for alignment
  static TextStyle get priceLarge => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get priceMedium => GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.3,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  static TextStyle get priceSmall => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// For quantities and counters
  static TextStyle get quantity => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  /// For status badges
  static TextStyle get badge => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );
}

/// Extension for easy text styling
extension TextStyleExtension on TextStyle {
  /// Apply color to text style
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Apply font weight
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Apply letter spacing
  TextStyle withLetterSpacing(double spacing) =>
      copyWith(letterSpacing: spacing);
}
