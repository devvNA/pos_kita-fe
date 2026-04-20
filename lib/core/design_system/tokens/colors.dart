import 'package:flutter/material.dart';

/// Jago POS Design System - Colors
///
/// Warm Orange palette untuk POS Application.
/// Designed for energy, warmth, and trust in retail environment.

class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY PALETTE - Warm Orange
  // ============================================
  /// Primary Orange - energetic and attention-grabbing
  static const Color primary50 = Color(0xFFFFF7ED);
  static const Color primary100 = Color(0xFFFFEDD5);
  static const Color primary200 = Color(0xFFFED7AA);
  static const Color primary300 = Color(0xFFFDBA74); // Accent
  static const Color primary400 = Color(0xFFFB923C);
  static const Color primary500 = Color(0xFFF97316);
  static const Color primary600 = Color(0xFFEA580C); // Main Primary
  static const Color primary700 = Color(0xFFC2410C);
  static const Color primary800 = Color(0xFF9A3412); // Dark
  static const Color primary900 = Color(0xFF7C2D12);

  // ============================================
  // NEUTRAL PALETTE - Warm Gray
  // ============================================
  /// Warm gray scale - complements orange palette
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F4);
  static const Color neutral200 = Color(0xFFE7E5E4);
  static const Color neutral300 = Color(0xFFD6D3D1);
  static const Color neutral400 = Color(0xFFA8A29E);
  static const Color neutral500 = Color(0xFF78716C);
  static const Color neutral600 = Color(0xFF57534E);
  static const Color neutral700 = Color(0xFF44403C);
  static const Color neutral800 = Color(0xFF292524);
  static const Color neutral900 = Color(0xFF1C1917);

  // ============================================
  // TEXT COLORS - Slate
  // ============================================
  /// Primary text color
  static const Color textPrimary = Color(0xFF1F2937); // Gray 800
  static const Color textSecondary = Color(0xFF4B5563); // Gray 600
  static const Color textTertiary = Color(0xFF9CA3AF); // Gray 400
  static const Color textInverse = Colors.white;

  // ============================================
  // SEMANTIC COLORS
  // ============================================
  /// Success - Emerald (complements orange)
  static const Color success50 = Color(0xFFECFDF5);
  static const Color success100 = Color(0xFFD1FAE5);
  static const Color success500 = Color(0xFF10B981);
  static const Color success600 = Color(0xFF059669);
  static const Color success700 = Color(0xFF047857);

  /// Warning - Amber (harmonizes with orange)
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);

  /// Error - Rose (warm error color)
  static const Color error50 = Color(0xFFFFF1F2);
  static const Color error100 = Color(0xFFFFE4E6);
  static const Color error500 = Color(0xFFEF4444);
  static const Color error600 = Color(0xFFDC2626);
  static const Color error700 = Color(0xFFB91C1C);

  /// Info - Sky (cool contrast to orange)
  static const Color info50 = Color(0xFFF0F9FF);
  static const Color info100 = Color(0xFFE0F2FE);
  static const Color info500 = Color(0xFF0EA5E9);
  static const Color info600 = Color(0xFF0284C7);
  static const Color info700 = Color(0xFF0369A1);

  // ============================================
  // ALIASES - Semantic usage
  // ============================================
  /// Main primary color
  static const Color primary = primary600; // #EA580C
  static const Color primaryDark = primary800; // #9A3412
  static const Color accent = primary300; // #FDBA74
  static const Color onPrimary = Colors.white;

  /// Background colors
  static const Color background = Color(0xFFFFF7ED); // Warm cream
  static const Color surface = Colors.white;
  static const Color surfaceVariant = primary50; // #FFF7ED

  /// Border & Divider
  static const Color divider = Color(0xFFFED7AA); // primary200
  static const Color border = Color(0xFFFDBA74); // primary300

  /// Disabled states
  static const Color disabled = Color(0xFFE7E5E4); // neutral200
  static const Color onDisabled = Color(0xFFA8A29E); // neutral400

  // ============================================
  // SHADOW COLORS - Tinted with primary
  // ============================================
  /// Shadows tinted with orange hue
  static const Color shadowLight = Color(0x1AEA580C); // 10% primary
  static const Color shadowMedium = Color(0x26EA580C); // 15% primary
  static const Color shadowHeavy = Color(0x33EA580C); // 20% primary

  /// Neutral shadows
  static const Color shadowNeutral = Color(0x1A1C1917); // 10% neutral-900
  static const Color shadowNeutralMedium = Color(0x261C1917);

  // ============================================
  // GRADIENT PRESETS
  // ============================================
  static LinearGradient get primaryGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary500, primary700],
  );

  static LinearGradient get surfaceGradient => const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, background],
  );

  static LinearGradient get warmGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary400, primary600],
  );

  // ============================================
  // LEGACY COMPATIBILITY (deprecated)
  // ============================================
  @Deprecated('Use textPrimary instead of pure black')
  static const Color black = textPrimary;

  @Deprecated('Use neutral500 instead')
  static const Color grey = neutral500;

  @Deprecated('Use background instead')
  static const Color light = background;

  @Deprecated('Use primary100 instead')
  static const Color blueLight = primary100;

  static const Color white = Colors.white;

  /// Success alias
  static const Color success = success500;

  @Deprecated('Use success500 instead')
  static const Color green = success500;

  /// Error alias
  static const Color error = error500;

  @Deprecated('Use error500 instead')
  static const Color red = error500;

  @Deprecated('Use neutral200 instead')
  static const Color card = neutral200;

  static Color changeStringtoColor(String colorValue) {
    final value = colorValue.trim().toLowerCase();

    switch (value) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      case 'amber':
        return Colors.amber;
      case 'indigo':
        return Colors.indigo;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'primary':
        return primary;
    }

    final sanitized = value
        .replaceAll('color(', '')
        .replaceAll(')', '')
        .replaceAll('#', '')
        .replaceAll('0x', '');

    if (sanitized.length == 6 || sanitized.length == 8) {
      final normalizedHex = sanitized.length == 6 ? 'ff$sanitized' : sanitized;
      final parsedValue = int.tryParse(normalizedHex, radix: 16);

      if (parsedValue != null) {
        return Color(parsedValue);
      }
    }

    return Colors.red;
  }

  static String getColorString(Color color) {
    if (color == Colors.red) return 'red';
    if (color == Colors.blue) return 'blue';
    if (color == Colors.green) return 'green';
    if (color == Colors.yellow) return 'yellow';
    if (color == Colors.purple) return 'purple';
    if (color == Colors.orange) return 'orange';
    if (color == Colors.pink) return 'pink';
    if (color == Colors.teal) return 'teal';
    if (color == Colors.amber) return 'amber';
    if (color == Colors.indigo) return 'indigo';
    if (color == Colors.brown) return 'brown';
    if (color == Colors.grey) return 'grey';
    if (color == primary) return 'primary';

    final hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${hex.substring(2)}';
  }
}

/// Extension for color manipulation
extension ColorExtension on Color {
  /// Returns color with opacity
  Color withOpacityValue(double opacity) {
    return withAlpha((255 * opacity).round());
  }
}

Color changeStringtoColor(String colorValue) =>
    AppColors.changeStringtoColor(colorValue);

String getColorString(Color color) => AppColors.getColorString(color);
