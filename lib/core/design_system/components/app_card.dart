import 'package:flutter/material.dart';
import 'package:pos_kita/core/design_system/tokens/typography.dart';

import '../tokens/colors.dart';
import '../tokens/shadows.dart';
import '../tokens/spacing.dart';

/// Jago POS Design System - Card
///
/// Premium card component simplified for better performance and clean logic.

enum AppCardVariant {
  elevated, // With shadow
  outlined, // Border only
  flat, // Subtle background
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.isSelected = false,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool isSelected;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? AppRadius.card;

    // Resolve colors and styles based on variant and state
    final Color effectiveBg =
        backgroundColor ??
        switch (variant) {
          AppCardVariant.flat => AppColors.surfaceVariant,
          _ => AppColors.surface,
        };

    final Border? effectiveBorder =
        isSelected || variant == AppCardVariant.outlined
        ? Border.all(
            color: isSelected
                ? AppColors.primary
                : (borderColor ?? AppColors.border),
            width: isSelected ? 2 : 1,
          )
        : null;

    final List<BoxShadow>? effectiveShadow =
        variant == AppCardVariant.elevated && !isSelected
        ? AppShadows.sm
        : (isSelected ? AppShadows.md : null);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(radius),
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Padding(padding: padding ?? AppSpacing.allMd, child: child),
        ),
      ),
    );
  }
}

/// Product card specific for POS
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.stock,
    this.color,
    this.onTap,
    this.isOutOfStock = false,
  });

  final String name;
  final String price;
  final String? imageUrl;
  final int? stock;
  final Color? color;
  final VoidCallback? onTap;
  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: isOutOfStock ? null : onTap,
      padding: AppSpacing.allSm,
      backgroundColor: isOutOfStock ? AppColors.neutral100 : null,
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color ?? AppColors.neutral200,
                borderRadius: BorderRadius.circular(AppRadius.md),
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null
                  ? const Icon(
                      Icons.image_outlined,
                      color: AppColors.textTertiary,
                      size: 24,
                    )
                  : null,
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (stock != null) ...[
                    AppSpacing.vGapXxs,
                    Text(
                      'Stok: $stock',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              price,
              style: AppTypography.priceSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat card for dashboard
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 20,
                  ),
                ),
                AppSpacing.hGapMd,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapXxs,
                    Text(
                      value,
                      style: AppTypography.priceMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            AppSpacing.vGapSm,
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
