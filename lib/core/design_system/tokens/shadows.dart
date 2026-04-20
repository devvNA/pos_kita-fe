import 'package:flutter/material.dart';
import 'colors.dart';

/// Jago POS Design System - Shadows
/// 
/// Uses tinted shadows (not pure black) for cohesive appearance.
/// Shadows are layered for natural depth perception.

class AppShadows {
  AppShadows._();

  // ============================================
  // ELEVATION SHADOWS - Tinted with primary
  // ============================================
  
  /// No shadow
  static const List<BoxShadow> none = [];

  /// Elevation 1 - Subtle (cards at rest)
  static List<BoxShadow> get xs => [
    BoxShadow(
      color: AppColors.shadowNeutral.withOpacity(0.06),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// Elevation 2 - Light (cards hover, buttons)
  static List<BoxShadow> get sm => [
    BoxShadow(
      color: AppColors.shadowNeutral.withOpacity(0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: AppColors.shadowLight.withOpacity(0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// Elevation 3 - Medium (floating elements)
  static List<BoxShadow> get md => [
    BoxShadow(
      color: AppColors.shadowNeutral.withOpacity(0.08),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.shadowLight.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Elevation 4 - High (modals, drawers)
  static List<BoxShadow> get lg => [
    BoxShadow(
      color: AppColors.shadowNeutral.withOpacity(0.1),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppColors.shadowLight.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  /// Elevation 5 - Maximum (dialogs, bottom sheets)
  static List<BoxShadow> get xl => [
    BoxShadow(
      color: AppColors.shadowNeutral.withOpacity(0.12),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: AppColors.shadowLight.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];

  // ============================================
  // COLORED SHADOWS - For accents
  // ============================================
  
  /// Primary shadow for CTA elements
  static List<BoxShadow> get primary => [
    BoxShadow(
      color: AppColors.primary500.withOpacity(0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.primary500.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  /// Success shadow for positive actions
  static List<BoxShadow> get success => [
    BoxShadow(
      color: AppColors.success500.withOpacity(0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// Error shadow for negative actions
  static List<BoxShadow> get error => [
    BoxShadow(
      color: AppColors.error500.withOpacity(0.25),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ============================================
  // INSET SHADOWS - For inner depth
  // ============================================
  
  /// Inner shadow for pressed states
  static List<BoxShadow> get inner => [
    BoxShadow(
      color: AppColors.shadowNeutral.withOpacity(0.08),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // ============================================
  // GLOW SHADOWS - For highlights
  // ============================================
  
  /// Subtle glow for active states
  static List<BoxShadow> get glowPrimary => [
    BoxShadow(
      color: AppColors.primary500.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: -4,
    ),
  ];

  static List<BoxShadow> get glowSuccess => [
    BoxShadow(
      color: AppColors.success500.withOpacity(0.3),
      blurRadius: 20,
      spreadRadius: -4,
    ),
  ];

  // ============================================
  // DECORATION HELPERS
  // ============================================
  
  /// Card decoration with shadow
  static BoxDecoration card({
    Color? color,
    double? borderRadius,
    List<BoxShadow>? shadow,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
      boxShadow: shadow ?? sm,
    );
  }

  /// Floating action button decoration
  static BoxDecoration get fab => BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppRadius.full),
    boxShadow: primary,
  );
}

/// Extension for shadow application
extension ShadowExtension on Widget {
  /// Wrap widget with shadow container
  Widget withShadow({
    List<BoxShadow>? shadow,
    Color? color,
    double? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
        boxShadow: shadow ?? AppShadows.sm,
      ),
      child: this,
    );
  }
}

/// Border radius tokens
class AppRadius {
  AppRadius._();

  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 9999;

  // Semantic
  static const double button = md;     // 12
  static const double input = md;      // 12
  static const double card = lg;       // 16
  static const double chip = full;     // Pill
  static const double badge = sm;      // 8
  static const double modal = xl;      // 20
}
