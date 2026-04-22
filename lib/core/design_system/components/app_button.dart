import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/shadows.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Jago POS Design System - Button
///
/// Premium button component with:
/// - Tactile feedback (scale on press)
/// - Smooth transitions
/// - Loading states
/// - Multiple variants (filled, outlined, ghost, danger)

enum AppButtonVariant {
  filled, // Primary filled button
  outlined, // Outlined button
  ghost, // Transparent with hover
  danger, // Error state button
  success, // Success action button
}

enum AppButtonSize {
  small, // 40px height
  medium, // 48px height (default)
  large, // 56px height
}

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
  });

  const AppButton.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
  }) : variant = AppButtonVariant.filled;

  const AppButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.ghost({
    super.key,
    required this.onPressed,
    required this.label,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.onPressed,
    required this.label,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height,
  }) : variant = AppButtonVariant.danger;

  final VoidCallback? onPressed;
  final String label;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? width;
  final double? height;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  double get _height {
    if (widget.height != null) return widget.height!;
    switch (widget.size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double get _horizontalPadding {
    switch (widget.size) {
      case AppButtonSize.small:
        return AppSpacing.md;
      case AppButtonSize.medium:
        return AppSpacing.lg;
      case AppButtonSize.large:
        return AppSpacing.xl;
    }
  }

  Color get _backgroundColor {
    if (widget.isDisabled) return AppColors.disabled;

    switch (widget.variant) {
      case AppButtonVariant.filled:
        return AppColors.primary;
      case AppButtonVariant.outlined:
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return AppColors.error500;
      case AppButtonVariant.success:
        return AppColors.success500;
    }
  }

  Color get _foregroundColor {
    if (widget.isDisabled) return AppColors.onDisabled;

    switch (widget.variant) {
      case AppButtonVariant.filled:
      case AppButtonVariant.danger:
      case AppButtonVariant.success:
        return Colors.white;
      case AppButtonVariant.outlined:
      case AppButtonVariant.ghost:
        return AppColors.primary;
    }
  }

  Color get _borderColor {
    if (widget.isDisabled) return AppColors.disabled;

    switch (widget.variant) {
      case AppButtonVariant.filled:
      case AppButtonVariant.danger:
      case AppButtonVariant.success:
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.outlined:
        return AppColors.primary;
    }
  }

  List<BoxShadow> get _shadow {
    if (widget.isDisabled || widget.isLoading) return AppShadows.none;

    switch (widget.variant) {
      case AppButtonVariant.filled:
        return _isPressed ? AppShadows.none : AppShadows.primary;
      case AppButtonVariant.danger:
        return _isPressed ? AppShadows.none : AppShadows.error;
      case AppButtonVariant.success:
        return _isPressed ? AppShadows.none : AppShadows.success;
      case AppButtonVariant.outlined:
      case AppButtonVariant.ghost:
        return AppShadows.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = !widget.isDisabled && !widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: widget.width,
              height: _height,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(color: _borderColor, width: 1.5),
                boxShadow: _shadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isEnabled ? widget.onPressed : null,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  splashColor: Colors.white.withValues(alpha: 0.1),
                  highlightColor: Colors.white.withValues(alpha: 0.05),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.prefixIcon != null && !widget.isLoading) ...[
                          IconTheme(
                            data: IconThemeData(
                              color: _foregroundColor,
                              size: _iconSize,
                            ),
                            child: widget.prefixIcon!,
                          ),
                          AppSpacing.hGapSm,
                        ],
                        if (widget.isLoading)
                          SizedBox(
                            width: _iconSize,
                            height: _iconSize,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _foregroundColor,
                              ),
                            ),
                          )
                        else
                          Text(
                            widget.label,
                            style: AppTypography.labelLarge.copyWith(
                              color: _foregroundColor,
                            ),
                          ),
                        if (widget.suffixIcon != null && !widget.isLoading) ...[
                          AppSpacing.hGapSm,
                          IconTheme(
                            data: IconThemeData(
                              color: _foregroundColor,
                              size: _iconSize,
                            ),
                            child: widget.suffixIcon!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Icon button variant
class AppIconButton extends StatefulWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.ghost,
    this.isLoading = false,
    this.isDisabled = false,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _size {
    switch (widget.size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 44;
      case AppButtonSize.large:
        return 52;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case AppButtonSize.small:
        return 18;
      case AppButtonSize.medium:
        return 22;
      case AppButtonSize.large:
        return 26;
    }
  }

  Color get _backgroundColor {
    if (widget.isDisabled) return AppColors.disabled.withValues(alpha: 0.5);

    switch (widget.variant) {
      case AppButtonVariant.filled:
        return _isPressed ? AppColors.primary700 : AppColors.primary;
      case AppButtonVariant.outlined:
      case AppButtonVariant.ghost:
        return _isPressed ? AppColors.primary50 : Colors.transparent;
      case AppButtonVariant.danger:
        return _isPressed ? AppColors.error700 : AppColors.error500;
      case AppButtonVariant.success:
        return _isPressed ? AppColors.success700 : AppColors.success500;
    }
  }

  Color get _foregroundColor {
    if (widget.isDisabled) return AppColors.onDisabled;

    switch (widget.variant) {
      case AppButtonVariant.filled:
      case AppButtonVariant.danger:
      case AppButtonVariant.success:
        return Colors.white;
      case AppButtonVariant.outlined:
      case AppButtonVariant.ghost:
        return AppColors.primary;
    }
  }

  Color? get _borderColor {
    if (widget.isDisabled) return AppColors.disabled;

    switch (widget.variant) {
      case AppButtonVariant.outlined:
        return AppColors.border;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = !widget.isDisabled && !widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              if (isEnabled) {
                setState(() => _isPressed = true);
                _controller.forward();
              }
            },
            onTapUp: (_) {
              if (isEnabled) {
                setState(() => _isPressed = false);
                _controller.reverse();
              }
            },
            onTapCancel: () {
              if (isEnabled) {
                setState(() => _isPressed = false);
                _controller.reverse();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: _borderColor != null
                    ? Border.all(color: _borderColor!, width: 1.5)
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isEnabled ? widget.onPressed : null,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: _iconSize - 4,
                            height: _iconSize - 4,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _foregroundColor,
                              ),
                            ),
                          )
                        : IconTheme(
                            data: IconThemeData(
                              color: _foregroundColor,
                              size: _iconSize,
                            ),
                            child: widget.icon,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
