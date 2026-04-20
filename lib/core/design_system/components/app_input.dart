import 'package:flutter/material.dart';
import 'package:pos_kita/core/design_system/tokens/shadows.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Jago POS Design System - Input
///
/// Premium input component with streamlined styling logic and modern Dart patterns.

enum AppInputSize {
  small, // 40px
  medium, // 48px
  large, // 56px
}

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.size = AppInputSize.medium,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helper;
  final String? error;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final AppInputSize size;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.error != null;

    final double iconSize = switch (widget.size) {
      AppInputSize.small => 18.0,
      AppInputSize.medium => 20.0,
      AppInputSize.large => 24.0,
    };

    final EdgeInsets contentPadding = switch (widget.size) {
      AppInputSize.small => const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      AppInputSize.medium => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      AppInputSize.large => const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelMedium.copyWith(
              color: hasError ? AppColors.error500 : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapXs,
        ],

        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _isObscured,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          textAlignVertical:
              TextAlignVertical.center, // Memastikan teks di tengah vertikal
          style: AppTypography.bodyMedium.copyWith(
            color: widget.enabled
                ? AppColors.textPrimary
                : AppColors.textTertiary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            isDense: true,
            contentPadding: contentPadding,
            border: InputBorder.none,
            counterText: '', // Sembunyikan counter default jika ada maxLength
            prefixIcon: widget.prefixIcon != null
                ? _buildPrefix(iconSize)
                : null,
            suffixIcon: _buildSuffix(iconSize),
            prefixIconConstraints: BoxConstraints(
              minWidth:
                  iconSize +
                  32, // Memberi ruang ekstra agar icon tidak menempel
            ),
            suffixIconConstraints: BoxConstraints(minWidth: iconSize + 32),
          ),
        ),

        if (hasError || widget.helper != null) ...[
          AppSpacing.vGapXs,
          Text(
            widget.error ?? widget.helper ?? '',
            style: AppTypography.bodySmall.copyWith(
              color: hasError ? AppColors.error500 : AppColors.textTertiary,
              fontWeight: hasError ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPrefix(double size) {
    return IconTheme(
      data: IconThemeData(color: AppColors.textTertiary, size: size),
      child: widget.prefixIcon!,
    );
  }

  Widget? _buildSuffix(double size) {
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () => setState(() => _isObscured = !_isObscured),
        child: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textTertiary,
          size: size,
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return IconTheme(
        data: IconThemeData(color: AppColors.textTertiary, size: size),
        child: widget.suffixIcon!,
      );
    }
    return null;
  }
}

/// Reactive search input field
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Cari produk atau kategori...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final searchController = controller ?? TextEditingController();

    return ValueListenableBuilder(
      valueListenable: searchController,
      builder: (context, value, _) {
        return AppTextField(
          controller: searchController,
          hint: hint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: value.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchController.clear();
                    onClear?.call();
                  },
                  child: const Icon(Icons.cancel_rounded, size: 20),
                )
              : null,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        );
      },
    );
  }
}

/// Optimized number input for POS
class AppNumberInput extends StatelessWidget {
  const AppNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAction(
            Icons.remove_rounded,
            value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 44,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: AppTypography.quantity.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildAction(
            Icons.add_rounded,
            value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, VoidCallback? onTap) {
    final bool isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.transparent : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: isDisabled ? null : AppShadows.xs,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled ? AppColors.textTertiary : AppColors.primary,
        ),
      ),
    );
  }
}
