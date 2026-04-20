import 'package:flutter/material.dart';

/// Jago POS Design System - Spacing
/// 
/// 4px grid system for consistent spacing throughout the app.
/// Based on multiples of 4 for visual harmony.

class AppSpacing {
  AppSpacing._();

  // ============================================
  // BASE UNIT
  // ============================================
  static const double unit = 4.0;

  // ============================================
  // SCALE
  // ============================================
  static const double none = 0;
  static const double xxs = unit;           // 4
  static const double xs = unit * 2;        // 8
  static const double sm = unit * 3;        // 12
  static const double md = unit * 4;        // 16
  static const double lg = unit * 6;        // 24
  static const double xl = unit * 8;        // 32
  static const double xxl = unit * 12;      // 48
  static const double xxxl = unit * 16;     // 64
  static const double huge = unit * 24;     // 96

  // ============================================
  // SECTION SPACING
  // ============================================
  static const double sectionSmall = lg;    // 24
  static const double sectionMedium = xl;   // 32
  static const double sectionLarge = xxl;   // 48

  // ============================================
  // COMPONENT SPACING
  // ============================================
  static const double buttonHeight = 52;
  static const double buttonIconSize = 20;
  static const double buttonPadding = md;   // 16

  static const double inputHeight = 56;
  static const double inputPadding = md;    // 16

  static const double cardPadding = md;     // 16
  static const double cardGap = sm;         // 12

  static const double listItemHeight = 72;
  static const double listItemGap = xs;     // 8

  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;

  // ============================================
  // EDGE INSETS HELPERS
  // ============================================
  static const EdgeInsets zero = EdgeInsets.zero;
  
  static EdgeInsets get allXs => const EdgeInsets.all(xs);
  static EdgeInsets get allSm => const EdgeInsets.all(sm);
  static EdgeInsets get allMd => const EdgeInsets.all(md);
  static EdgeInsets get allLg => const EdgeInsets.all(lg);
  static EdgeInsets get allXl => const EdgeInsets.all(xl);

  static EdgeInsets get horizontalXs => const EdgeInsets.symmetric(horizontal: xs);
  static EdgeInsets get horizontalSm => const EdgeInsets.symmetric(horizontal: sm);
  static EdgeInsets get horizontalMd => const EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get horizontalLg => const EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get horizontalXl => const EdgeInsets.symmetric(horizontal: xl);

  static EdgeInsets get verticalXs => const EdgeInsets.symmetric(vertical: xs);
  static EdgeInsets get verticalSm => const EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get verticalMd => const EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get verticalLg => const EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get verticalXl => const EdgeInsets.symmetric(vertical: xl);

  static EdgeInsets get screenPadding => const EdgeInsets.all(md);
  static EdgeInsets get cardPaddingInsets => const EdgeInsets.all(md);
  static EdgeInsets get listPadding => const EdgeInsets.symmetric(horizontal: md, vertical: xs);

  // ============================================
  // GAP WIDGETS
  // ============================================
  static const Widget gapNone = SizedBox.shrink();
  static const Widget gapXxs = SizedBox(width: xxs, height: xxs);
  static const Widget gapXs = SizedBox(width: xs, height: xs);
  static const Widget gapSm = SizedBox(width: sm, height: sm);
  static const Widget gapMd = SizedBox(width: md, height: md);
  static const Widget gapLg = SizedBox(width: lg, height: lg);
  static const Widget gapXl = SizedBox(width: xl, height: xl);
  static const Widget gapXxl = SizedBox(width: xxl, height: xxl);

  // Horizontal only
  static const Widget hGapXxs = SizedBox(width: xxs);
  static const Widget hGapXs = SizedBox(width: xs);
  static const Widget hGapSm = SizedBox(width: sm);
  static const Widget hGapMd = SizedBox(width: md);
  static const Widget hGapLg = SizedBox(width: lg);
  static const Widget hGapXl = SizedBox(width: xl);
  static const Widget hGapXxl = SizedBox(width: xxl);

  // Vertical only
  static const Widget vGapXxs = SizedBox(height: xxs);
  static const Widget vGapXs = SizedBox(height: xs);
  static const Widget vGapSm = SizedBox(height: sm);
  static const Widget vGapMd = SizedBox(height: md);
  static const Widget vGapLg = SizedBox(height: lg);
  static const Widget vGapXl = SizedBox(height: xl);
  static const Widget vGapXxl = SizedBox(height: xxl);
}

/// Extension for easy spacing
extension SpacingExtension on num {
  /// Create SizedBox with this value as height
  Widget get vGap => SizedBox(height: toDouble());

  /// Create SizedBox with this value as width
  Widget get hGap => SizedBox(width: toDouble());

  /// Create EdgeInsets with this value on all sides
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// Create EdgeInsets with this value horizontally
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// Create EdgeInsets with this value vertically
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());
}
