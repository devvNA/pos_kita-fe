import 'package:flutter/material.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'app_button.dart';

/// Jago POS Design System - Empty State
///
/// Beautifully composed empty states with:
/// - Contextual illustrations
/// - Clear messaging
/// - Actionable CTA

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.icon,
    this.image,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final IconData? icon;
  final Widget? image;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Illustration
            if (image != null)
              image!
            else if (icon != null)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 56, color: AppColors.primary),
              )
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: 56,
                  color: AppColors.textTertiary,
                ),
              ),

            AppSpacing.vGapLg,

            // Title
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              AppSpacing.vGapSm,
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Actions
            if (actionLabel != null || secondaryActionLabel != null) ...[
              AppSpacing.vGapXl,
              if (actionLabel != null)
                AppButton.filled(
                  onPressed: onAction ?? () {},
                  label: actionLabel!,
                ),
              if (secondaryActionLabel != null) ...[
                AppSpacing.vGapMd,
                AppButton.outlined(
                  onPressed: onSecondaryAction ?? () {},
                  label: secondaryActionLabel!,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for no products
class EmptyProducts extends StatelessWidget {
  const EmptyProducts({super.key, this.onAddCategory, this.onAddProduct});

  final VoidCallback? onAddCategory;
  final VoidCallback? onAddProduct;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'Belum Ada Produk',
      subtitle: 'Mulai tambahkan produk untuk memulai penjualan.',
      actionLabel: 'Tambah Produk',
      onAction: onAddProduct,
      secondaryActionLabel: 'Tambah Kategori',
      onSecondaryAction: onAddCategory,
    );
  }
}

/// Empty state for no transactions
class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key, this.onStartSelling});

  final VoidCallback? onStartSelling;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'Belum Ada Transaksi',
      subtitle: 'Transaksi Anda akan muncul di sini setelah penjualan.',
      actionLabel: 'Mulai Jualan',
      onAction: onStartSelling,
    );
  }
}

/// Empty state for no search results
class EmptySearchResults extends StatelessWidget {
  const EmptySearchResults({super.key, this.query, this.onClear});

  final String? query;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.search_off_outlined,
      title: 'Tidak Ditemukan',
      subtitle: query != null
          ? 'Tidak ada hasil. Coba kata kunci lain.'
          : 'Tidak ada hasil yang sesuai dengan pencarian Anda.',
      actionLabel: 'Hapus Pencarian',
      onAction: onClear,
    );
  }
}

/// Empty state for offline mode
class EmptyOffline extends StatelessWidget {
  const EmptyOffline({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.cloud_off_outlined,
      title: 'Mode Offline',
      subtitle: 'Anda sedang offline. Data lokal akan ditampilkan.',
      actionLabel: 'Coba Lagi',
      onAction: onRetry,
    );
  }
}

/// Empty state for error
class EmptyError extends StatelessWidget {
  const EmptyError({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.error_outline,
      title: 'Terjadi Kesalahan',
      subtitle: message ?? 'Gagal memuat data. Silakan coba lagi.',
      actionLabel: 'Coba Lagi',
      onAction: onRetry,
    );
  }
}

/// Empty state for cart
class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key, this.onStartShopping});

  final VoidCallback? onStartShopping;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Keranjang Kosong',
      subtitle: 'Tambahkan produk untuk memulai checkout.',
      actionLabel: 'Mulai Belanja',
      onAction: onStartShopping,
    );
  }
}

/// Empty state for no categories
class EmptyCategories extends StatelessWidget {
  const EmptyCategories({super.key, this.onAddCategory});

  final VoidCallback? onAddCategory;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.folder_outlined,
      title: 'Belum Ada Kategori',
      subtitle: 'Buat kategori untuk mengorganisir produk Anda.',
      actionLabel: 'Tambah Kategori',
      onAction: onAddCategory,
    );
  }
}

/// Empty state for no staff
class EmptyStaff extends StatelessWidget {
  const EmptyStaff({super.key, this.onAddStaff});

  final VoidCallback? onAddStaff;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.people_outline,
      title: 'Belum Ada Staff',
      subtitle: 'Tambahkan staff untuk membantu mengelola toko.',
      actionLabel: 'Tambah Staff',
      onAction: onAddStaff,
    );
  }
}
